#install.packages("nnet")
#install.packages("dplyr")
#install.packages("glmmTMB")
#install.packages("brms")

#library(nnet)
library(dplyr)
#library(glmmTMB)
library(brms)



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

# Renomear níveis da variável estado_fisico (Stan não aceita nomes com acentos)
levels(df$estado_fisico) <- c("Ileso", "Lesoes_Graves", "Lesoes_Leves", "Obito")

summary(df)

# Ajustar o modelo multinomial com efeitos aleatórios por UF
modelo <- brm(
  formula = estado_fisico ~ idade + sexo + dia_semana + uf + tipo_acidente
  + causa_acidente + fase_dia + tipo_pista + ano_fabricacao_veiculo
  + uso_solo + condicao_metereologica + tipo_veiculo + causa_acidente + (1 | uf),
  data = df,
  family = categorical(),
  chains = 2  # default são 4
)

# Sumário do modelo
summary(modelo)

