import sys
import os
import csv
import argparse
from pathlib import Path
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


def ler_arquivo_concorrente(caminho_arquivo: Path) -> list:
    """
    Lê o arquivo de vendas do concorrente (CSV delimitado por ';' ou ',')
    e retorna uma lista de tuplas (ano, mes, vendas).
    """
    if not caminho_arquivo.is_file():
        raise FileNotFoundError(f"Arquivo do concorrente não encontrado: {caminho_arquivo}")

    registros = []
    # Tenta ler com utf-8-sig (para remover BOM se houver) ou latin-1
    conteudo = None
    for enc in ("utf-8-sig", "utf-8", "latin-1", "cp1252"):
        try:
            with open(caminho_arquivo, "r", encoding=enc) as f:
                conteudo = f.readlines()
            break
        except UnicodeDecodeError:
            continue

    if not conteudo:
        raise ValueError(f"Não foi possível decodificar o arquivo: {caminho_arquivo}")

    # Detecta o delimitador (; ou ,)
    primeira_linha = conteudo[0] if conteudo else ""
    delimitador = ";" if ";" in primeira_linha else ","

    reader = csv.reader(conteudo, delimiter=delimitador)
    linhas = list(reader)

    if not linhas:
        return []

    # Identifica cabeçalho
    header = [col.strip().lower() for col in linhas[0]]
    inicio_dados = 1 if any("ano" in col or "mes" in col or "vendas" in col for col in header) else 0

    mapa_meses = {
        "1": "Jan", "01": "Jan", "jan": "Jan", "janeiro": "Jan",
        "2": "Fev", "02": "Fev", "fev": "Fev", "fevereiro": "Fev",
        "3": "Mar", "03": "Mar", "mar": "Mar", "marco": "Mar", "março": "Mar",
        "4": "Abr", "04": "Abr", "abr": "Abr", "abril": "Abr",
        "5": "Mai", "05": "Mai", "mai": "Mai", "maio": "Mai",
        "6": "Jun", "06": "Jun", "jun": "Jun", "junho": "Jun",
        "7": "Jul", "07": "Jul", "jul": "Jul", "julho": "Jul",
        "8": "Ago", "08": "Ago", "ago": "Ago", "agosto": "Ago",
        "9": "Set", "09": "Set", "set": "Set", "setembro": "Set",
        "10": "Out", "out": "Out", "outubro": "Out",
        "11": "Nov", "nov": "Nov", "novembro": "Nov",
        "12": "Dez", "dez": "Dez", "dezembro": "Dez"
    }

    for linha in linhas[inicio_dados:]:
        if not linha or len(linha) < 3:
            continue
        ano_str = linha[0].strip()
        mes_str = linha[1].strip()
        val_str = linha[2].strip()

        if not ano_str or not mes_str:
            continue

        try:
            ano = int(float(ano_str))
        except ValueError:
            continue

        mes_formatado = mapa_meses.get(mes_str.lower(), mes_str.capitalize())

        # Limpa formatação numérica (ex: 185000, 185.000,00 ou R$ 185,000.00)
        limpo = val_str.replace("R$", "").replace(" ", "").strip()
        if "," in limpo and "." in limpo:
            # Formato brasileiro 185.000,00
            limpo = limpo.replace(".", "").replace(",", ".")
        elif "," in limpo:
            limpo = limpo.replace(",", ".")

        try:
            valor = float(limpo)
        except ValueError:
            valor = 0.0

        registros.append((ano, mes_formatado, valor))

    return registros


def carregar_dados_concorrente(caminho_arquivo: str = None):
    """
    Executa a carga dos dados de vendas do concorrente diretamente
    na tabela STG_CONCORRENTE_VENDAS da Staging Area (C##SA).
    Pode receber o caminho do arquivo via parâmetro, argumento de linha de comando
    ou variável de ambiente CONCORRENTE_FILE_PATH.
    """
    print("=" * 60)
    print("INICIANDO CARGA DIRETA: VENDAS DO CONCORRENTE (STAGING)")
    print("=" * 60)

    # 1. Determina o caminho do arquivo
    arquivo = None
    if caminho_arquivo:
        arquivo = Path(caminho_arquivo)
    elif os.getenv("CONCORRENTE_FILE_PATH"):
        arquivo = Path(os.getenv("CONCORRENTE_FILE_PATH"))
    else:
        padrao = current_dir / "08_Vendas_Concorrente.csv"
        if padrao.is_file():
            arquivo = padrao

    if not arquivo or not arquivo.is_file():
        raise FileNotFoundError(
            "Caminho do arquivo do concorrente não informado ou não encontrado. "
            "Passe via argumento --file <caminho> ou configure CONCORRENTE_FILE_PATH."
        )

    print(f"Lendo dados do arquivo: {arquivo}")
    registros = ler_arquivo_concorrente(arquivo)
    print(f"Total de registros lidos do arquivo: {len(registros)}")

    if not registros:
        print("[AVISO] Nenhum registro encontrado no arquivo.")
        return 0

    # 2. Conecta no banco e insere diretamente
    conn = oracledb.connect(**config.ORACLE_SA_CONFIG)
    cursor = conn.cursor()

    try:
        # Limpeza prévia para garantir idempotência
        cursor.execute("DELETE FROM STG_CONCORRENTE_VENDAS")
        print("Tabela STG_CONCORRENTE_VENDAS limpa com sucesso.")

        cursor.executemany("""
            INSERT INTO STG_CONCORRENTE_VENDAS (ANO, MES, VENDAS)
            VALUES (:1, :2, :3)
        """, registros)

        conn.commit()
        print(f"✓ Carga concluída com sucesso! {len(registros)} registros inseridos em STG_CONCORRENTE_VENDAS.")
        return len(registros)

    except Exception as e:
        conn.rollback()
        print(f"[ERRO] Falha ao carregar vendas do concorrente no Oracle: {e}")
        raise e
    finally:
        cursor.close()
        conn.close()


def main():
    parser = argparse.ArgumentParser(description="Carga de vendas do concorrente diretamente na Staging Area Oracle.")
    parser.add_argument("arquivo_posicional", nargs="?", default=None, help="Caminho do arquivo do concorrente (.csv)")
    parser.add_argument("--file", "-f", default=None, help="Caminho do arquivo do concorrente (.csv)")

    args = parser.parse_args()
    caminho = args.file or args.arquivo_posicional

    carregar_dados_concorrente(caminho)


if __name__ == "__main__":
    main()
