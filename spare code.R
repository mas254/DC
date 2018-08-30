textInput("text",
          label = h3("Postcode"),
          value = "Enter postcode"),
downloadButton('download', "Download the data"),
fluidRow(column(7, dataTableOutput('dto')))





thedata <- reactive(IofMDFull.csv)
output$value <- renderPrint({ input$text })
output$download <- downloadHandler(
  filename = function(){"thename.csv"}, 
  content = function(fname){
    write.csv(thedata(), fname)