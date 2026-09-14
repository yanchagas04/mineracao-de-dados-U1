import psycopg2
from psycopg2.extras import execute_values
import oracledb
import unicodedata
import sys

if sys.stdout.encoding != 'utf-8':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

# ============================================================
# CONFIGURAÇÕES DE CONEXÃO
# ============================================================

ORACLE_CONFIG = {
    "user": "C##SA",
    "password": "cimatec",
    "dsn": "localhost:1521/XE"
}

POSTGRES_DW_CONFIG = {
    "host": "localhost",
    "port": 5434,
    "database": "petshop_dw",
    "user": "postgres",
    "password": "cimatec"
}

print("=" * 70)
print("INICIANDO PROCESSO DE LOAD NO DATA WAREHOUSE (POSTGRESQL)")
print("=" * 70)

# ============================================================
# 1. CONEXÕES
# ============================================================

oracle_conn = oracledb.connect(**ORACLE_CONFIG)
oracle_cur = oracle_conn.cursor()
print("✓ Conectado ao Oracle Staging (C##SA)")

pg_conn = psycopg2.connect(**POSTGRES_DW_CONFIG)
pg_cur = pg_conn.cursor()
print("✓ Conectado ao PostgreSQL Data Warehouse (petshop_dw)")


# ============================================================
# 2. LIMPEZA COMPLETA DO DW (IDEMPOTÊNCIA)
# ============================================================

print("\n--- LIMPEZA DO DW ---")
pg_cur.execute("""
    TRUNCATE fato_vendas, fato_vendas_concorrente, 
             dim_tempo, dim_estado_civil, dim_produto, dim_loja 
    RESTART IDENTITY CASCADE;
""")
pg_conn.commit()
print("✓ Tabelas do DW truncadas com sucesso.")


# ============================================================
# 3. CARGA DA DIMENSÃO TEMPO (dim_tempo)
# Granularidade Quadrimestral e Anual cobrindo 2024 e 2025 (6 registros)
# SK_TEMPO como sequência numérica sequencial (1 a 6)
# ============================================================

print("\n--- CARGA: dim_tempo (QUADRIMESTRAL) ---")

tempo_records = [
    (1, 2024, 1),
    (2, 2024, 2),
    (3, 2024, 3),
    (4, 2025, 1),
    (5, 2025, 2),
    (6, 2025, 3),
]

execute_values(pg_cur, """
    INSERT INTO dim_tempo (sk_tempo, ano, quadrimestre)
    VALUES %s
""", tempo_records)
pg_conn.commit()

# Mapa em memória: (ano, quadrimestre) -> sk_tempo (1 a 6)
tempo_map = {(ano, quad): sk for sk, ano, quad in tempo_records}

print(f"✓ {len(tempo_records)} registros carregados em dim_tempo (sequência numérica 1 a 6).")


# ============================================================
# 4. CARGA DA DIMENSÃO LOJA (dim_loja)
# ============================================================

print("\n--- CARGA: dim_loja ---")

lojas_dados = [
    ("Pet Shop Nosso Aumigo - Matriz Salvador", "Salvador", "BA", "Matriz", "Oracle (C##PETSHOP)"),
    ("Pet Shop Nosso Aumigo - Filial Itabuna", "Itabuna", "BA", "Filial", "PostgreSQL (Supabase)"),
    ("Pet Shop Nosso Aumigo - Filial Feira de Santana", "Feira de Santana", "BA", "Filial", "MongoDB")
]

pg_cur.executemany("""
    INSERT INTO dim_loja (nome_loja, cidade, estado, tipo_unidade, sistema_origem)
    VALUES (%s, %s, %s, %s, %s)
""", lojas_dados)
pg_conn.commit()

# Mapa de Loja: cidade/origem -> sk_loja
pg_cur.execute("SELECT sk_loja, cidade FROM dim_loja")
loja_map = {cidade: sk for sk, cidade in pg_cur.fetchall()}
print(f"✓ {len(loja_map)} lojas carregadas em dim_loja: {loja_map}")


# ============================================================
# 5. CARGA DA DIMENSÃO ESTADO CIVIL (dim_estado_civil)
# Mapeia apenas os estados civis distintos padronizados
# ============================================================

