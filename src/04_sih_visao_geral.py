"""Internações SUS por ano e UF (2015-2023)."""
from bq import ler_sql, query, salvar

UFS = {
    "11": "RO", "12": "AC", "13": "AM", "14": "RR", "15": "PA", "16": "AP", "17": "TO",
    "21": "MA", "22": "PI", "23": "CE", "24": "RN", "25": "PB", "26": "PE", "27": "AL",
    "28": "SE", "29": "BA", "31": "MG", "32": "ES", "33": "RJ", "35": "SP", "41": "PR",
    "42": "SC", "43": "RS", "50": "MS", "51": "MT", "52": "GO", "53": "DF",
}

df = query(ler_sql("sih_visao_geral.sql"))
df["sigla_uf"] = df["cod_uf"].map(UFS)
salvar(df, "sih_visao_geral.csv")

# resumo Brasil por ano
brasil = df.groupby("ano").agg(
    internacoes=("internacoes", "sum"),
    valor_total=("valor_total", "sum"),
)
brasil["valor_total_bi"] = (brasil["valor_total"] / 1e9).round(2)
print(brasil[["internacoes", "valor_total_bi"]].to_string())
