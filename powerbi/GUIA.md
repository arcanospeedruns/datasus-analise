# Dashboard em Power BI: passo a passo

Os dados vêm direto dos CSVs da pasta `resultados/` deste repositório, então não precisa baixar nada.

Arquivos desta pasta:
- `consultas.pq`: as 4 consultas do Power Query (carregam os dados)
- `medidas.dax`: as medidas DAX
- `tema-arcanospeedruns.json`: tema com as cores do portfólio (fundo escuro, amarelo de destaque)

Precisa do **Power BI Desktop**, que é gratuito e só roda no Windows (Microsoft Store ou site da Microsoft).

---

## 1. Carregar os dados

1. Abre o Power BI Desktop e cria um relatório em branco.
2. **Página Inicial > Transformar dados**. Abre o Power Query.
3. **Nova fonte > Consulta nula**.
4. **Editor Avançado**, apaga o que estiver lá e cola o primeiro bloco do `consultas.pq` (o `visao_anual`).
5. Clica em **Concluído** e renomeia a consulta (painel da esquerda) para `visao_anual`.
6. Repete os passos 3 a 5 para `ranking_diagnosticos`, `evolucao_diagnosticos` e `estados`.
7. Se aparecer um aviso de acesso ao conteúdo da Web, escolhe **Anônimo > Conectar**.
8. **Fechar e Aplicar**.

Confere: em `visao_anual`, 2023 deve ter 13.331.216 internações e `media_dias` 5,1 (se aparecer 510, o tipo foi lido errado: confere se o `"en-US"` está no fim da consulta).

## 2. Aplicar o tema

**Exibição > Temas > Procurar temas** e escolhe o `tema-arcanospeedruns.json`.

## 3. Criar as medidas

1. **Página Inicial > Inserir dados**, dá o nome `Medidas` e clica em **Carregar** (cria uma tabela só para guardar as medidas).
2. Seleciona a tabela `Medidas` > **Nova medida** e cola uma medida do `medidas.dax` por vez.
3. Formato de cada medida (aba **Ferramentas de medida**):
   - medidas com "% Óbito" e "Variação": **Porcentagem**, 2 casas
   - "Valor médio": **Moeda** (R$), 0 casas
   - "Gasto": número decimal, 2 casas
   - "Internações": número inteiro com separador de milhar
4. Clica com o botão direito na coluna vazia da tabela `Medidas` e oculta. A tabela vira uma pasta de medidas.

Não precisa criar relacionamentos: cada página usa uma tabela só.

## 4. Montar as páginas

Renomeia as abas de baixo com os nomes das páginas. Em todo gráfico com ano no eixo X, deixa o eixo como **Categórico** (Formatar > Eixo X > Tipo).

### Página 1: Visão geral

| Visual | Campos |
|---|---|
| Título (Caixa de texto) | "Internações no SUS, 2015–2023" |
| Cartão (um só, com 4 campos) | `Internações 2015–2023`, `Gasto 2015–2023`, `Valor médio por internação 2023`, `% Óbito 2021` |
| Gráfico de colunas | Eixo X: `visao_anual[ano]`, Eixo Y: `Internações` |
| Gráfico de colunas | Eixo X: `visao_anual[ano]`, Eixo Y: `Gasto (R$ bi)` |
| Gráfico de linhas | Eixo X: `visao_anual[ano]`, Eixo Y: `% Óbito` (liga os marcadores) |

Nos 3 gráficos: **Formatar > Editar interações** e desliga o filtro sobre o cartão, para os números do topo não mudarem quando alguém clica numa coluna.

Dica: nos gráficos por ano, em **Formatar > Colunas > Cor > fx**, pinta 2020 e 2021 de cinza (`#8D97AB`) para destacar a pandemia.

### Página 2: Diagnósticos

| Visual | Campos |
|---|---|
| Gráfico de barras | Eixo Y: `diagnostico`, Eixo X: `Internações por diagnóstico`. Filtro do visual: `diagnostico` > **N superior** 10 por `Internações por diagnóstico` |
| Gráfico de barras | Eixo Y: `diagnostico`, Eixo X: `Gasto por diagnóstico (R$ bi)`. Filtro: **N superior** 10 por `Gasto por diagnóstico (R$ bi)` |
| Tabela | `categoria`, `diagnostico`, `Internações por diagnóstico`, `Gasto por diagnóstico (R$ bi)`, `Valor médio por diagnóstico`, `% Óbito por diagnóstico` |

Na tabela: **Formatar > Formatação condicional > Barras de dados** em internações e gasto.

### Página 3: Evolução

1. **Modelagem > Novo parâmetro > Campos**. Nome: `Medida da evolução`. Adiciona `Internações (evolução)`, `Gasto (evolução, R$ mi)` e `% Óbito (evolução)`. Deixa marcado **Adicionar segmentação a esta página**.
2. Gráfico de linhas: Eixo X `evolucao_diagnosticos[ano]`, Eixo Y o parâmetro `Medida da evolução`, **Pequenos múltiplos** `diagnostico`.
3. Em **Formatar > Pequenos múltiplos > Layout**: 2 linhas × 5 colunas. Em **Eixo Y**, desliga "Escala compartilhada" para cada diagnóstico ter a própria escala.

A segmentação vira os botões de Internações / Gasto / Óbito.

### Página 4: Estados

| Visual | Campos |
|---|---|
| Gráfico de barras | Eixo Y: `sigla`, Eixo X: `Internações por mil hab. por ano`, classificado do maior para o menor |
| Gráfico de barras | Eixo Y: `sigla`, Eixo X: `% Óbito por estado` |
| Segmentação | `regiao` (em estilo de botões) |
| Tabela | `sigla`, `regiao`, `Internações por estado`, `Internações por mil hab. por ano`, `Valor médio por estado`, `% Óbito por estado` |

### Rodapé (todas as páginas)

Caixa de texto: "Fonte: SIH/SUS via Base dos Dados (BigQuery). Valores em reais da época. 2024 e 2025 fora do recorte por problemas na base."

## 5. Salvar e levar pro portfólio

1. Salva o `.pbix` (o deste repositório é o `powerbi/internacoes-sus.pbix`).
2. **Arquivo > Exportar > Exportar para PDF**, salva como `powerbi/internacoes-sus.pdf`.
3. Tira um print de cada página (ou exporta o PDF) e salva em `powerbi/img/`.

O "Publicar na Web" do Power BI só funciona com conta corporativa ou de escola, não com Gmail. Por isso, no portfólio o relatório entra como imagens e PDF, e o `.pbix` fica no repositório para quem quiser abrir.

Números para conferir depois de montar:

| Medida | Valor esperado |
|---|---|
| Internações | 107.368.293 |
| Gasto (R$ bi) | 151,73 |
| Valor médio 2023 | R$ 1.549 |
| % Óbito 2021 | 6,61% |
| Variação do valor médio 2015-2023 | 30,76% |
| COVID (B34), gasto | 10,68 |
