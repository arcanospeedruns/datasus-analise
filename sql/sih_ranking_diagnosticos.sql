-- Ranking de diagnósticos (CID-10, 3 caracteres) por nº de internações e custo, 2015-2023
-- O CID principal vem dividido: códigos de 4 caracteres em cid_principal_subcategoria
-- e de 3 caracteres em cid_principal_categoria (a outra coluna fica NULL).
WITH cid AS (
  SELECT DISTINCT categoria, descricao_categoria
  FROM `basedosdados.br_bd_diretorios_brasil.cid_10`
),
agg AS (
  SELECT
    COALESCE(SUBSTR(cid_principal_subcategoria, 1, 3), cid_principal_categoria) AS categoria,
    COUNT(*)                                       AS internacoes,
    ROUND(SUM(valor_aih) / 1e9, 3)                 AS valor_total_bi,
    ROUND(AVG(valor_aih), 0)                       AS valor_medio,
    ROUND(AVG(quantidade_dias_permanencia), 1)     AS media_dias,
    ROUND(100 * AVG(indicador_obito), 2)           AS pct_obito
  FROM `basedosdados.br_ms_sih.aihs_reduzidas`
  WHERE ano BETWEEN 2015 AND 2023
  GROUP BY 1
),
r AS (
  SELECT *,
    RANK() OVER (ORDER BY internacoes DESC)    AS rank_qtd,
    RANK() OVER (ORDER BY valor_total_bi DESC) AS rank_custo
  FROM agg
)
SELECT r.rank_qtd, r.rank_custo, r.categoria, cid.descricao_categoria,
       r.internacoes, r.valor_total_bi, r.valor_medio, r.media_dias, r.pct_obito
FROM r
LEFT JOIN cid USING (categoria)
WHERE r.rank_qtd <= 15 OR r.rank_custo <= 15
ORDER BY r.rank_qtd
