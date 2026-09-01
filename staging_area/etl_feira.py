import oracledb


# ============================================================
# CONEXÃO COM ORACLE
# ============================================================

oracle_conn = oracledb.connect(
    user="SYSTEM",
    password="cimatec",
    dsn="localhost:1521/XE"
)

oracle_cursor = oracle_conn.cursor()

print("Conectado ao Oracle com sucesso!")


# ============================================================
# LIMPAR STAGING FEIRA
# ============================================================

oracle_cursor.execute("DELETE FROM STG_FEIRA_ITENS_PEDIDO")
oracle_cursor.execute("DELETE FROM STG_FEIRA_PEDIDOS")
oracle_cursor.execute("DELETE FROM STG_FEIRA_PRODUTOS")
oracle_cursor.execute("DELETE FROM STG_FEIRA_CLIENTES")

oracle_conn.commit()

print("Staging Feira limpo.")


# ============================================================
# CLIENTES
# ============================================================

oracle_cursor.execute("""
    SELECT
        ID_CLIENTE,
        NOME,
        EMAIL,
        TELEFONE,
        SEXO,
        ESTADO_CIVIL,
        DATA_NASCIMENTO
    FROM FEIRA_CLIENTES
""")

clientes = oracle_cursor.fetchall()

oracle_cursor.executemany("""
    INSERT INTO STG_FEIRA_CLIENTES (
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
# PRODUTOS
# ============================================================

oracle_cursor.execute("""
    SELECT
        ID_PRODUTO,
        NOME_PRODUTO,
        CATEGORIA,
        PRECO
    FROM FEIRA_PRODUTOS
""")

produtos = oracle_cursor.fetchall()

oracle_cursor.executemany("""
    INSERT INTO STG_FEIRA_PRODUTOS (
        ID_PRODUTO,
        NOME_PRODUTO,
        CATEGORIA,
        PRECO
    )
    VALUES (:1, :2, :3, :4)
""", produtos)

print(f"Produtos carregados: {len(produtos)}")


# ============================================================
# PEDIDOS
# ============================================================

oracle_cursor.execute("""
    SELECT
        ID_PEDIDO,
        ID_CLIENTE,
        DATA_PEDIDO,
        VALOR_TOTAL
    FROM FEIRA_PEDIDOS
""")

pedidos = oracle_cursor.fetchall()

oracle_cursor.executemany("""
    INSERT INTO STG_FEIRA_PEDIDOS (
        ID_PEDIDO,
        ID_CLIENTE,
        DATA_PEDIDO,
        VALOR_TOTAL
    )
    VALUES (:1, :2, :3, :4)
""", pedidos)

print(f"Pedidos carregados: {len(pedidos)}")


# ============================================================
# ITENS DOS PEDIDOS
# ============================================================

oracle_cursor.execute("""
    SELECT
        ID_ITEM,
        ID_PEDIDO,
        ID_PRODUTO,
        NOME_PRODUTO,
        CATEGORIA,
        PRECO_UNITARIO,
        QUANTIDADE
    FROM FEIRA_ITENS_PEDIDO
""")

itens = oracle_cursor.fetchall()

oracle_cursor.executemany("""
    INSERT INTO STG_FEIRA_ITENS_PEDIDO (
        ID_ITEM,
        ID_PEDIDO,
        ID_PRODUTO,
        NOME_PRODUTO,
        CATEGORIA,
        PRECO_UNITARIO,
        QUANTIDADE
    )
    VALUES (:1, :2, :3, :4, :5, :6, :7)
""", itens)

print(f"Itens carregados: {len(itens)}")


# ============================================================
# COMMIT
# ============================================================

oracle_conn.commit()

print("\nETL Feira concluído com sucesso!")


# ============================================================
# FECHAR CONEXÃO
# ============================================================

oracle_cursor.close()
oracle_conn.close()