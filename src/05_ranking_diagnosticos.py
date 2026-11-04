"""Diagnósticos que mais internam e que mais custam ao SUS (2015-2023)."""
from bq import ler_sql, query, salvar

df = query(ler_sql("sih_ranking_diagnosticos.sql"))
salvar(df, "sih_ranking_diagnosticos.csv")

cols = ["categoria", "descricao_categoria", "internacoes", "valor_total_bi", "pct_obito"]
print("\nTop 10 por número de internações")
print(df.sort_values("rank_qtd").head(10)[cols].to_string(index=False))
print("\nTop 10 por custo total")
print(df.sort_values("rank_custo").head(10)[cols].to_string(index=False))
