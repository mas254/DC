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
      helpText("Create a csv file containing information
               from the Indicies of Multiple Deprivation Data
               for Devon postcodes."),
      fluidRow(column(7, dataTableOutput('dto')))
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
  
}

shinyApp(ui = ui, server = server)