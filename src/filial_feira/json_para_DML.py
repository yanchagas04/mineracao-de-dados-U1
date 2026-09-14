import json
import os
import sys
import argparse
from pathlib import Path
from datetime import datetime
import oracledb

if sys.stdout.encoding != 'utf-8':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

# ============================================================
# RESOLUÇÃO DO CAMINHO DE IMPORTAÇÃO (src)
# ============================================================
current_dir = Path(__file__).resolve().parent
src_dir = current_dir.parent if current_dir.name != "src" else current_dir
if str(src_dir) not in sys.path:
    sys.path.insert(0, str(src_dir))

import config


def parse_date_obj(date_val):
    """Converte string YYYY-MM-DD para objeto datetime.date para o driver oracledb."""
    if not date_val:
        return None
    if isinstance(date_val, datetime):
        return date_val.date()
    try:
        return datetime.strptime(str(date_val).strip(), "%Y-%m-%d").date()
    except Exception:
        return None


def carregar_json(caminho_arquivo: Path):
    """Carrega dados de um arquivo JSON com encoding UTF-8."""
    if not caminho_arquivo.is_file():
        raise FileNotFoundError(f"Arquivo JSON não encontrado: {caminho_arquivo}")
    with open(caminho_arquivo, "r", encoding="utf-8") as f:
        return json.load(f)


