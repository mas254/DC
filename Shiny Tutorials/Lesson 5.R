# Lesson 5

counties <- readRDS("census-app/data/counties.rds")
head(counties)


install.packages(c("maps", "mapproj"))

library(maps)
library(mapproj)
source("census-app/helpers.R")
counties <- readRDS("census-app/data/counties.rds")
percent_map(counties$white, "darkgreen", "% White")

# Since you saved helpers.R in the same directory as server.R, you can ask Shiny to load it with

source("helpers.R")

# Since you saved counties.rds in a sub-directory (named data) of the directory that server.R is in, you can load it with.

counties <- readRDS("data/counties.rds")

# You can load the maps and mapproj packages in the normal way with

library(maps)
library(mapproj)

# which does not require a file path.

# Only place code that Shiny must rerun to build an object inside of a render* function.
# Shiny will rerun all of the code in a render* chunk each time a user changes a widget mentioned in the chunk.
# This can be quite often.

# You should generally avoid placing code inside a render function that does not need to be there.
# Doing so will slow down the entire app.

source("helpers.R")
counties <- readRDS("data/counties.rds")
library(maps)
library(mapproj)

# User interface ----
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
               information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
      ),
    
    mainPanel(plotOutput("map"))
  )
  )

# Server logic ----
server <- function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    percent_map(var = data, color = blue, legend.title = red, max = 100, min = 10)
  })
}

# Run app ----
shinyApp(ui, server)