import sys
from pathlib import Path

current_dir = Path(__file__).resolve().parent
src_dir = current_dir.parent if current_dir.name != "src" else current_dir
if str(src_dir) not in sys.path:
    sys.path.insert(0, str(src_dir))

from filial_feira.json_para_DML import main, carregar_dados_feira

if __name__ == "__main__":
    main()
