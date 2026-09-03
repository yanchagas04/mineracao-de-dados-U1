import psycopg2
from psycopg2.extras import execute_values
import oracledb

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
             dim_tempo, dim_cliente, dim_produto, dim_loja 
    RESTART IDENTITY CASCADE;
""")
pg_conn.commit()
print("✓ Tabelas do DW truncadas com sucesso.")


# ============================================================
# 3. CARGA DA DIMENSÃO TEMPO (dim_tempo)
# Granularidade mensal cobrindo 2024 e 2025 (24 meses)
# Inclui ano e quadrimestre para responder aos requisitos de BI
# ============================================================

print("\n--- CARGA: dim_tempo ---")

meses_nomes = [
    "Janeiro", "Fevereiro", "Março", "Abril",
    "Maio", "Junho", "Julho", "Agosto",
    "Setembro", "Outubro", "Novembro", "Dezembro"
]

tempo_records = []
for ano in [2024, 2025]:
    for mes in range(1, 13):
        sk_tempo = ano * 100 + mes
        nome_mes = meses_nomes[mes - 1]
        ano_mes = f"{ano}-{mes:02d}"
        quadrimestre = (mes - 1) // 4 + 1
        nome_quadrimestre = f"{quadrimestre}º Quadrimestre"
        
        tempo_records.append((
            sk_tempo, ano, mes, nome_mes, ano_mes, quadrimestre, nome_quadrimestre
        ))

execute_values(pg_cur, """
    INSERT INTO dim_tempo (sk_tempo, ano, mes, nome_mes, ano_mes, quadrimestre, nome_quadrimestre)
    VALUES %s
""", tempo_records)
pg_conn.commit()

print(f"✓ {len(tempo_records)} registros carregados em dim_tempo (2024 a 2025).")


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
# 5. CARGA DA DIMENSÃO CLIENTE (dim_cliente)
# Mapeia clientes das 3 fontes usando bk_id_cliente e origem_fonte
# ============================================================

print("\n--- CARGA: dim_cliente ---")

fontes_clientes = [
    ("Salvador", "STG_SALVADOR_CLIENTES"),
    ("Itabuna",  "STG_ITABUNA_CLIENTES"),
    ("Feira",    "STG_FEIRA_CLIENTES")
]

total_clientes = 0
for origem, tabela in fontes_clientes:
    oracle_cur.execute(f"""
        SELECT ID_CLIENTE, NOME, EMAIL, TELEFONE, SEXO, ESTADO_CIVIL, DATA_NASCIMENTO
        FROM {tabela}
        ORDER BY ID_CLIENTE
    """)
    rows = oracle_cur.fetchall()
    
    dados_insercao = []
    for r in rows:
        bk_id, nome, email, tel, sexo, est_civil, dt_nasc = r
        # Converte datetime do Oracle para date se aplicável
        data_nascimento = dt_nasc.date() if dt_nasc else None
        dados_insercao.append((
            bk_id, origem, nome, email, tel, sexo, est_civil, data_nascimento
        ))
    
    execute_values(pg_cur, """
        INSERT INTO dim_cliente (bk_id_cliente, origem_fonte, nome_cliente, email, telefone, genero, estado_civil, data_nascimento)
        VALUES %s
    """, dados_insercao)
    total_clientes += len(dados_insercao)
    print(f"  [{origem}] {len(dados_insercao)} clientes inseridos.")

pg_conn.commit()

# Mapa em memória: (bk_id_cliente, origem_fonte) -> sk_cliente
pg_cur.execute("SELECT sk_cliente, bk_id_cliente, origem_fonte FROM dim_cliente")
cliente_map = {(bk_id, origem): sk for sk, bk_id, origem in pg_cur.fetchall()}
print(f"✓ Total em dim_cliente: {total_clientes} registros.")


# ============================================================
# 6. CARGA DA DIMENSÃO PRODUTO (dim_produto)
# Mapeia produtos das 3 fontes usando bk_id_produto e origem_fonte
# ============================================================

print("\n--- CARGA: dim_produto ---")

fontes_produtos = [
    ("Salvador", "STG_SALVADOR_PRODUTOS"),
    ("Itabuna",  "STG_ITABUNA_PRODUTOS"),
    ("Feira",    "STG_FEIRA_PRODUTOS")
]

total_produtos = 0
for origem, tabela in fontes_produtos:
    oracle_cur.execute(f"""
        SELECT ID_PRODUTO, NOME_PRODUTO, CATEGORIA, PRECO
        FROM {tabela}
        ORDER BY ID_PRODUTO
    """)
    rows = oracle_cur.fetchall()
    
    dados_insercao = []
    for r in rows:
        bk_id, nome, categoria, preco = r
        dados_insercao.append((bk_id, origem, nome, categoria, preco))
        
    execute_values(pg_cur, """
        INSERT INTO dim_produto (bk_id_produto, origem_fonte, nome_produto, categoria, preco_referencia)
        VALUES %s
    """, dados_insercao)
    total_produtos += len(dados_insercao)
    print(f"  [{origem}] {len(dados_insercao)} produtos inseridos.")

pg_conn.commit()

# Mapa em memória: (bk_id_produto, origem_fonte) -> sk_produto
pg_cur.execute("SELECT sk_produto, bk_id_produto, origem_fonte FROM dim_produto")
produto_map = {(bk_id, origem): sk for sk, bk_id, origem in pg_cur.fetchall()}
print(f"✓ Total em dim_produto: {total_produtos} registros.")


# ============================================================
# 7. CARGA DA TABELA FATO DE VENDAS (fato_vendas)
# Agregação por: sk_tempo (mês), sk_cliente, sk_produto, sk_loja
# Esta agregação evita inflar o DW com transações puras, mantendo
# suporte total a análises por Mês, Quadrimestre e Ano.
# ============================================================

print("\n--- CARGA: fato_vendas (AGREGADA) ---")

fato_registros = {}

# 7.1 Salvador
sk_loja_ssa = loja_map["Salvador"]
oracle_cur.execute("""
    SELECT 
        TO_CHAR(v.DATA_VENDA, 'YYYYMM') AS SK_TEMPO,
        v.ID_CLIENTE,
        i.ID_PRODUTO,
        i.QUANTIDADE,
        (i.QUANTIDADE * i.PRECO_UNITARIO) AS VALOR_ITEM
    FROM STG_SALVADOR_VENDAS v
    JOIN STG_SALVADOR_ITENS_VENDA i ON v.ID_VENDA = i.ID_VENDA