print("\n--- CARGA: dim_estado_civil ---")

fontes_clientes = [
    ("Salvador", "STG_SALVADOR_CLIENTES"),
    ("Itabuna",  "STG_ITABUNA_CLIENTES"),
    ("Feira",    "STG_FEIRA_CLIENTES")
]

cliente_estado_civil = {}
estados_civis_set = set()

for origem, tabela in fontes_clientes:
    oracle_cur.execute(f"""
        SELECT ID_CLIENTE, ESTADO_CIVIL
        FROM {tabela}
        ORDER BY ID_CLIENTE
    """)
    for bk_id, est_civil in oracle_cur.fetchall():
        est_civil_clean = est_civil.strip() if est_civil else "Não Informado"
        cliente_estado_civil[(bk_id, origem)] = est_civil_clean
        estados_civis_set.add(est_civil_clean)

# Inserção dos estados civis distintos
dados_insercao_ec = [(ec,) for ec in sorted(estados_civis_set)]

execute_values(pg_cur, """
    INSERT INTO dim_estado_civil (estado_civil)
    VALUES %s
""", dados_insercao_ec)
pg_conn.commit()

# Mapa: estado_civil -> sk_estado_civil
pg_cur.execute("SELECT sk_estado_civil, estado_civil FROM dim_estado_civil")
estado_civil_map = {ec: sk for sk, ec in pg_cur.fetchall()}

# Mapa em memória para relacionar vendas: (bk_id_cliente, origem) -> sk_estado_civil
cliente_sk_ec_map = {
    chave: estado_civil_map[ec]
    for chave, ec in cliente_estado_civil.items()
}
print(f"✓ Total em dim_estado_civil: {len(dados_insercao_ec)} estados civis carregados: {sorted(estados_civis_set)}")


# ============================================================
# 6. CARGA DA DIMENSÃO PRODUTO (dim_produto)
# Unifica e agrega o catálogo de produtos das 3 filiais (sem preço de referência)
# Mantém o id_origem e consolida variações textuais
# ============================================================

print("\n--- CARGA: dim_produto (AGREGADA) ---")

def normalizar_texto_chave(txt):
    if not txt:
        return ""
    s = unicodedata.normalize("NFD", txt.strip().title())
    return "".join(c for c in s if unicodedata.category(c) != "Mn")

fontes_produtos = [
    ("Salvador", "STG_SALVADOR_PRODUTOS"),
    ("Itabuna",  "STG_ITABUNA_PRODUTOS"),
    ("Feira",    "STG_FEIRA_PRODUTOS")
]

produtos_agregados = {}
produto_chave_origem = {}

for origem, tabela in fontes_produtos:
    oracle_cur.execute(f"""
        SELECT ID_PRODUTO, NOME_PRODUTO, CATEGORIA
        FROM {tabela}
        ORDER BY ID_PRODUTO
    """)
    for bk_id, nome, categoria in oracle_cur.fetchall():
        chave = normalizar_texto_chave(nome)
        produto_chave_origem[(bk_id, origem)] = chave
        
        if chave not in produtos_agregados:
            nome_limpo = " ".join(nome.strip().title().split())
            cat_limpa = " ".join(categoria.strip().title().split()) if categoria else "Outros"
            produtos_agregados[chave] = {
                "id_origem": bk_id,
                "nome_produto": nome_limpo,
                "categoria": cat_limpa
            }

dados_insercao_produtos = [
    (info["id_origem"], info["nome_produto"], info["categoria"])
    for info in produtos_agregados.values()
]

execute_values(pg_cur, """
    INSERT INTO dim_produto (id_origem, nome_produto, categoria)
    VALUES %s
""", dados_insercao_produtos)
pg_conn.commit()

# Mapa em memória: nome_produto -> sk_produto
pg_cur.execute("SELECT sk_produto, nome_produto FROM dim_produto")
sk_por_nome = {nome: sk for sk, nome in pg_cur.fetchall()}

