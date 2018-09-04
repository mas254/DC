# app

library(shiny)
library(data.table)
library(DT)

# Load data ----
imd1 <- readRDS("data/imd.rds")
cen1 <- readRDS("data/cen.rds")
cen <- as.data.frame(cen1)
imd <- as.data.frame(imd1)


# User interface ----
ui <- fluidPage(
  titlePanel("Indicies of Multiple Deprivation Data"),
  sidebarLayout(
    sidebarPanel(
      helpText("Create a csv file containing information
               from the Indicies of Multiple Deprivation Data
               for Devon postcodes."),
      helpText("Make sure to input the postcode with a space
               before the final three digits (e.g. EX39 1PS or
               EX4 6JL rather than EX391PS or EX46JL)."),
      fluidRow(
        p(downloadButton('downloadData', 'Download'))
      ),
      checkboxGroupInput("show_vars2", "Columns in 2011 Census to show:",
                         names(cen), selected = names(cen)
      ),
        checkboxGroupInput("show_vars", "Columns in Indicies of Multiple Deprivation to show:",
                           names(imd), selected = names(imd)
      ),
      fluidRow(column(2, dataTableOutput('dto')))
    ),
    mainPanel(
      tabsetPanel(id = 'dataset',
              tabPanel("2011 Census", DT::dataTableOutput("mytable2")),
              tabPanel("Indicies of Multiple Deprivation", DT::dataTableOutput("mytable1")))
    )
  )
)

server <- function(input, output){
  
  # choose columns to display
  iod = imd[sample(nrow(imd), ), ]
  
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(iod[, input$show_vars, drop = FALSE])
  })
  
  cens = cen[sample(nrow(cen), ), ]
  
  output$mytable2 <- DT::renderDataTable({
    DT::datatable(cens[, input$show_vars2, drop = FALSE])
  })

  output$downloadData <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(output$mytable1, file)
    }
  )
  
  output$downloadData = downloadHandler('imdfiltered.csv', content = function(file) {
    s = input$show_vars_rows_all
    write.csv(imd[s, , drop = FALSE], file)
  })
  
  
}

shinyApp(ui = ui, server = server)