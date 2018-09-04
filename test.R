library(shiny)

ui <- fluidPage(
  fluidRow(column(7,dataTableOutput('dto')))
)

server <- function(input,output){
  
  output$dto <- renderDataTable({MYTABLE})
  
  
}

runApp(list(ui=ui,server=server))



output$downloadData <- downloadHandler(
  filename = function() {
    paste(input$dataset, ".csv", sep = "")
  },
  content = function(file) {
    write.csv(datasetInput(), file, row.names = FALSE)
  })

?write.csv
names(one)
one <- read.csv('Files/IofMDFull.csv')

conditionalPanel(
  'input.dataset === "imd"',
  checkboxGroupInput("show_vars", "Columns in Indicies of Multiple Deprivation to show:",
                     names(imd), selected = names(imd))
),
conditionalPanel(
  'input.dataset === "cen"',
  checkboxGroupInput("show_vars2", "Columns in 2011 Census to show:",
                     names(cen), selected = names(cen))
),
fluidRow(column(7, dataTableOutput('dto'))),