# Mapa final: (bk_id_produto, origem) -> sk_produto
produto_map = {}
for chave_prod, info in produtos_agregados.items():
    sk = sk_por_nome[info["nome_produto"]]
    for (bk_id, origem), ch in produto_chave_origem.items():
        if ch == chave_prod:
            produto_map[(bk_id, origem)] = sk

print(f"✓ Total em dim_produto: {len(dados_insercao_produtos)} produtos únicos agregados.")


# ============================================================
# ============================================================
# 7. CARGA DA TABELA FATO DE VENDAS (fato_vendas)
# Apenas tuplas com vendas efetivas (SEM ZERO)
# ============================================================

print("\n--- CARGA: fato_vendas (SEM ZERO) ---")

fato_registros = {}
total_itens_processados = 0

# 7.1 Salvador
sk_loja_ssa = loja_map["Salvador"]
oracle_cur.execute("""
    SELECT 
        EXTRACT(YEAR FROM v.DATA_VENDA) AS ANO,
        EXTRACT(MONTH FROM v.DATA_VENDA) AS MES,
        v.ID_CLIENTE,
        i.ID_PRODUTO,
        i.QUANTIDADE,
        (i.QUANTIDADE * i.PRECO_UNITARIO) AS VALOR_ITEM
    FROM STG_SALVADOR_VENDAS v
    JOIN STG_SALVADOR_ITENS_VENDA i ON v.ID_VENDA = i.ID_VENDA
""")
rows_ssa = oracle_cur.fetchall()
total_itens_processados += len(rows_ssa)
for ano, mes, bk_cli, bk_prod, qtd, vlr in rows_ssa:
    quad = (int(mes) - 1) // 4 + 1
    sk_tempo = tempo_map[(int(ano), quad)]
    sk_ec = cliente_sk_ec_map.get((bk_cli, "Salvador"))
    sk_prod = produto_map.get((bk_prod, "Salvador"))
    chave = (sk_tempo, sk_ec, sk_prod, sk_loja_ssa)
    if chave not in fato_registros:
        fato_registros[chave] = [0, 0.0]
    fato_registros[chave][0] += qtd
    fato_registros[chave][1] += float(vlr)

print(f"  [Salvador] {len(rows_ssa)} itens processados.")

# 7.2 Itabuna
sk_loja_ita = loja_map["Itabuna"]
oracle_cur.execute("""
    SELECT 
        EXTRACT(YEAR FROM v.DATA_VENDA) AS ANO,
        EXTRACT(MONTH FROM v.DATA_VENDA) AS MES,
        v.ID_CLIENTE,
        i.ID_PRODUTO,
        i.QUANTIDADE,
        (i.QUANTIDADE * i.PRECO_UNITARIO) AS VALOR_ITEM
    FROM STG_ITABUNA_VENDAS v
    JOIN STG_ITABUNA_ITENS_VENDA i ON v.ID_VENDA = i.ID_VENDA
""")
rows_ita = oracle_cur.fetchall()
total_itens_processados += len(rows_ita)
for ano, mes, bk_cli, bk_prod, qtd, vlr in rows_ita:
    quad = (int(mes) - 1) // 4 + 1
    sk_tempo = tempo_map[(int(ano), quad)]
    sk_ec = cliente_sk_ec_map.get((bk_cli, "Itabuna"))
    sk_prod = produto_map.get((bk_prod, "Itabuna"))
    chave = (sk_tempo, sk_ec, sk_prod, sk_loja_ita)
    if chave not in fato_registros:
        fato_registros[chave] = [0, 0.0]
    fato_registros[chave][0] += qtd
    fato_registros[chave][1] += float(vlr)

print(f"  [Itabuna] {len(rows_ita)} itens processados.")

