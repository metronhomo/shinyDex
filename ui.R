library(shiny)
library(ggplot2)

shinyUI(
  navbarPage(
    "Metronhomo",id='nav',
    tabPanel(
      "Impacto de filtros",
      fluidRow(
        column(
          3,
          wellPanel(
            h4("Filtros"),
            sliderInput(
              "enviosDia",
              "Número máximo de envíos por día",
              0,100,10,step=1
            ),
            sliderInput(
              "enviosMes",
              "Número máximo de envíos por mes",
              0,500,20,step=1
            ),
            sliderInput(
              "enviosAno",
              "Número máximo de envíos por año",
              0,1000,50,step=1
            ),
            sliderInput(
              "montoDia",
              "Monto máximo por día",
              0,100000,10000,step=1000
            ),
            sliderInput(
              "montoMes",
              "Monto máximo por mes",
              0,1000000,10000,step=1000
            ),
            sliderInput(
              "montoAno",
              "Monto máximo por año",
              0,10000000,10000,step=1000
            )
          )
        ),
        column(
          4,
          htmlOutput("mapa")
        ),
        column(
          4,
          DT::dataTableOutput("tablaEstadosF")
        )
      )
    )
  )
)