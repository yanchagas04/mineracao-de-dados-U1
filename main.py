import runpy
from pathlib import Path

from src.concorrente.etl_concorrente import carregar_dados_concorrente
from src.filial_feira.json_para_DML import carregar_dados_feira


PROJECT_ROOT = Path(__file__).resolve().parent


def executar_script(caminho: Path) -> None:
    runpy.run_path(str(caminho), run_name="__main__")


def main() -> None:
    # 1. Carrega as origens que ainda não estão em banco.
    carregar_dados_feira(dir_path=str(PROJECT_ROOT / "src" / "filial_feira"))
    carregar_dados_concorrente(
        str(PROJECT_ROOT / "src" / "concorrente" / "08_Vendas_Concorrente.csv")
    )

    # 2. Extrai as três filiais para a Staging Area (C##SA).
    staging_dir = PROJECT_ROOT / "src" / "staging_area"
    executar_script(staging_dir / "etl_salvador.py")
    executar_script(staging_dir / "etl_itabuna.py")
    executar_script(staging_dir / "etl_feira.py")

    # 3. Higieniza, padroniza e enriquece.
    executar_script(staging_dir / "transform.py")

    # 4. Carrega dimensões e fatos no DW final.
    executar_script(PROJECT_ROOT / "src" / "dw" / "load_dw.py")


if __name__ == "__main__":
    main()