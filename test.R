library(shiny)

ui <- fluidPage(
  fluidRow(column(7,dataTableOutput('dto')))
)

server <- function(input,output){
  
  output$dto <- renderDataTable({MYTABLE})
  
  
}

runApp(list(ui=ui,server=server))