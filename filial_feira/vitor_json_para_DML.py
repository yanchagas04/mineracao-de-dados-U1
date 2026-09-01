import json
from pathlib import Path


def escape_sql(val):
    if val is None:
        return "NULL"

    if isinstance(val, (int, float)):
        return str(val)

    val_str = str(val).replace("'", "''")
    return f"'{val_str}'"


def parse_date(date_val):
    if not date_val:
        return "NULL"

    return f"TO_DATE('{date_val}', 'YYYY-MM-DD')"


def load_json(file_path):
    with open(file_path, "r", encoding="utf-8") as f:
        return json.load(f)


def main():

    # Pasta onde este script está localizado
    base_dir = Path(__file__).resolve().parent

    output_file = base_dir / "feira-DML.sql"

    files = {
        "clientes": base_dir / "05_Feira_Clientes.json",
        "produtos": base_dir / "06_Feira_Produtos.json",
        "pedidos": base_dir / "07_Feira_pedidos.json"
    }

    with open(output_file, "w", encoding="utf-8") as out:

        # 1. CLIENTES
        if files["clientes"].exists():

            out.write("-- INSERTS FEIRA_CLIENTES\n")

            clientes = load_json(files["clientes"])

            for c in clientes:

                stmt = (
                    "INSERT INTO FEIRA_CLIENTES "
                    "(ID_CLIENTE, NOME, EMAIL, TELEFONE, SEXO, "
                    "ESTADO_CIVIL, DATA_NASCIMENTO) "
                    f"VALUES ({c.get('id_cliente')}, "
                    f"{escape_sql(c.get('nome'))}, "
                    f"{escape_sql(c.get('email'))}, "
                    f"{escape_sql(c.get('telefone'))}, "
                    f"{escape_sql(c.get('sexo'))}, "
                    f"{escape_sql(c.get('estado_civil'))}, "
                    f"{parse_date(c.get('data_nascimento'))});\n"
                )

                out.write(stmt)

        # 2. PRODUTOS
        if files["produtos"].exists():

            out.write("\n-- INSERTS FEIRA_PRODUTOS\n")

            produtos = load_json(files["produtos"])

            for p in produtos:

                stmt = (
                    "INSERT INTO FEIRA_PRODUTOS "
                    "(ID_PRODUTO, NOME_PRODUTO, CATEGORIA, PRECO) "
                    f"VALUES ({p.get('id_produto')}, "
                    f"{escape_sql(p.get('nome_produto'))}, "
                    f"{escape_sql(p.get('categoria'))}, "
                    f"{p.get('preco', 'NULL')});\n"
                )

                out.write(stmt)

        # 3. PEDIDOS E ITENS
        if files["pedidos"].exists():

            out.write("\n-- INSERTS FEIRA_PEDIDOS\n")

            out.write("-- INSERTS FEIRA_ITENS_PEDIDO\n")

            pedidos = load_json(files["pedidos"])

            item_seq = 1

            for ped in pedidos:

                ped_id = ped.get("id_pedido")
                cli_id = ped.get("id_cliente")
                data_pedido = parse_date(ped.get("data_pedido"))
                valor_total = ped.get("valor_total", "NULL")

                # Pedido
                stmt_ped = (
                    "INSERT INTO FEIRA_PEDIDOS "
                    "(ID_PEDIDO, ID_CLIENTE, DATA_PEDIDO, VALOR_TOTAL) "
                    f"VALUES ({ped_id}, {cli_id}, "
                    f"{data_pedido}, {valor_total});\n"
                )

                out.write(stmt_ped)

                # Itens
                for item in ped.get("itens", []):

                    stmt_item = (
                        "INSERT INTO FEIRA_ITENS_PEDIDO "
                        "(ID_ITEM, ID_PEDIDO, ID_PRODUTO, NOME_PRODUTO, "
                        "CATEGORIA, PRECO_UNITARIO, QUANTIDADE) "
                        f"VALUES ({item_seq}, {ped_id}, "
                        f"{item.get('id_produto')}, "
                        f"{escape_sql(item.get('nome_produto'))}, "
                        f"{escape_sql(item.get('categoria'))}, "
                        f"{item.get('preco_unitario', 'NULL')}, "
                        f"{item.get('quantidade', 'NULL')});\n"
                    )

                    out.write(stmt_item)

                    item_seq += 1

    print(f"Arquivo gerado: {output_file}")


if __name__ == "__main__":
    main()