import oracledb


# ============================================================
# CONFIGURAÇÃO
# ============================================================

ORACLE_USER = "SYSTEM"
ORACLE_PASSWORD = "cimatec"
ORACLE_HOST = "localhost"
ORACLE_PORT = 1521
ORACLE_SERVICE = "XE"


# ============================================================
# CONEXÃO
# ============================================================

dsn = f"{ORACLE_HOST}:{ORACLE_PORT}/{ORACLE_SERVICE}"

conn = oracledb.connect(
    user=ORACLE_USER,
    password=ORACLE_PASSWORD,
    dsn=dsn
)

cursor = conn.cursor()

print("Conectado ao Oracle com sucesso!")


# ============================================================
# LIMPA O STAGING DE SALVADOR
# ============================================================

cursor.execute("DELETE FROM STG_SALVADOR_CLIENTES")
cursor.execute("DELETE FROM STG_SALVADOR_PRODUTOS")
cursor.execute("DELETE FROM STG_SALVADOR_VENDAS")
cursor.execute("DELETE FROM STG_SALVADOR_ITENS_VENDA")

conn.commit()

print("Staging Salvador limpo.")


# ============================================================
# 1. CLIENTES
# ============================================================

cursor.execute("""
    SELECT
        id_cliente,
        nome,
        email,
        telefone,
        sexo,
        estado_civil,
        data_nascimento
    FROM clientes
""")

clientes = cursor.fetchall()

cursor.executemany("""
    INSERT INTO STG_SALVADOR_CLIENTES (
        ID_CLIENTE,
        NOME,
        EMAIL,
        TELEFONE,
        SEXO,
        ESTADO_CIVIL,
        DATA_NASCIMENTO
    )
    VALUES (:1, :2, :3, :4, :5, :6, :7)
""", clientes)

print(f"Clientes carregados: {len(clientes)}")


# ============================================================
# 2. PRODUTOS
# ============================================================

cursor.execute("""
    SELECT
        p.id_produto,
        p.nome,
        c.nome_categoria,
        p.preco
    FROM produtos p
    LEFT JOIN categorias c
        ON c.id_categoria = p.id_categoria
""")

produtos = cursor.fetchall()

cursor.executemany("""
    INSERT INTO STG_SALVADOR_PRODUTOS (
        ID_PRODUTO,
        NOME_PRODUTO,
        CATEGORIA,
        PRECO
    )
    VALUES (:1, :2, :3, :4)
""", produtos)

print(f"Produtos carregados: {len(produtos)}")


# ============================================================
# 3. VENDAS
# ============================================================

cursor.execute("""
    SELECT
        v.id_venda,
        v.id_cliente,
        v.data_venda,
        SUM(i.quantidade * i.valor_unitario) AS valor_total
    FROM vendas v
    LEFT JOIN itens_venda i
        ON i.id_venda = v.id_venda
    GROUP BY
        v.id_venda,
        v.id_cliente,
        v.data_venda
""")

vendas = cursor.fetchall()

cursor.executemany("""
    INSERT INTO STG_SALVADOR_VENDAS (
        ID_VENDA,
        ID_CLIENTE,
        DATA_VENDA,
        VALOR_TOTAL
    )
    VALUES (:1, :2, :3, :4)
""", vendas)

print(f"Vendas carregadas: {len(vendas)}")


# ============================================================
# 4. ITENS DE VENDA
# ============================================================

cursor.execute("""
    SELECT
        id_item,
        id_venda,
        id_produto,
        quantidade,
        valor_unitario
    FROM itens_venda
""")

itens = cursor.fetchall()

cursor.executemany("""
    INSERT INTO STG_SALVADOR_ITENS_VENDA (
        ID_ITEM,
        ID_VENDA,
        ID_PRODUTO,
        QUANTIDADE,
        PRECO_UNITARIO
    )
    VALUES (:1, :2, :3, :4, :5)
""", itens)

print(f"Itens carregados: {len(itens)}")


# ============================================================
# FINALIZA
# ============================================================

conn.commit()

print("\nETL Salvador concluído com sucesso!")

cursor.close()
conn.close()