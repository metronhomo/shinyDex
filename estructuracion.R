
#defino el espacio de trabajo y cargo los datos---------------------------------------------------------------------------

setwd("~/Repositorios/shinyDex")
datosOriginales<-readRDS('2015.rds')
head(datosOriginales)
summary(datosOriginales)

#me quedo con lo que necesito----------------------------------------------------------------------------------------------

library(dplyr)
datos<-datosOriginales %>%
  select(tipoOperacion=FCTIPOOPERACION,
         idEnvio=NO_CLIENTE_REMITENTE,
         idPago=NO_CLIENTE_BENEF,
         monto=FNMONTOENVIO,
         comision=FNCOMISIONMO,
         fechaEnvio=FECHA_ENVIO,
         fechaPago=FECHA_PAGO,
         estadoEnvio=FCESTADOORIGEN,
         estadoPago=FCESTADODESTINO,
         sucursalEnvio=FCNOMBRESUCURSALENVIO,
         sucursalPago=FCNOMBRESUCURSALDESTINO,
         paisPago=FCPAISDESTINO
         ) %>%
  filter(tipoOperacion=='ENVIO')

datos$fechaEnvio<-as.character(datos$fechaEnvio)
datos$monto<-as.numeric(as.character(datos$monto))

#creo las variables de día mes y año--------------------------------------------------------------------------------------

library(stringr)

datos<-datos %>%
  mutate(anoEnvio=as.factor(str_sub(fechaEnvio,-13,-10)),
         mesEnvio=as.factor(str_sub(fechaEnvio,-16,-15)),
         diaEnvio=as.factor(str_sub(fechaEnvio,-19,-18))
         ) %>%
  filter(anoEnvio=='2015')





#creo la tabla de resumen de información-----------------------------------------------------------------------------------------

library(dplyr)

#número de envíos
enviosDia<-datos %>%
  mutate(envioMesDia=paste0(mesEnvio,'_',diaEnvio)) %>%
  group_by(idEnvio,envioMesDia) %>%
  summarize(envios=n()) %>%
  group_by(idEnvio) %>%
  summarise(enviosMaximosDia=max(envios,na.rm=T)) %>%
  as.data.frame()

enviosMes<-datos %>%
  group_by(idEnvio,mesEnvio) %>%
  summarize(envios=n()) %>%
  group_by(idEnvio) %>%
  summarise(enviosMaximosMes=max(envios,na.rm=T)) %>%
  as.data.frame()

enviosAno<-datos %>%
  group_by(idEnvio) %>%
  summarize(envios=n()) %>%
  as.data.frame()

#montos de las transacciones
montoDia<-datos %>%
  mutate(envioMesDia=paste0(mesEnvio,'_',diaEnvio)) %>%
  group_by(idEnvio,envioMesDia) %>%
  summarize(montoT=sum(monto)) %>%
  group_by(idEnvio) %>%
  summarise(montoMaximosDia=max(montoT,na.rm=T)) %>%
  as.data.frame()

montoMes<-datos %>%
  group_by(idEnvio,mesEnvio) %>%
  summarize(montoT=sum(monto)) %>%
  group_by(idEnvio) %>%
  summarise(montoMaximosMes=max(montoT)) %>%
  as.data.frame()

montoAno<-datos %>%
  group_by(idEnvio) %>%
  summarize(montoMaximoAno=sum(monto)) %>%
  as.data.frame()

montoTotal<-datos %>%
  group_by(idEnvio) %>%
  summarize(total=sum(monto)) %>%
  as.data.frame()

datosCliente<-enviosDia
datosCliente<-cbind(datosCliente,enviosMes[,2],enviosAno[,2],montoDia[,2],montoMes[,2],montoAno[,2])
names(datosCliente)<-c('id','enviosDia','enviosMes','enviosAno','montoDia','montoMes','montoAno')
head(datosCliente)

#asigno el estado original-------------------------------------------------------------------------------------------

llave<-match(datosCliente$id,datosOriginales$NO_CLIENTE_REMITENTE)
datosCliente$estado<-datosOriginales$FCESTADOORIGEN[llave]

#número de destinatarios--------------------------------------------------------------------------------------------------

destinoDia<-datos %>%
  mutate(envioMesDia=paste0(mesEnvio,'_',diaEnvio,'_',idPago)) %>%
  group_by(idEnvio,envioMesDia) %>%
  summarize(envios=n()) %>%
  group_by(idEnvio) %>%
  summarise(enviosMaximosDia=max(envios,na.rm=T)) %>%
  as.data.frame()

