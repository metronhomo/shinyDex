library(dplyr)

datos<-readRDS('data/datosCliente.rds')

tablaEstados<-datos %>%
  group_by(estado) %>%
  summarize(montoOriginal=sum(montoAno)) %>%
  as.data.frame()