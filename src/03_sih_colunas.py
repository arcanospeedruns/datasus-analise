"""Internações (SIH): lista as colunas da tabela aihs_reduzidas e puxa uma amostra pequena."""
from bq import query, salvar

TABELA = "basedosdados.br_ms_sih.aihs_reduzidas"

# 1) colunas da tabela (consulta de metadados, quase não gasta cota)
colunas = query(f"""
SELECT column_name, data_type
FROM `basedosdados.br_ms_sih.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'aihs_reduzidas'
ORDER BY ordinal_position
""")
print(colunas.to_string(index=False))
salvar(colunas, "sih_colunas.csv")

# 2) amostra de 1 mês: filtrar por ano/mes faz o BigQuery ler só esse pedaço
amostra = query(f"""
SELECT *
FROM `{TABELA}`
WHERE ano = 2023 AND mes = 1
LIMIT 1000
""")
salvar(amostra, "sih_amostra_2023_01.csv")