destinoMes<-datos %>%
  group_by(idEnvio,mesEnvio,idPago) %>%
  summarize(envios=n()) %>%
  group_by(idEnvio) %>%
  summarise(enviosMaximosMes=max(envios,na.rm=T)) %>%
  as.data.frame()

destinoAno<-datos %>%
  group_by(idEnvio,idPago) %>%
  summarize(envios=n()) %>%
  group_by(idEnvio) %>%
  summarise(enviosMaximosDia=max(envios,na.rm=T)) %>%
  as.data.frame()

datosCliente$destinatarioDia<-destinoDia[,2]
datosCliente$destinatarioMes<-destinoMes[,2]
datosCliente$destinatarioAno<-destinoAno[,2]

#número de paises destino--------------------------------------------------------------------------------------------------

paisDia<-datos %>%
  mutate(envioMesDia=paste0(mesEnvio,'_',diaEnvio,'_',paisPago)) %>%
  group_by(idEnvio,envioMesDia) %>%
  summarize(envios=n()) %>%
  group_by(idEnvio) %>%
  summarise(enviosMaximosDia=max(envios,na.rm=T)) %>%
  as.data.frame()

paisMes<-datos %>%
  group_by(idEnvio,mesEnvio,paisPago) %>%
  summarize(envios=n()) %>%
  group_by(idEnvio) %>%
  summarise(enviosMaximosMes=max(envios,na.rm=T)) %>%
  as.data.frame()

paisAno<-datos %>%
  group_by(idEnvio,paisPago) %>%
  summarize(envios=n()) %>%
  group_by(idEnvio) %>%
  summarise(enviosMaximosDia=max(envios,na.rm=T)) %>%
  as.data.frame()

datosCliente$paisDia<-paisDia[,2]
datosCliente$paisMes<-paisMes[,2]
datosCliente$paisAno<-paisAno[,2]

#número de sucursales destino--------------------------------------------------------------------------------------------------

sucursalDia<-datos %>%
  mutate(envioMesDia=paste0(mesEnvio,'_',diaEnvio,'_',sucursalPago)) %>%
  group_by(idEnvio,envioMesDia) %>%
  summarize(envios=n()) %>%
  group_by(idEnvio) %>%
  summarise(enviosMaximosDia=max(envios,na.rm=T)) %>%
  as.data.frame()

sucrursalMes<-datos %>%
  group_by(idEnvio,mesEnvio,sucursalPago) %>%
  summarize(envios=n()) %>%
  group_by(idEnvio) %>%
  summarise(enviosMaximosMes=max(envios,na.rm=T)) %>%
  as.data.frame()

sucrusalAno<-datos %>%
  group_by(idEnvio,sucursalPago) %>%
  summarize(envios=n()) %>%
  group_by(idEnvio) %>%
  summarise(enviosMaximosDia=max(envios,na.rm=T)) %>%
  as.data.frame()

datosCliente$sucursalDia<-sucursalDia[,2]
datosCliente$sucursalMes<-sucrursalMes[,2]
datosCliente$sucursalAno<-sucrusalAno[,2]




#pongo los nombres correctos a cada uno de los estados------------------------------------------------------------------
#para que sean compatibles con googleVis

library(stringr)

datosCliente$estado<-as.character(datosCliente$estado)
unique(datosCliente$estado)
datosCliente$estado<-str_replace_all(datosCliente$estado,"ESTADO DE MEXICO","ESTADO DE MÉXICO")
datosCliente$estado<-str_replace_all(datosCliente$estado,"D.F.","DISTRITO FEDERAL")
datosCliente$estado<-str_replace_all(datosCliente$estado,"NUEVO LEON","NUEVO LEÓN")
datosCliente$estado<-str_replace_all(datosCliente$estado,"MICHOACAN","MICHOACÁN")
datosCliente$estado<-str_replace_all(datosCliente$estado,"SAN LUIS POTOSI","SAN LUÍS POTOSÍ")
datosCliente$estado<-str_replace_all(datosCliente$estado,"YUCATAN","YUCATÁN")
datosCliente$estado<-str_replace_all(datosCliente$estado,"QUERETARO","QUERÉTARO")


#guardo los resultados---------------------------------------------------------------------------------------

saveRDS(datosCliente,'data/datosCliente.rds')
