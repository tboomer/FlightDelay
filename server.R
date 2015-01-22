# server.R Code
# Load libraries, scripts, and data
library(shiny)
library(ggplot2)
library(dplyr)
load("smallfltdata.rda")
# sumdata <- group_by(small, ORIGIN, DEST, UNIQUE_CARRIER, DEP_HOUR, RESULT)

shinyServer(
      function(input, output) {
            output$depcode <- renderText({input$depcode})
            output$arrcode <- renderText({input$arrcode})
            output$carrier <- renderText({input$carrier})
            output$dephour <- renderText({input$dephour})
            output$result <- renderTable({
            input$calcButton
            isolate({
            stats <- filter(small, ORIGIN == input$depcode,
                            DEST == input$arrcode,
                            UNIQUE_CARRIER == input$carrier,
                            DEP_HOUR == input$dephour) %>%
                  group_by(ORIGIN, DEST, UNIQUE_CARRIER, DEP_HOUR, RESULT) %>%
                  summarise(n=n()) %>%
                  mutate(freq = n / sum(n))
            data.frame(stats)
            })
            })
            
     
            }
)