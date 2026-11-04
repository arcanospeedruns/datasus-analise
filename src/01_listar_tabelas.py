"""Testa a conexão e lista as tabelas do SUS disponíveis na Base dos Dados."""
from bq import query, salvar

# Datasets do Ministério da Saúde na Base dos Dados
DATASETS = [
    "br_ms_sim",      # mortalidade
    "br_ms_sinasc",   # nascidos vivos
    "br_ms_sih",      # internações hospitalares
    "br_ms_sia",      # produção ambulatorial
    "br_ms_cnes",     # estabelecimentos de saúde
    "br_ms_sinan",    # doenças de notificação
]

partes = []
for ds in DATASETS:
    partes.append(
        f"SELECT '{ds}' AS dataset, table_name "
        f"FROM `basedosdados.{ds}.INFORMATION_SCHEMA.TABLES`"
    )

sql = "\nUNION ALL\n".join(partes) + "\nORDER BY dataset, table_name"

try:
    df = query(sql)
except Exception as e:
    # se algum dataset não existir, testa um por um
    print(f"Consulta conjunta falhou ({e.__class__.__name__}), tentando um por um...")
    import pandas as pd
    dfs = []
    for p in partes:
        try:
            dfs.append(query(p))
        except Exception as erro:
            print(f"  pulando: {p.split('`')[1]} -> {erro.__class__.__name__}")
    df = pd.concat(dfs, ignore_index=True)

print(df.to_string(index=False))
salvar(df, "tabelas_disponiveis.csv")
