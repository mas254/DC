# Lesson 4

# You can create reactive output with a two step process.

# Add an R object to your user interface.
# Tell Shiny how to build the object in the server function.
# The object will be reactive if the code that builds it calls a widget value.

# For example, the ui object below uses textOutput to add a reactive line of text to the main panel of the
# Shiny app pictured above.

ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
               information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", 
                              "Percent Black",
                              "Percent Hispanic", 
                              "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
      ),
    
    mainPanel(
      textOutput("selected_var")
    )
  )
  )

# Notice that textOutput takes an argument, the character string "selected_var".
# Each of the *Output functions require a single argument: a character string that Shiny will use as the name
# of your reactive element. Your users will not see this name, but you will use it later.

# In the server function below, output$selected_var matches textOutput("selected_var") in your ui.

server <- function(input, output) {
  
  output$selected_var <- renderText({ 
    "You have selected this"
  })
  
}

# You do not need to explicitly state in the server function to return output in its last line of code.
# R will automatically update output through reference class semantics.

# Section with possible render functions here

# Shiny will automatically make an object reactive if the object uses an input value.
# For example, the server function below creates a reactive line of text by calling the value of the select box widget to build the text.

server <- function(input, output) {
  output$selected_var <- renderText({ 
    paste("You have selected", input$var)
  })
}

