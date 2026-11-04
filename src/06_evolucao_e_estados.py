"""Evolução anual dos 10 diagnósticos principais e comparação entre estados."""
from bq import ler_sql, query, salvar

evo = query(ler_sql("sih_evolucao_diagnosticos.sql"))
salvar(evo, "sih_evolucao_diagnosticos.csv")
print(evo.pivot(index="categoria", columns="ano", values="internacoes").to_string())

uf = query(ler_sql("sih_estados.sql"))
salvar(uf, "sih_estados.csv")
print(uf.to_string(index=False))
