# Reinstalar o pacote TMB a partir do código-fonte
install.packages("TMB", type = "source")

# Reinstalar o pacote glmmTMB a partir do código-fonte
install.packages("glmmTMB", type = "source")

# Carregar os pacotes
library(glmmTMB)


# Atualizar pacotes brms e rstan
install.packages("brms", dependencies = TRUE)
install.packages("rstan", dependencies = TRUE)

