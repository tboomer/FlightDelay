# server.R Code
# Load libraries, scripts, and data
library(shiny)
library(ggplot2)
library(dplyr)
load("smallfltdata.rda")

# Scratch code
# sumdata <- group_by(small, ORIGIN, DEST, UNIQUE_CARRIER, DEP_HOUR, RESULT)
# input <- list(depcode = "LGA", arrcode = "DTW", carrier = "DL", dephour = 7) #for debugging

# Create vectors to validate input
# orgcodes <- unique(small$ORIGIN)
# descodes <- unique(small$DEST)
airport <- c("ATL","BOS","BWI","CLT","DEN","DFW","DTW","EWR","IAH","JFK",
             "LAS","LAX","LGA","MCO","MSP","ORD","PHX","SEA","SFO","SLC")

shinyServer(
      function(input, output) {
            data <- reactive({
                  validate(
                        need(input$depcode != input$arrcode, 
                             "Select Departure and Arrival airport codes.")
                        )
                  filter(small, ORIGIN %in% airport, DEST %in% airport)
            })
            output$result <- renderDataTable({
                  input$calcButton
                  isolate({
                        stats <- filter(data(), ORIGIN == input$depcode,
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
                  input$calcButton
                  isolate({
                  delstats <- filter(data(), ORIGIN == input$depcode,
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
            })
      }
)