#install.packages("nnet")
#install.packages("dplyr")
#install.packages("glmmTMB")
#install.packages("brms")
#install.packages("caret")
#install.packages("ggplot2")



library(caret)
library(nnet)
library(dplyr)
library(ggplot2)
#library(glmmTMB)
#library(brms)



# Fonte dos dados
# https://www.gov.br/prf/pt-br/acesso-a-informacao/dados-abertos/dados-abertos-da-prf
# Arquivo: Documento CSV de Acidentes 2024 (Agrupados por pessoa - Todas as causas e tipos de acidentes)

# Carrega dados
df <- read.csv2('acidentes2024_todas_causas_tipos.csv', fileEncoding = 'ISO-8859-1')

# Filtrar os dados onde causa_principal é "Sim"
df <- subset(df, causa_principal == "Sim")

# Filtrar os dados onde ordem_tipo_acidente é "1"
df <- subset(df, ordem_tipo_acidente == 1)

summary(df)

# Remover linhas com valores NA
df <- na.omit(df)

# Classificação do tipo de lesão do acidente em função de outras caracteristicas
table(df$estado_fisico)

# Lista de variáveis a serem transformadas em fatores
variaveis_para_fator <- c(
  "dia_semana", "horario", "uf", "municipio", "causa_principal", 
  "causa_acidente", "tipo_acidente", "classificacao_acidente", 
  "fase_dia", "sentido_via", "condicao_metereologica", "tipo_pista", 
  "tracado_via", "uso_solo", "tipo_veiculo", "marca", "tipo_envolvido", "sexo",
  "estado_fisico"
)

# Transformar as variáveis em fatores
df[variaveis_para_fator] <- lapply(df[variaveis_para_fator], as.factor)

# Remover níveis vazios de todas as variáveis fatoriais
df[variaveis_para_fator] <- lapply(df[variaveis_para_fator], droplevels)

# Verificar a classe das variáveis para garantir que foram transformadas
sapply(df[variaveis_para_fator], class)

# Verificar níveis da variável estado_fisico
table(df$estado_fisico)

# Ajustar o modelo multinomial simples
modelo <- multinom(estado_fisico ~ idade + sexo + dia_semana + uf + tipo_acidente
                   + causa_acidente + fase_dia + tipo_pista + ano_fabricacao_veiculo
                   + uso_solo + condicao_metereologica + tipo_veiculo + causa_acidente
                   , data = df)

# Sumário do modelo
summary(modelo)

# Calcular as razões de chance (odds ratios)
exp(coef(modelo))

# Prever a probabilidade de cada categoria
pred_prob <- predict(modelo, type = "probs")

# Prever as classes
pred_classes <- predict(modelo, type = "class")

# Calcular a acurácia
accuracy <- mean(pred_classes == df$estado_fisico)
print(paste("Acurácia:", accuracy))

# Criar a matriz de confusão
conf_matrix <- confusionMatrix(pred_classes, df$estado_fisico)
print(conf_matrix)


# Criar um dataframe com as previsões e os valores reais
df_results <- data.frame(
  Real = df$estado_fisico,
  Predito = pred_classes
)

# Gráfico de barras das previsões vs. valores reais
ggplot(df_results, aes(x = Real, fill = Predito)) +
  geom_bar(position = "dodge") +
  labs(title = "Previsões vs. Valores Reais", x = "Real", y = "Contagem")
