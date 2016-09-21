library(shiny)
library(ggplot2)
library(googleVis)

shinyServer(function(input,output,session){
  
  
tablaResultados<-reactive({
  tabla<-tablaEstados
  
  fmontoDia<-input$montoDia
  fmontoMes<-input$montoMes
  fmontoAno<-input$montoAno
  fenviosDia<-input$enviosDia
  fenviosMes<-input$enviosMes
  fenviosAno<-input$enviosAno
  
  tabla1<-datos %>%
    filter(montoDia<fmontoDia,
           montoMes<fmontoMes,
           montoAno<fmontoAno,
           enviosDia<fenviosDia,
           enviosMes<fenviosMes,
           enviosAno<fenviosAno
    ) %>%
    group_by(estado) %>%
    summarize(montoAjustado=sum(montoAno)) %>%
    as.data.frame()
  
  llave<-match(tabla$estado,tabla1$estado)
  
  
  
  tabla$montoAjustado<-tabla1$montoAjustado[llave]
  names(tabla)<-c('a','b','c')
  tabla<-tabla %>%
    mutate(porcentaje=round(c/b*100,1))
  
  names(tabla)<-c('Estado','Monto Original','Monto Ajustado','Porcentaje')
  
  tabla
})
    
output$tablaEstadosF<-DT::renderDataTable(DT::datatable({
  tablaResultados()
  
}))
  
output$mapa<-renderGvis({

map<-gvisGeoChart(tablaResultados(),"Estado","Porcentaje","Monto Original",
                  options=list(region="MX",
                               displayMode="regions",
                               resolution="provinces",
                               width=500,height=500))


})




  
  
})