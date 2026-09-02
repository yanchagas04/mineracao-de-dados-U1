import oracledb
import re
import unicodedata

# ============================================================
# CONEXÃO COM ORACLE - STAGING (C##SA)
# ============================================================

conn = oracledb.connect(
    user="C##SA",
    password="cimatec",
    dsn="localhost:1521/XE"
)

cursor = conn.cursor()

print("=" * 60)
print("INICIANDO TRANSFORMAÇÃO DOS DADOS DA STAGING AREA")
print("=" * 60)


# ============================================================
# FUNÇÕES DE PADRONIZAÇÃO
# ============================================================

def padronizar_nome(valor):
    """Capitaliza corretamente o nome, removendo espaços extras."""
    if valor is None:
        return None
    return " ".join(valor.strip().title().split())


def padronizar_email(valor):
    """Coloca o email em lowercase e remove espaços."""
    if valor is None:
        return None
    return valor.strip().lower()


def padronizar_telefone(valor):
    """Remove tudo que não for dígito e formata como (XX) XXXXX-XXXX."""
    if valor is None:
        return None
    digitos = re.sub(r"\D", "", valor)
    if len(digitos) == 11:
        return f"({digitos[:2]}) {digitos[2:7]}-{digitos[7:]}"
    elif len(digitos) == 10:
        return f"({digitos[:2]}) {digitos[2:6]}-{digitos[6:]}"
    return valor.strip()  # retorna original se não reconhecer o padrão


def padronizar_sexo(valor):
    """
    Normaliza variações de sexo para: 'Masculino', 'Feminino' ou 'Não Informado'.
    Aceita: M, F, Masculino, Feminino, masculino, male, female, etc.
    """
    if valor is None:
        return "Não Informado"
    v = unicodedata.normalize("NFD", valor.strip().lower())
    v = "".join(c for c in v if unicodedata.category(c) != "Mn")
    if v in ("m", "masculino", "male", "masc"):
        return "M"
    if v in ("f", "feminino", "female", "fem"):
        return "F"
    return "Não Informado"


def padronizar_estado_civil(valor):
    """
    Normaliza variações de estado civil.
    Saídas: Solteiro(a), Casado(a), Divorciado(a), Viúvo(a), Outro, Não Informado.
    """
    if valor is None:
        return "Não Informado"
    v = unicodedata.normalize("NFD", valor.strip().lower())
    v = "".join(c for c in v if unicodedata.category(c) != "Mn")
    mapa = {
        "solteiro":       "Solteiro(a)",
        "solteira":       "Solteiro(a)",
        "casado":         "Casado(a)",
        "casada":         "Casado(a)",
        "divorciado":     "Divorciado(a)",
        "divorciada":     "Divorciado(a)",
        "separado":       "Divorciado(a)",
        "separada":       "Divorciado(a)",
        "viuvo":          "Viúvo(a)",
        "viuva":          "Viúvo(a)",
        "uniao estavel":  "Casado(a)",
        "uniao_estavel":  "Casado(a)",
    }
    return mapa.get(v, "Outro")


def padronizar_categoria(valor):
    """Capitaliza e remove espaços extras da categoria."""
    if valor is None:
        return "Sem Categoria"
    return " ".join(valor.strip().title().split())


def padronizar_nome_produto(valor):
    """Capitaliza o nome do produto."""
    if valor is None:
        return None
    return " ".join(valor.strip().title().split())


def validar_preco(valor):
    """Garante que o preço é positivo; retorna None caso contrário."""
    if valor is None or valor < 0:
        return None
    return valor


def validar_quantidade(valor):
    """Garante que a quantidade é positiva; retorna 0 caso contrário."""
    if valor is None or valor < 0:
        return 0
    return valor


# ============================================================
# TRANSFORMAÇÃO: CLIENTES
# ============================================================

print("\n--- CLIENTES ---")

fontes_clientes = [
    ("Salvador",  "STG_SALVADOR_CLIENTES"),
    ("Itabuna",   "STG_ITABUNA_CLIENTES"),
    ("Feira",     "STG_FEIRA_CLIENTES"),
]

erros_clientes = 0

