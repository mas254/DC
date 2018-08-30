# app

library(shiny)
library(data.table)


# User interface ----
ui <- fluidPage(
  titlePanel("Indicies of Multiple Deprivation Data"),
  sidebarLayout(
    sidebarPanel(
      helpText("Create a csv file containing information
               from the Indicies of Multiple Deprivation Data
               for Devon postcodes."),
      selectInput("vars",
                label = h3("Postcode"),
                choices = c("Postcode", "Not"),
                selected = "Postcode"),
      downloadButton('download', "Download the data"),
      fluidRow(column(7, dataTableOutput('dto')))
    ),
    mainPanel(textOutput("selected_var"))
  )
)

server <- function(input, output){
  datasetInput <- reactive({
    switch(input$Postcode,
           "Postcode" = IofMD$PCD8,
           "Not" = IofMD$`Income Rank`
           )
    }
  )
}

shinyApp(ui = ui, server = server)