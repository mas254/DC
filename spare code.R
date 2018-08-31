textInput("text",
          label = h3("Postcode"),
          value = "Enter postcode",
downloadButton('download', "Download the data"),
fluidRow(column(7, dataTableOutput('dto')))
)





thedata <- reactive(IofMDFull.csv)
output$value <- renderPrint({ input$text })
output$download <- downloadHandler
  filename = function(){"thename.csv"}
  content = function(fname){
    write.csv(thedata(), fname)
}

md <- fread("dc-app/data/IofMDFull.csv")
MD <- subset(md[,-1])
saveRDS(MD, "dc-app/data/imd.rds")

library(data.table)
cen <- fread("data/CensusFull.csv")
census <- subset(cen[,-1])
saveRDS(census, "data/cen.rds")
getwd()

cens = cen[sample(nrow(cen), 1000), ]
output$mytable2 <- DT::renderDataTable({
  DT::datatable(cen[, input$show_vars, drop = FALSE])
})


num <- read.csv('Completed Files/CensusFull.csv')
cen <- subset(num)[-1]