for origem, tabela in fontes_clientes:
    cursor.execute(f"""
        SELECT ID_CLIENTE, NOME, EMAIL, TELEFONE, SEXO, ESTADO_CIVIL, DATA_NASCIMENTO
        FROM {tabela}
    """)
    rows = cursor.fetchall()
    atualizados = 0

    for row in rows:
        id_cliente, nome, email, telefone, sexo, estado_civil, data_nasc = row

        nome_ok         = padronizar_nome(nome)
        email_ok        = padronizar_email(email)
        telefone_ok     = padronizar_telefone(telefone)
        sexo_ok         = padronizar_sexo(sexo)
        estado_civil_ok = padronizar_estado_civil(estado_civil)

        # Detecta se houve alguma mudança
        mudou = (
            nome_ok != nome or
            email_ok != email or
            telefone_ok != telefone or
            sexo_ok != sexo or
            estado_civil_ok != estado_civil
        )

        if mudou:
            try:
                cursor.execute(f"""
                    UPDATE {tabela}
                    SET NOME         = :1,
                        EMAIL        = :2,
                        TELEFONE     = :3,
                        SEXO         = :4,
                        ESTADO_CIVIL = :5
                    WHERE ID_CLIENTE = :6
                """, (nome_ok, email_ok, telefone_ok, sexo_ok, estado_civil_ok, id_cliente))
                atualizados += 1
            except Exception as e:
                erros_clientes += 1
                print(f"  [ERRO] {tabela} ID={id_cliente}: {e}")

    print(f"  [{origem}] {len(rows)} registros lidos | {atualizados} atualizados")

print(f"  Erros: {erros_clientes}")


# ============================================================
# ENRIQUECIMENTO CRUZADO: CATEGORIA DE PRODUTOS
# Monta um dicionário nome_produto (normalizado) -> categoria
# a partir das fontes Itabuna e Feira, para preencher NULLs
# em Salvador sem precisar descartar o registro.
# ============================================================

print("\n--- ENRIQUECIMENTO CRUZADO DE CATEGORIAS ---")

def normalizar_chave(nome):
    """Reduz o nome a letras minúsculas sem acentos para comparação."""
    if nome is None:
        return ""
    v = unicodedata.normalize("NFD", nome.strip().lower())
    return "".join(c for c in v if unicodedata.category(c) != "Mn")

# Fontes de referência (Itabuna e Feira têm categorias completas)
categoria_lookup = {}  # chave: nome normalizado -> categoria padronizada

for tabela_ref in ("STG_ITABUNA_PRODUTOS", "STG_FEIRA_PRODUTOS"):
    cursor.execute(f"SELECT NOME_PRODUTO, CATEGORIA FROM {tabela_ref} WHERE CATEGORIA IS NOT NULL")
    for nome_ref, cat_ref in cursor.fetchall():
        chave = normalizar_chave(nome_ref)
        if chave and chave not in categoria_lookup:
            categoria_lookup[chave] = padronizar_categoria(cat_ref)

print(f"  Lookup construído com {len(categoria_lookup)} categorias únicas.")

# Aplica o enriquecimento apenas nos produtos de Salvador com CATEGORIA nula
cursor.execute("""
    SELECT ID_PRODUTO, NOME_PRODUTO
    FROM STG_SALVADOR_PRODUTOS
    WHERE CATEGORIA IS NULL
""")
nulos_salvador = cursor.fetchall()

enriquecidos  = 0
nao_resolvidos = 0

for id_prod, nome_prod in nulos_salvador:
    chave = normalizar_chave(nome_prod)
    categoria_encontrada = categoria_lookup.get(chave)

    if categoria_encontrada:
        cursor.execute("""
            UPDATE STG_SALVADOR_PRODUTOS
            SET CATEGORIA = :1
            WHERE ID_PRODUTO = :2
        """, (categoria_encontrada, id_prod))
        enriquecidos += 1
        print(f"  [ENRIQUECIDO] ID={id_prod} '{nome_prod}' -> '{categoria_encontrada}'")
    else:
        cursor.execute("""
            UPDATE STG_SALVADOR_PRODUTOS
            SET CATEGORIA = 'Sem Categoria'
            WHERE ID_PRODUTO = :1
        """, (id_prod,))
        nao_resolvidos += 1
        print(f"  [SEM MATCH]   ID={id_prod} '{nome_prod}' -> 'Sem Categoria'")

print(f"  Resultado: {enriquecidos} enriquecidos | {nao_resolvidos} sem correspondência")


# ============================================================
# TRANSFORMAÇÃO: PRODUTOS
# ============================================================

print("\n--- PRODUTOS ---")

fontes_produtos = [
    ("Salvador", "STG_SALVADOR_PRODUTOS"),
    ("Itabuna",  "STG_ITABUNA_PRODUTOS"),
    ("Feira",    "STG_FEIRA_PRODUTOS"),
]

erros_produtos = 0