""")
for sk_t_str, bk_cli, bk_prod, qtd, vlr in oracle_cur.fetchall():
    sk_tempo = int(sk_t_str)
    sk_cli = cliente_map.get((bk_cli, "Salvador"))
    sk_prod = produto_map.get((bk_prod, "Salvador"))
    chave = (sk_tempo, sk_cli, sk_prod, sk_loja_ssa)
    
    if chave not in fato_registros:
        fato_registros[chave] = [0, 0.0]
    fato_registros[chave][0] += qtd
    fato_registros[chave][1] += float(vlr)

print(f"  [Salvador] Processado.")

# 7.2 Itabuna
sk_loja_ita = loja_map["Itabuna"]
oracle_cur.execute("""
    SELECT 
        TO_CHAR(v.DATA_VENDA, 'YYYYMM') AS SK_TEMPO,
        v.ID_CLIENTE,
        i.ID_PRODUTO,
        i.QUANTIDADE,
        (i.QUANTIDADE * i.PRECO_UNITARIO) AS VALOR_ITEM
    FROM STG_ITABUNA_VENDAS v
    JOIN STG_ITABUNA_ITENS_VENDA i ON v.ID_VENDA = i.ID_VENDA
""")
for sk_t_str, bk_cli, bk_prod, qtd, vlr in oracle_cur.fetchall():
    sk_tempo = int(sk_t_str)
    sk_cli = cliente_map.get((bk_cli, "Itabuna"))
    sk_prod = produto_map.get((bk_prod, "Itabuna"))
    chave = (sk_tempo, sk_cli, sk_prod, sk_loja_ita)
    
    if chave not in fato_registros:
        fato_registros[chave] = [0, 0.0]
    fato_registros[chave][0] += qtd
    fato_registros[chave][1] += float(vlr)

print(f"  [Itabuna] Processado.")

# 7.3 Feira de Santana
sk_loja_fsa = loja_map["Feira de Santana"]
oracle_cur.execute("""
    SELECT 
        TO_CHAR(p.DATA_PEDIDO, 'YYYYMM') AS SK_TEMPO,
        p.ID_CLIENTE,
        i.ID_PRODUTO,
        i.QUANTIDADE,
        (i.QUANTIDADE * i.PRECO_UNITARIO) AS VALOR_ITEM
    FROM STG_FEIRA_PEDIDOS p
    JOIN STG_FEIRA_ITENS_PEDIDO i ON p.ID_PEDIDO = i.ID_PEDIDO
""")
for sk_t_str, bk_cli, bk_prod, qtd, vlr in oracle_cur.fetchall():
    sk_tempo = int(sk_t_str)
    sk_cli = cliente_map.get((bk_cli, "Feira"))
    sk_prod = produto_map.get((bk_prod, "Feira"))
    chave = (sk_tempo, sk_cli, sk_prod, sk_loja_fsa)
    
    if chave not in fato_registros:
        fato_registros[chave] = [0, 0.0]
    fato_registros[chave][0] += qtd
    fato_registros[chave][1] += float(vlr)

print(f"  [Feira de Santana] Processado.")

# Prepara tuplas para inserção em lote
fato_rows = [
    (k[0], k[1], k[2], k[3], v[0], round(v[1], 2))
    for k, v in fato_registros.items()
]

execute_values(pg_cur, """
    INSERT INTO fato_vendas (sk_tempo, sk_cliente, sk_produto, sk_loja, quantidade_vendida, valor_total_venda)
    VALUES %s
""", fato_rows, page_size=2000)
pg_conn.commit()

print(f"✓ Total em fato_vendas: {len(fato_rows)} registros agregados carregados.")


# ============================================================
# 8. CARGA DA TABELA FATO DO CONCORRENTE (fato_vendas_concorrente)
# Mapeamento dos meses para sk_tempo
# ============================================================

print("\n--- CARGA: fato_vendas_concorrente ---")

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

concorrente_rows = []
for ano, mes_sigla, valor in rows_concorrente:
    num_mes = mapa_meses_sigla.get(mes_sigla.strip().lower())
    if num_mes:
        sk_tempo = ano * 100 + num_mes
        concorrente_rows.append((sk_tempo, float(valor)))

execute_values(pg_cur, """
    INSERT INTO fato_vendas_concorrente (sk_tempo, valor)
    VALUES %s
""", concorrente_rows)
pg_conn.commit()

print(f"✓ Total em fato_vendas_concorrente: {len(concorrente_rows)} registros carregados.")


# ============================================================
# 9. FINALIZAÇÃO E RELATÓRIO
# ============================================================

print("\n" + "=" * 70)
print("LOAD CONCLUÍDO COM SUCESSO!")
print("=" * 70)

resumo_tabelas = [
    "dim_tempo", "dim_loja", "dim_cliente", "dim_produto", 
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
