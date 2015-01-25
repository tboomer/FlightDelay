# server.R Code
# Load libraries, scripts, and data
library(shiny)
library(ggplot2)
library(dplyr)
load("smallfltdata.rda")

# Scratch code
# sumdata <- group_by(small, ORIGIN, DEST, UNIQUE_CARRIER, DEP_HOUR, RESULT)
# input <- list(depcode = "LGA", arrcode = "DTW", carrier = "DL", dephour = 7)

# Create vectors to validate input
orgcodes <- unique(small$ORIGIN)
descodes <- unique(small$DEST)
small <- filter(small, ORIGIN %in% c("LGA", "DTW"), DEST %in% c("LGA", "DTW"))

shinyServer(
      function(input, output) {
            output$depcode <- renderText({input$depcode})
            output$arrcode <- renderText({input$arrcode})
            output$carrier <- renderText({input$carrier})
            output$dephour <- renderText({input$dephour})
            
            output$result <- renderDataTable({
                  input$calcButton
                  isolate({
                        stats <- filter(small, ORIGIN == input$depcode,
                                        DEST == input$arrcode,
                                        UNIQUE_CARRIER == input$carrier,
                                        DEP_HOUR == input$dephour) %>%
                              group_by(ORIGIN, DEST, UNIQUE_CARRIER, DEP_HOUR, RESULT) %>%
                              summarise(n=n()) %>%
                              mutate(freq = paste(round(100*n / sum(n),1),"%"))
                        stats <- data.frame(stats)
                        names(stats) <- c("Origin", "Destination", "Carrier", "DepartHour", 
                              "Result", "Number of Flights", "Percent")
                        stats[,5:7]
                  })
            })
            output$diff <- renderPlot({
                  if(input$calcButton == 0)
                        return()
                  delstats <- filter(small, ORIGIN == input$depcode,
                                     DEST == input$arrcode,
                                     UNIQUE_CARRIER == input$carrier,
                                     DEP_HOUR == input$dephour, 
                                     RESULT=="delayed") %>%
                        group_by(ORIGIN, DEST, UNIQUE_CARRIER, DEP_HOUR, ARR_DELAY) %>%
                        summarise(n=n()) %>%
                        mutate(freq = n / sum(n))
                  
                  qplot(ARR_DELAY, data=filter(delstats), 
                        geom="histogram", binwidth = 15, xlab = "Delay (Minutes)",
                        ylab = "Number of Delayed Flights", 
                        main="Delayed Flights: 1-Year History")
            })
      }
)