for origem, tabela in fontes_produtos:
    cursor.execute(f"""
        SELECT ID_PRODUTO, NOME_PRODUTO, CATEGORIA, PRECO
        FROM {tabela}
    """)
    rows = cursor.fetchall()
    atualizados = 0

    for row in rows:
        id_produto, nome_produto, categoria, preco = row

        nome_ok      = padronizar_nome_produto(nome_produto)
        # Categoria já foi enriquecida antes — só padroniza formatação
        categoria_ok = padronizar_categoria(categoria)
        preco_ok     = validar_preco(preco)

        mudou = (
            nome_ok != nome_produto or
            categoria_ok != categoria or
            preco_ok != preco
        )

        if mudou:
            try:
                cursor.execute(f"""
                    UPDATE {tabela}
                    SET NOME_PRODUTO = :1,
                        CATEGORIA   = :2,
                        PRECO       = :3
                    WHERE ID_PRODUTO = :4
                """, (nome_ok, categoria_ok, preco_ok, id_produto))
                atualizados += 1
            except Exception as e:
                erros_produtos += 1
                print(f"  [ERRO] {tabela} ID={id_produto}: {e}")

    print(f"  [{origem}] {len(rows)} registros lidos | {atualizados} atualizados")

print(f"  Erros: {erros_produtos}")


# ============================================================
# TRANSFORMAÇÃO: VENDAS / PEDIDOS (validação de valores)
# ============================================================

print("\n--- VENDAS / PEDIDOS ---")

fontes_vendas = [
    ("Salvador", "STG_SALVADOR_VENDAS",  "ID_VENDA",  "VALOR_TOTAL"),
    ("Itabuna",  "STG_ITABUNA_VENDAS",   "ID_VENDA",  "VALOR_TOTAL"),
    ("Feira",    "STG_FEIRA_PEDIDOS",    "ID_PEDIDO", "VALOR_TOTAL"),
]

erros_vendas = 0

for origem, tabela, col_id, col_valor in fontes_vendas:
    cursor.execute(f"""
        SELECT {col_id}, {col_valor}
        FROM {tabela}
        WHERE {col_valor} IS NULL OR {col_valor} < 0
    """)
    invalidos = cursor.fetchall()

    if invalidos:
        for row in invalidos:
            id_val, valor = row
            try:
                cursor.execute(f"""
                    UPDATE {tabela}
                    SET {col_valor} = 0
                    WHERE {col_id} = :1
                """, (id_val,))
                erros_vendas += 1
                print(f"  [CORRIGIDO] {tabela} ID={id_val}: valor {valor} -> 0")
            except Exception as e:
                print(f"  [ERRO] {tabela} ID={id_val}: {e}")

    cursor.execute(f"SELECT COUNT(*) FROM {tabela}")
    total = cursor.fetchone()[0]
    print(f"  [{origem}] {total} registros | {len(invalidos)} valores inválidos corrigidos")

print(f"  Erros: {erros_vendas}")


# ============================================================
# TRANSFORMAÇÃO: ITENS (quantidade e preço unitário)
# ============================================================

print("\n--- ITENS DE VENDA / PEDIDO ---")

fontes_itens = [
    ("Salvador", "STG_SALVADOR_ITENS_VENDA",  "ID_ITEM"),
    ("Itabuna",  "STG_ITABUNA_ITENS_VENDA",   "ID_ITEM"),
    ("Feira",    "STG_FEIRA_ITENS_PEDIDO",     "ID_ITEM"),
]

erros_itens = 0

for origem, tabela, col_id in fontes_itens:
    cursor.execute(f"""
        SELECT {col_id}, QUANTIDADE, PRECO_UNITARIO
        FROM {tabela}
    """)
    rows = cursor.fetchall()
    atualizados = 0

    for row in rows:
        id_item, qtd, preco = row
        qtd_ok   = validar_quantidade(qtd)
        preco_ok = validar_preco(preco)

        if qtd_ok != qtd or preco_ok != preco:
            try:
                cursor.execute(f"""
                    UPDATE {tabela}
                    SET QUANTIDADE     = :1,
                        PRECO_UNITARIO = :2
                    WHERE {col_id} = :3
                """, (qtd_ok, preco_ok, id_item))
                atualizados += 1
            except Exception as e:
                erros_itens += 1
                print(f"  [ERRO] {tabela} ID={id_item}: {e}")

    print(f"  [{origem}] {len(rows)} registros lidos | {atualizados} corrigidos")

print(f"  Erros: {erros_itens}")


# ============================================================
# COMMIT E FECHAMENTO
# ============================================================

conn.commit()

print("\n" + "=" * 60)
print("TRANSFORMAÇÃO CONCLUÍDA COM SUCESSO!")
print("=" * 60)

cursor.close()
conn.close()
