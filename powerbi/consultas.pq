// =====================================================================
// Consultas do Power Query, uma por tabela.
// Em cada uma: Página Inicial > Nova fonte > Consulta nula > Editor Avançado,
// apaga o que estiver lá, cola o bloco e renomeia a consulta com o nome indicado.
// O "en-US" no fim garante que 5.47 seja lido como 5,47 (e não 547).
// =====================================================================


// ---------- Consulta: visao_anual ----------
let
    Fonte = Csv.Document(
        Web.Contents("https://raw.githubusercontent.com/arcanospeedruns/datasus-analise/main/resultados/visao_anual.csv"),
        [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    Cabecalho = Table.PromoteHeaders(Fonte, [PromoteAllScalars = true]),
    Tipos = Table.TransformColumnTypes(Cabecalho, {
        {"ano", Int64.Type}, {"internacoes", Int64.Type}, {"media_dias", type number},
        {"valor_medio", type number}, {"valor_total_bi", type number}, {"pct_obito", type number}
    }, "en-US")
in
    Tipos


// ---------- Consulta: ranking_diagnosticos ----------
let
    Fonte = Csv.Document(
        Web.Contents("https://raw.githubusercontent.com/arcanospeedruns/datasus-analise/main/resultados/ranking_diagnosticos.csv"),
        [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    Cabecalho = Table.PromoteHeaders(Fonte, [PromoteAllScalars = true]),
    Tipos = Table.TransformColumnTypes(Cabecalho, {
        {"categoria", type text}, {"diagnostico", type text}, {"rank_qtd", Int64.Type}, {"rank_custo", Int64.Type},
        {"internacoes", Int64.Type}, {"valor_total_bi", type number}, {"valor_medio", type number},
        {"media_dias", type number}, {"pct_obito", type number}
    }, "en-US")
in
    Tipos


// ---------- Consulta: evolucao_diagnosticos ----------
let
    Fonte = Csv.Document(
        Web.Contents("https://raw.githubusercontent.com/arcanospeedruns/datasus-analise/main/resultados/evolucao_diagnosticos.csv"),
        [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    Cabecalho = Table.PromoteHeaders(Fonte, [PromoteAllScalars = true]),
    Tipos = Table.TransformColumnTypes(Cabecalho, {
        {"ano", Int64.Type}, {"categoria", type text}, {"diagnostico", type text},
        {"internacoes", Int64.Type}, {"valor_total_mi", type number}, {"pct_obito", type number}
    }, "en-US")
in
    Tipos


// ---------- Consulta: estados ----------
let
    Fonte = Csv.Document(
        Web.Contents("https://raw.githubusercontent.com/arcanospeedruns/datasus-analise/main/resultados/estados.csv"),
        [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    Cabecalho = Table.PromoteHeaders(Fonte, [PromoteAllScalars = true]),
    Tipos = Table.TransformColumnTypes(Cabecalho, {
        {"sigla", type text}, {"regiao", type text}, {"internacoes", Int64.Type},
        {"valor_medio", type number}, {"pct_obito", type number}, {"media_dias", type number},
        {"intern_por_mil_hab", type number}
    }, "en-US")
in
    Tipos
