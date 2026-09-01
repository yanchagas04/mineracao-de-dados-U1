import psycopg2
import oracledb


# ============================================================
# CONEXÃO POSTGRESQL - ITABUNA
# ============================================================

postgres_conn = psycopg2.connect(
    host="localhost",
    port=5435,
    database="petshop_itabuna",
    user="postgres",
    password="cimatec"
)

postgres_cursor = postgres_conn.cursor()

print("Conectado ao PostgreSQL Itabuna com sucesso!")


# ============================================================
# CONEXÃO ORACLE - STAGING
# ============================================================

oracle_conn = oracledb.connect(
    user="SYSTEM",
    password="cimatec",
    dsn="localhost:1521/XE"
)

oracle_cursor = oracle_conn.cursor()

print("Conectado ao Oracle Staging com sucesso!")


# ============================================================
# LIMPA O STAGING
# ============================================================

oracle_cursor.execute("DELETE FROM STG_ITABUNA_CLIENTES")
oracle_cursor.execute("DELETE FROM STG_ITABUNA_PRODUTOS")
oracle_cursor.execute("DELETE FROM STG_ITABUNA_VENDAS")
oracle_cursor.execute("DELETE FROM STG_ITABUNA_ITENS_VENDA")

oracle_conn.commit()

print("Staging Itabuna limpo.")


# ============================================================
# 1. CLIENTES
# ============================================================

postgres_cursor.execute("""
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

clientes = postgres_cursor.fetchall()

oracle_cursor.executemany("""
    INSERT INTO STG_ITABUNA_CLIENTES (
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

postgres_cursor.execute("""
    SELECT
        id_produto,
        nome,
        categoria,
        preco
    FROM produtos
""")

produtos = postgres_cursor.fetchall()

oracle_cursor.executemany("""
    INSERT INTO STG_ITABUNA_PRODUTOS (
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

postgres_cursor.execute("""
    SELECT
        id_venda,
        id_cliente,
        data_venda,
        valor_total
    FROM vendas
""")

vendas = postgres_cursor.fetchall()

oracle_cursor.executemany("""
    INSERT INTO STG_ITABUNA_VENDAS (
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

postgres_cursor.execute("""
    SELECT
        id_item,
        id_venda,
        id_produto,
        quantidade,
        valor_unitario
    FROM itens_venda
""")

itens = postgres_cursor.fetchall()

oracle_cursor.executemany("""
    INSERT INTO STG_ITABUNA_ITENS_VENDA (
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

oracle_conn.commit()

print("\nETL Itabuna concluído com sucesso!")


# ============================================================
# FECHA CONEXÕES
# ============================================================

postgres_cursor.close()
postgres_conn.close()

oracle_cursor.close()
oracle_conn.close()