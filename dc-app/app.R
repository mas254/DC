# app

library(shiny)
library(data.table)
library(DT)

# Load data ----
imd1 <- readRDS("data/imd.rds")
cen1 <- readRDS("data/cen.rds")
cen <- as.data.frame(cen1)
imd <- as.data.frame(imd1)
imd$PCD8 <- factor(imd$PCD8, ordered = TRUE)
cen$PCD8 <- factor(cen$PCD8, ordered = TRUE)
setnames(imd, "PCD8", "Postcode")
setnames(cen, "PCD8", "Postcode")
cen$PCD7 <- NULL


# User interface ----
ui <- fluidPage(
  titlePanel("Indicies of Multiple Deprivation Data"),
  sidebarLayout(
    sidebarPanel(
      helpText("Create a csv file containing information
               from the Indicies of Multiple Deprivation Data
               for Devon postcodes."),
      helpText("Type the postcode you want to select in the search
               bar beneath the 'Postcode' column header, then click
               on the postcode when it appears in the drop down menu
               to filter the table."),
      helpText("For multiple postcodes, simply
               type another postcode into this search bar after
               selecting the first postcode."),
      helpText("Make sure to input the postcode with a space
               before the final three digits (e.g. EX39 1PS or
               EX4 6JL rather than EX391PS or EX46JL)."),
      fluidRow(
        p(downloadButton('downloadMoreData', 'Download 2011 Census Data'))
      ),
      fluidRow(
        p(downloadButton('downloadData', 'Download Indicies of Multiple Deprivation Data'))
      ),
      checkboxGroupInput("show_vars2", "Columns in 2011 Census to show:",
                         names(cen), selected = names(cen)
      ),
        checkboxGroupInput("show_vars", "Columns in Indicies of Multiple Deprivation to show:",
                           names(imd), selected = names(imd)
      )
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
    DT::datatable(iod[, input$show_vars, drop = FALSE], filter = "top")
  })
  
  cens = cen[sample(nrow(cen), ), ]
  
  output$mytable2 <- DT::renderDataTable({
    DT::datatable(cens[, input$show_vars2, drop = FALSE], filter = "top")
  })
  
  moredata <- reactive(cens)
  
  output$downloadMoreData <- downloadHandler(
    filename = function() {
      paste('Filtered data-', Sys.time(), '.csv', sep = '')
    },
    content = function(file){
      write.csv(moredata()[input[["mytable2_rows_all"]], ],file)
    }
  )

  thedata <- reactive(iod)
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste('Filtered data-', Sys.time(), '.csv', sep = '')
    },
    content = function(file){
      write.csv(thedata()[input[["mytable1_rows_all"]], ],file)
    }
  )

}

shinyApp(ui = ui, server = server)