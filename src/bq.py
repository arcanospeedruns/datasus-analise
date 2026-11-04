"""Conexão com o BigQuery + trava de custo."""
import os
from pathlib import Path

import pandas as pd
from dotenv import load_dotenv
from google.cloud import bigquery

ROOT = Path(__file__).resolve().parent.parent
load_dotenv(ROOT / ".env")

PROJECT_ID = os.getenv("GCP_PROJECT_ID")
MAX_GB = float(os.getenv("MAX_GB", "5"))
DATA_DIR = ROOT / "data"
SQL_DIR = ROOT / "sql"


def client() -> bigquery.Client:
    if not PROJECT_ID or PROJECT_ID == "seu-projeto-id":
        raise SystemExit("Configura o GCP_PROJECT_ID no arquivo .env")
    return bigquery.Client(project=PROJECT_ID)


def estimar_gb(sql: str) -> float:
    """Dry run: quanto a query vai ler, sem custo."""
    cfg = bigquery.QueryJobConfig(dry_run=True, use_query_cache=False)
    job = client().query(sql, job_config=cfg)
    return job.total_bytes_processed / 1e9


def query(sql: str, max_gb: float = MAX_GB) -> pd.DataFrame:
    gb = estimar_gb(sql)
    # obs: tabelas da Base dos Dados que são views sobre arquivos (ex: SIH)
    # retornam 0 GB no dry run, então a trava não pega essas
    print(f"Query vai ler ~{gb:.2f} GB")
    if gb > max_gb:
        raise SystemExit(f"Abortado: passa do limite de {max_gb} GB. Filtra mais a query.")
    return client().query(sql).to_dataframe()


def ler_sql(nome: str) -> str:
    return (SQL_DIR / nome).read_text(encoding="utf-8")


def salvar(df: pd.DataFrame, nome: str) -> Path:
    DATA_DIR.mkdir(exist_ok=True)
    caminho = DATA_DIR / nome
    df.to_csv(caminho, index=False, encoding="utf-8-sig")
    print(f"Salvo em {caminho} ({len(df)} linhas)")
    return caminho
