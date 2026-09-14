import os
from pathlib import Path

# ============================================================
# CARREGAMENTO DO ARQUIVO .ENV
# ============================================================

def _find_and_load_env():
    """
    Localiza e carrega o arquivo .env procurando a partir do diretório do script
    até a raiz do projeto, sem forçar dependências externas adicionais.
    """
    current = Path(__file__).resolve().parent
    # Procura até 3 níveis acima
    for _ in range(4):
        env_path = current / ".env"
        if env_path.is_file():
            with open(env_path, "r", encoding="utf-8") as f:
                for line in f:
                    line = line.strip()
                    if not line or line.startswith("#") or "=" not in line:
                        continue
                    key, val = line.split("=", 1)
                    key = key.strip()
                    val = val.strip().strip("\"'")
                    if key not in os.environ:
                        os.environ[key] = val
            break
        current = current.parent

_find_and_load_env()


# ============================================================
# PARÂMETROS GERAIS DO ORACLE
# ============================================================

ORACLE_HOST = os.getenv("ORACLE_HOST", "localhost")
ORACLE_PORT = int(os.getenv("ORACLE_PORT", "1521"))
ORACLE_SERVICE = os.getenv("ORACLE_SERVICE", "XE")

def get_oracle_dsn(host=None, port=None, service=None) -> str:
    h = host or ORACLE_HOST
    p = port or ORACLE_PORT
    s = service or ORACLE_SERVICE
    return f"{h}:{p}/{s}"

ORACLE_DSN = get_oracle_dsn()


# ============================================================
# CONFIGURAÇÕES ESPECÍFICAS DE CADA BANCO/SCHEMA
# ============================================================

# 1. Oracle - Salvador (Matriz / Fonte)
ORACLE_PETSHOP_CONFIG = {
    "user": os.getenv("ORACLE_PETSHOP_USER", "C##PETSHOP"),
    "password": os.getenv("ORACLE_PETSHOP_PASSWORD", "pet"),
    "dsn": ORACLE_DSN
}

# 2. Oracle - Feira de Santana (Fonte)
ORACLE_FEIRA_CONFIG = {
    "user": os.getenv("ORACLE_FEIRA_USER", "C##FEIRA"),
    "password": os.getenv("ORACLE_FEIRA_PASSWORD", "cimatec"),
    "dsn": ORACLE_DSN
}

# 3. Oracle - Staging Area (C##SA)
ORACLE_SA_CONFIG = {
    "user": os.getenv("ORACLE_SA_USER", "C##SA"),
    "password": os.getenv("ORACLE_SA_PASSWORD", "cimatec"),
    "dsn": ORACLE_DSN
}

# 4. PostgreSQL - Filial Itabuna (Fonte)
PG_ITABUNA_CONFIG = {
    "host": os.getenv("PG_ITABUNA_HOST", "localhost"),
    "port": int(os.getenv("PG_ITABUNA_PORT", "5435")),
    "database": os.getenv("PG_ITABUNA_DB", "petshop_itabuna"),
    "user": os.getenv("PG_ITABUNA_USER", "postgres"),
    "password": os.getenv("PG_ITABUNA_PASSWORD", "cimatec")
}

# 5. PostgreSQL - Data Warehouse (petshop_dw)
PG_DW_CONFIG = {
    "host": os.getenv("PG_DW_HOST", "localhost"),
    "port": int(os.getenv("PG_DW_PORT", "5434")),
    "database": os.getenv("PG_DW_DB", "petshop_dw"),
    "user": os.getenv("PG_DW_USER", "postgres"),
    "password": os.getenv("PG_DW_PASSWORD", "cimatec")
}
