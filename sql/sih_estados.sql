-- Comparação entre estados (UF do hospital), 2015-2023
-- Taxa por mil habitantes = internações / soma da população dos anos x 1000 (média anual)
WITH s AS (
  SELECT
    ano,
    SUBSTR(id_municipio_estabelecimento, 1, 2) AS id_uf,
    COUNT(*)                                   AS n,
    SUM(valor_aih)                             AS v,
    SUM(indicador_obito)                       AS ob,
    SUM(quantidade_dias_permanencia)           AS d
  FROM `basedosdados.br_ms_sih.aihs_reduzidas`
  WHERE ano BETWEEN 2015 AND 2023
  GROUP BY 1, 2
),
j AS (
  SELECT s.*, u.sigla, u.regiao, p.populacao
  FROM s
  JOIN `basedosdados.br_bd_diretorios_brasil.uf` u USING (id_uf)
  LEFT JOIN `basedosdados.br_ibge_populacao.uf` p
    ON p.sigla_uf = u.sigla AND p.ano = s.ano
)
SELECT
  sigla,
  regiao,
  SUM(n)                                                         AS internacoes,
  ROUND(SUM(v) / SUM(n), 0)                                      AS valor_medio,
  ROUND(100 * SUM(ob) / SUM(n), 2)                               AS pct_obito,
  ROUND(SUM(d) / SUM(n), 2)                                      AS media_dias,
  ROUND(1000 * SUM(IF(populacao IS NOT NULL, n, 0)) / SUM(populacao), 1) AS intern_por_mil_hab
FROM j
GROUP BY 1, 2
ORDER BY internacoes DESC
