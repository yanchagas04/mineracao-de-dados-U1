import json
import os

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
    output_file = "feira-DML.sql"

    files = {
        "clientes": "05_Feira_Clientes.json",
        "produtos": "06_Feira_Produtos.json",
        "pedidos": "07_Feira_Pedidos.json"
    }

    with open(output_file, "w", encoding="utf-8") as out:
        # 1. CLIENTES
        if os.path.exists(files["clientes"]):
            out.write("-- INSERTS CLIENTES\n")
            for c in load_json(files["clientes"]):
                stmt = (
                    f"INSERT INTO CLIENTES (ID_CLIENTE, NOME, EMAIL, TELEFONE, SEXO, ESTADO_CIVIL, DATA_NASCIMENTO) "
                    f"VALUES ({c.get('id_cliente')}, {escape_sql(c.get('nome'))}, {escape_sql(c.get('email'))}, "
                    f"{escape_sql(c.get('telefone'))}, {escape_sql(c.get('sexo'))}, {escape_sql(c.get('estado_civil'))}, "
                    f"{parse_date(c.get('data_nascimento'))});\n"
                )
                out.write(stmt)
            out.write("\n")

        # 2. PRODUTOS
        if os.path.exists(files["produtos"]):
            out.write("-- INSERTS PRODUTOS\n")
            for p in load_json(files["produtos"]):
                stmt = (
                    f"INSERT INTO PRODUTOS (ID_PRODUTO, NOME_PRODUTO, CATEGORIA, PRECO) "
                    f"VALUES ({p.get('id_produto')}, {escape_sql(p.get('nome_produto'))}, "
                    f"{escape_sql(p.get('categoria'))}, {p.get('preco', 'NULL')});\n"
                )
                out.write(stmt)
            out.write("\n")

        # 3. PEDIDOS E ITENS_PEDIDO
        if os.path.exists(files["pedidos"]):
            out.write("-- INSERTS PEDIDOS E ITENS_PEDIDO\n")
            item_seq = 1
            for ped in load_json(files["pedidos"]):
                ped_id = ped.get("id_pedido")
                cli_id = ped.get("id_cliente")
                d_ped = parse_date(ped.get("data_pedido"))
                v_tot = ped.get("valor_total", "NULL")

                stmt_ped = (
                    f"INSERT INTO PEDIDOS (ID_PEDIDO, ID_CLIENTE, DATA_PEDIDO, VALOR_TOTAL) "
                    f"VALUES ({ped_id}, {cli_id}, {d_ped}, {v_tot});\n"
                )
                out.write(stmt_ped)

                for item in ped.get("itens", []):
                    stmt_item = (
                        f"INSERT INTO ITENS_PEDIDO (ID_ITEM, ID_PEDIDO, ID_PRODUTO, NOME_PRODUTO, CATEGORIA, PRECO_UNITARIO, QUANTIDADE) "
                        f"VALUES ({item_seq}, {ped_id}, {item.get('id_produto')}, {escape_sql(item.get('nome_produto'))}, "
                        f"{escape_sql(item.get('categoria'))}, {item.get('preco_unitario', 'NULL')}, {item.get('quantidade', 'NULL')});\n"
                    )
                    out.write(stmt_item)
                    item_seq += 1

    print(f"Arquivo gerado: {output_file}")

if __name__ == "__main__":
    main()