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





output$downloadData <- downloadHandler(
  filename = function() {
    paste("data-", Sys.Date(), ".csv", sep="")
  },
  content = function(file) {
    write.csv(output$mytable1, file)
  }
)

output$downloadData <- downloadHandler(
  filename = function() {
    paste('Filtered data-', Sys.Date(), '.csv', sep = '')
  },
  content = function(file){
    write.csv(thedata()[input[["mytable1_rows_all"]], ],file)
  }
)

output$downloadData = downloadHandler('imdfiltered.csv', content = function(file) {
  s = input$show_vars_rows_all
  write.csv(imd[s, , drop = FALSE], file)
})