# 7.3 Feira de Santana
sk_loja_fsa = loja_map["Feira de Santana"]
oracle_cur.execute("""
    SELECT 
        EXTRACT(YEAR FROM p.DATA_PEDIDO) AS ANO,
        EXTRACT(MONTH FROM p.DATA_PEDIDO) AS MES,
        p.ID_CLIENTE,
        i.ID_PRODUTO,
        i.QUANTIDADE,
        (i.QUANTIDADE * i.PRECO_UNITARIO) AS VALOR_ITEM
    FROM STG_FEIRA_PEDIDOS p
    JOIN STG_FEIRA_ITENS_PEDIDO i ON p.ID_PEDIDO = i.ID_PEDIDO
""")
rows_fsa = oracle_cur.fetchall()
total_itens_processados += len(rows_fsa)
for ano, mes, bk_cli, bk_prod, qtd, vlr in rows_fsa:
    quad = (int(mes) - 1) // 4 + 1
    sk_tempo = tempo_map[(int(ano), quad)]
    sk_ec = cliente_sk_ec_map.get((bk_cli, "Feira"))
    sk_prod = produto_map.get((bk_prod, "Feira"))
    chave = (sk_tempo, sk_ec, sk_prod, sk_loja_fsa)
    if chave not in fato_registros:
        fato_registros[chave] = [0, 0.0]
    fato_registros[chave][0] += qtd
    fato_registros[chave][1] += float(vlr)

print(f"  [Feira de Santana] {len(rows_fsa)} itens processados.")

# Prepara tuplas para inserção em lote (apenas vendas efetivas, sem zero)
fato_rows = [
    (k[0], k[1], k[2], k[3], v[0], round(v[1], 2))
    for k, v in sorted(fato_registros.items())
    if v[0] > 0
]

execute_values(pg_cur, """
    INSERT INTO fato_vendas (sk_tempo, sk_estado_civil, sk_produto, sk_loja, quantidade_vendida, valor_total_venda)
    VALUES %s
""", fato_rows, page_size=2000)
pg_conn.commit()

print(f"✓ Total em fato_vendas: {len(fato_rows)} registros carregados (SEM ZERO).")


# ============================================================
# 8. CARGA DA TABELA FATO DO CONCORRENTE (fato_vendas_concorrente)
# Mapeamento agrupado por quadrimestre (sk_tempo: YYYYQ)
# ============================================================

print("\n--- CARGA: fato_vendas_concorrente (QUADRIMESTRAL) ---")

mapa_meses_sigla = {
    "jan": 1, "fev": 2, "mar": 3, "abr": 4,
    "mai": 5, "jun": 6, "jul": 7, "ago": 8,
    "set": 9, "out": 10, "nov": 11, "dez": 12
}

oracle_cur.execute("""
    SELECT ANO, MES, VENDAS
    FROM STG_CONCORRENTE_VENDAS
    ORDER BY ANO, MES
""")
rows_concorrente = oracle_cur.fetchall()

concorrente_agg = {}
for ano, mes_sigla, valor in rows_concorrente:
    num_mes = mapa_meses_sigla.get(mes_sigla.strip().lower())
    if num_mes:
        quad = (num_mes - 1) // 4 + 1
        sk_tempo = tempo_map[(ano, quad)]
        concorrente_agg[sk_tempo] = concorrente_agg.get(sk_tempo, 0.0) + float(valor)

concorrente_rows = [
    (sk, round(v, 2))
    for sk, v in sorted(concorrente_agg.items())
]

execute_values(pg_cur, """
    INSERT INTO fato_vendas_concorrente (sk_tempo, valor)
    VALUES %s
""", concorrente_rows)
pg_conn.commit()

print(f"✓ Total em fato_vendas_concorrente: {len(concorrente_rows)} registros quadrimestrais carregados.")


# ============================================================
# 9. FINALIZAÇÃO E RELATÓRIO
# ============================================================

print("\n" + "=" * 70)
print("LOAD CONCLUÍDO COM SUCESSO!")
print("=" * 70)

resumo_tabelas = [
    "dim_tempo", "dim_loja", "dim_estado_civil", "dim_produto", 
    "fato_vendas", "fato_vendas_concorrente"
]

print("📊 Resumo da Volumetria no Data Warehouse:")
for tab in resumo_tabelas:
    pg_cur.execute(f"SELECT COUNT(*) FROM {tab}")
    cnt = pg_cur.fetchone()[0]
    print(f"  • {tab:<25}: {cnt:>6} registros")

oracle_cur.close()
oracle_conn.close()
pg_cur.close()
pg_conn.close()
