-- Visão geral das internações SUS por ano e UF
-- sigla_uf vem NULL na tabela (bug da Base dos Dados), então a UF é tirada
-- dos 2 primeiros dígitos do código IBGE do município do estabelecimento.
SELECT
  ano,
  SUBSTR(id_municipio_estabelecimento, 1, 2)      AS cod_uf,
  COUNT(*)                                        AS internacoes,
  ROUND(AVG(quantidade_dias_permanencia), 2)      AS media_dias,
  ROUND(AVG(valor_aih), 2)                        AS valor_medio,
  ROUND(SUM(valor_aih), 2)                        AS valor_total,
  ROUND(100 * AVG(indicador_obito), 2)            AS pct_obito
FROM `basedosdados.br_ms_sih.aihs_reduzidas`
WHERE ano BETWEEN 2015 AND 2023
GROUP BY ano, cod_uf
ORDER BY ano, cod_uf
