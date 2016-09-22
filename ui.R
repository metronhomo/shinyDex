library(shiny)
library(ggplot2)

shinyUI(
  navbarPage(
    "Metronhomo",id='nav',
    tabPanel(
      "Impacto de filtros",
      fluidRow(
        column(
          2,
          wellPanel(
            style = "background-color: #ffffff;",
            sliderInput(
              "enviosDia",
              "envíos por día",
              0,100,10,step=1
            ),
            sliderInput(
              "enviosMes",
              "envíos por mes",
              0,500,20,step=1
            ),
            sliderInput(
              "enviosAno",
              "envíos por año",
              0,1000,50,step=1
            )
          )
        ),
        column(
          2,
          wellPanel(
            style = "background-color: #ffffff;",
            sliderInput(
              "montoDia",
              "monto por día",
              0,100000,10000,step=1000
            ),
            sliderInput(
              "montoMes",
              "monto por mes",
              0,1000000,10000,step=1000
            ),
            sliderInput(
              "montoAno",
              "monto por año",
              0,10000000,10000,step=1000
            )
          )
        ),
        column(
          2,
          wellPanel(
            style = "background-color: #ffffff;",
            sliderInput(
              "destinatarioDia",
              "beneficiarios por día",
              0,5,2,step=1
            ),
            sliderInput(
              "destinatarioMes",
              "beneficiarios por mes",
              0,10,5,step=1
            ),
            sliderInput(
              "destinatarioAno",
              "beneficiarios por año",
              0,50,10,step=1
            )
          )
        ),
        column(
          2,
          wellPanel(
            style = "background-color: #ffffff;",
            sliderInput(
              "paisDia",
              "paises por día",
              0,5,1,step=1
            ),
            sliderInput(
              "paisMes",
              "paises por mes",
              0,10,2,step=1
            ),
            sliderInput(
              "paisAno",
              "paises por año",
              0,50,10,step=1
            )
          )
        ),
        column(
          2,
          wellPanel(
            style = "background-color: #ffffff;",
            sliderInput(
              "sucursalDia",
              "sucursales por día",
              0,5,1,step=1
            ),
            sliderInput(
              "sucursalMes",
              "sucursales por mes",
              0,10,2,step=1
            ),
            sliderInput(
              "sucursalAno",
              "sucursales por año",
              0,50,10,step=1
            )
          )
        )
      ),
      fluidRow(
        column(
          6,
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