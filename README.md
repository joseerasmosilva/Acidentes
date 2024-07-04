# Análise de Acidentes de Trânsito no Brasil

Este repositório contém scripts R para a análise de dados de acidentes de trânsito no Brasil utilizando diferentes técnicas de modelagem estatística. Os dados utilizados são provenientes da Polícia Rodoviária Federal (PRF) e incluem informações detalhadas sobre os acidentes ocorridos em 2024. Os scripts cobrem uma variedade de abordagens, desde modelos de regressão logística multinomial até modelos de contagem zero-inflados com efeitos aleatórios.

## Scripts

### 1. Multinomial.R
Este script realiza uma análise de regressão logística multinomial para prever a classificação do tipo de lesão (Ileso, Lesões Graves, Lesões Leves, Óbito) com base em características do acidente e das condições envolvidas.
- **Bibliotecas Utilizadas**: `nnet`, `dplyr`, `caret`, `ggplot2`
- **Principais Funções**: Ajuste do modelo multinomial, cálculo de razões de chance (odds ratios), previsões e cálculo de acurácia, visualização das previsões versus valores reais.

### 2. Multinomial_multinivel.R
Este script expande a análise multinomial incluindo efeitos aleatórios por estado (UF) usando o pacote `brms`, que permite realizar inferências bayesianas em modelos de regressão multinível.
- **Bibliotecas Utilizadas**: `dplyr`, `brms`
- **Principais Funções**: Ajuste do modelo multinomial multinível, amostragem MCMC, visualização e interpretação dos resultados bayesianos.

### 3. Contagem_multinivel.R
Este script aplica modelos de contagem para analisar a frequência de feridos leves e mortos em acidentes de trânsito, utilizando tanto o modelo de Poisson quanto o modelo binomial negativo, ambos com componentes zero-inflados e efeitos aleatórios por estado (UF).
- **Bibliotecas Utilizadas**: `MASS`, `AER`, `ggplot2`, `pscl`, `glmmTMB`
- **Principais Funções**: Ajuste dos modelos de Poisson e binomial negativo zero-inflados, teste de sobredispersão, comparação de modelos via AIC, visualização da distribuição de variáveis de contagem.

## Requisitos
Os scripts requerem as seguintes bibliotecas R, que podem ser instaladas usando os comandos abaixo:

```r
install.packages("nnet")
install.packages("dplyr")
install.packages("caret")
install.packages("ggplot2")
install.packages("brms")
install.packages("MASS")
install.packages("AER")
install.packages("pscl")
install.packages("glmmTMB")