def carregar_dados_feira(
    dir_path: str = None,
    clientes_path: str = None,
    produtos_path: str = None,
    pedidos_path: str = None
):
    """
    Carrega os arquivos JSON da filial Feira de Santana diretamente no banco
    Oracle da filial (C##FEIRA), sem gerar arquivos .sql intermediários.
    Pronto para orquestração no N8N ou linha de comando.
    """
    print("=" * 60)
    print("INICIANDO CARGA DIRETA NO BANCO: FILIAL FEIRA DE SANTANA (C##FEIRA)")
    print("=" * 60)

    # 1. Determina diretório base
    base_dir = Path(dir_path) if dir_path else (
        Path(os.getenv("FEIRA_JSON_DIR")) if os.getenv("FEIRA_JSON_DIR") else current_dir
    )

    # 2. Localiza caminhos de cada arquivo JSON
    f_clientes = Path(clientes_path) if clientes_path else (
        Path(os.getenv("FEIRA_CLIENTES_JSON")) if os.getenv("FEIRA_CLIENTES_JSON") else base_dir / "05_Feira_Clientes.json"
    )
    f_produtos = Path(produtos_path) if produtos_path else (
        Path(os.getenv("FEIRA_PRODUTOS_JSON")) if os.getenv("FEIRA_PRODUTOS_JSON") else base_dir / "06_Feira_Produtos.json"
    )
    f_pedidos = Path(pedidos_path) if pedidos_path else (
        Path(os.getenv("FEIRA_PEDIDOS_JSON")) if os.getenv("FEIRA_PEDIDOS_JSON") else base_dir / "07_Feira_Pedidos.json"
    )

    # Validação da existência dos arquivos
    for label, arq in [("Clientes", f_clientes), ("Produtos", f_produtos), ("Pedidos", f_pedidos)]:
        if not arq.is_file():
            raise FileNotFoundError(
                f"Arquivo de {label} de Feira não encontrado em: {arq}. "
                f"Passe via argumentos (--clientes, --produtos, --pedidos, --dir) ou variáveis de ambiente."
            )

    print(f"✓ Arquivo Clientes: {f_clientes}")
    print(f"✓ Arquivo Produtos: {f_produtos}")
    print(f"✓ Arquivo Pedidos:  {f_pedidos}")

    # 3. Leitura dos dados JSON
    dados_clientes = carregar_json(f_clientes)
    dados_produtos = carregar_json(f_produtos)
    dados_pedidos = carregar_json(f_pedidos)

    # 4. Preparação das tuplas para inserção em lote
    tuplas_clientes = [
        (
            c.get("id_cliente"),
            c.get("nome"),
            c.get("email"),
            c.get("telefone"),
            c.get("sexo"),
            c.get("estado_civil"),
            parse_date_obj(c.get("data_nascimento")),
        )
        for c in dados_clientes
    ]

    tuplas_produtos = [
        (
            p.get("id_produto"),
            p.get("nome_produto"),
            p.get("categoria"),
            float(p.get("preco")) if p.get("preco") is not None else None,
        )
        for p in dados_produtos
    ]

    tuplas_pedidos = []
    tuplas_itens = []
    item_seq = 1

    for ped in dados_pedidos:
        ped_id = ped.get("id_pedido")
        cli_id = ped.get("id_cliente")
        d_ped = parse_date_obj(ped.get("data_pedido"))
        v_tot = float(ped.get("valor_total")) if ped.get("valor_total") is not None else None

        tuplas_pedidos.append((ped_id, cli_id, d_ped, v_tot))

        for item in ped.get("itens", []):
            p_unit = float(item.get("preco_unitario")) if item.get("preco_unitario") is not None else None
            qtd = int(item.get("quantidade")) if item.get("quantidade") is not None else 0

            tuplas_itens.append((
                item_seq,
                ped_id,
                item.get("id_produto"),
                item.get("nome_produto"),
                item.get("categoria"),
                p_unit,
                qtd,
            ))
            item_seq += 1

    # 5. Conexão e inserção direta no banco C##FEIRA
    conn = oracledb.connect(**config.ORACLE_FEIRA_CONFIG)
    cursor = conn.cursor()

    try:
        # Limpeza prévia respeitando integridade referencial
        print("\nLimpando tabelas da Filial Feira...")
        cursor.execute("DELETE FROM ITENS_PEDIDO")
        cursor.execute("DELETE FROM PEDIDOS")
        cursor.execute("DELETE FROM PRODUTOS")
        cursor.execute("DELETE FROM CLIENTES")
        print("Tabelas limpas com sucesso.")

        # Inserção direta via executemany
        cursor.executemany("""
            INSERT INTO CLIENTES (ID_CLIENTE, NOME, EMAIL, TELEFONE, SEXO, ESTADO_CIVIL, DATA_NASCIMENTO)
            VALUES (:1, :2, :3, :4, :5, :6, :7)
        """, tuplas_clientes)
        print(f"✓ {len(tuplas_clientes)} clientes inseridos.")

        cursor.executemany("""
            INSERT INTO PRODUTOS (ID_PRODUTO, NOME_PRODUTO, CATEGORIA, PRECO)
            VALUES (:1, :2, :3, :4)
        """, tuplas_produtos)
        print(f"✓ {len(tuplas_produtos)} produtos inseridos.")

        cursor.executemany("""
            INSERT INTO PEDIDOS (ID_PEDIDO, ID_CLIENTE, DATA_PEDIDO, VALOR_TOTAL)
            VALUES (:1, :2, :3, :4)
        """, tuplas_pedidos)
        print(f"✓ {len(tuplas_pedidos)} pedidos inseridos.")

        cursor.executemany("""
            INSERT INTO ITENS_PEDIDO (ID_ITEM, ID_PEDIDO, ID_PRODUTO, NOME_PRODUTO, CATEGORIA, PRECO_UNITARIO, QUANTIDADE)
            VALUES (:1, :2, :3, :4, :5, :6, :7)
        """, tuplas_itens)
        print(f"✓ {len(tuplas_itens)} itens de pedido inseridos.")

        conn.commit()
        print("\n" + "=" * 60)
        print("CARGA DA FILIAL FEIRA CONCLUÍDA COM SUCESSO NO BANCO!")
        print("=" * 60)
        return {
            "clientes": len(tuplas_clientes),
            "produtos": len(tuplas_produtos),
            "pedidos": len(tuplas_pedidos),
            "itens": len(tuplas_itens),
        }

    except Exception as e:
        conn.rollback()
        print(f"[ERRO] Falha ao carregar dados no banco de Feira: {e}")
        raise e
    finally:
        cursor.close()
        conn.close()


def main():
    parser = argparse.ArgumentParser(
        description="Carrega dados dos arquivos JSON diretamente no banco Oracle da Filial Feira (C##FEIRA)."
    )
    parser.add_argument("--dir", "-d", default=None, help="Diretório contendo os arquivos JSON da filial Feira")
    parser.add_argument("--clientes", "-c", default=None, help="Caminho do arquivo 05_Feira_Clientes.json")
    parser.add_argument("--produtos", "-p", default=None, help="Caminho do arquivo 06_Feira_Produtos.json")
    parser.add_argument("--pedidos", "-e", default=None, help="Caminho do arquivo 07_Feira_Pedidos.json")

    args = parser.parse_args()
    carregar_dados_feira(
        dir_path=args.dir,
        clientes_path=args.clientes,
        produtos_path=args.produtos,
        pedidos_path=args.pedidos
    )


if __name__ == "__main__":
    main()