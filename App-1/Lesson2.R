# Lesson 2


ui <- fluidPage(
  titlePanel("LSOA Data"),
  sidebarLayout(
    sidebarPanel("Choose data:"),
    mainPanel(
      h3("Download file:")
      )
  )
)


server <- function(input, output) {}


shinyApp(ui = ui, server = server)

# Now lesson 3 - here also featured text formatting and images in shiny applications - could do CAN here, make look professional