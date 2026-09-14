"""
Módulo de configuração espelhado para importação via pacote (from mineracao_de_dados import config).
"""
import sys
from pathlib import Path

# Garante acesso ao src/config.py
src_dir = Path(__file__).resolve().parent.parent
if str(src_dir) not in sys.path:
    sys.path.insert(0, str(src_dir))

from config import (
    ORACLE_HOST,
    ORACLE_PORT,
    ORACLE_SERVICE,
    ORACLE_DSN,
    get_oracle_dsn,
    ORACLE_PETSHOP_CONFIG,
    ORACLE_FEIRA_CONFIG,
    ORACLE_SA_CONFIG,
    PG_ITABUNA_CONFIG,
    PG_DW_CONFIG,
)
