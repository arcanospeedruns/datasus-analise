-- Evolução anual (2015-2023) dos 10 diagnósticos principais
SELECT
  ano,
  COALESCE(SUBSTR(cid_principal_subcategoria, 1, 3), cid_principal_categoria) AS categoria,
  COUNT(*)                               AS internacoes,
  ROUND(SUM(valor_aih) / 1e6, 1)         AS valor_total_mi,
  ROUND(100 * AVG(indicador_obito), 2)   AS pct_obito
FROM `basedosdados.br_ms_sih.aihs_reduzidas`
WHERE ano BETWEEN 2015 AND 2023
  AND COALESCE(SUBSTR(cid_principal_subcategoria, 1, 3), cid_principal_categoria)
      IN ('B34', 'J18', 'I21', 'A41', 'I20', 'I50', 'N18', 'I64', 'O80', 'O82')
GROUP BY 1, 2
ORDER BY 2, 1
