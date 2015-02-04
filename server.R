# Flight Delay server.R Code
# FlightDelay ui.R Code
# Copyright (C) 2015 Timothy Boomer
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# Load libraries, scripts, and data
library(shiny)
library(ggplot2)
library(dplyr)
load("smallfltdata.rda")

# Server Code
shinyServer(
      function(input, output) {
            # Validate inputs and return data table
            data <- reactive({
                  validate(
                        need(nrow(filter(small, ORIGIN == input$depcode,
                                    DEST == input$arrcode,
                                    UNIQUE_CARRIER == input$carrier,
                                    DEP_HOUR == input$dephour))>0, 
                             "There is no data for the selected inputs.")
                        )
                  filter(small, ORIGIN == input$depcode,
                        DEST == input$arrcode,
                        UNIQUE_CARRIER == input$carrier,
                        DEP_HOUR == input$dephour)
            })
            # Render results in a data table
            output$result <- renderDataTable({
                  input$calcButton
                  isolate({
                        stats <- group_by(data(), ORIGIN, DEST, UNIQUE_CARRIER, DEP_HOUR, RESULT) %>%
                              summarise(n=n()) %>%
                              mutate(freq = paste(round(100*n / sum(n),1),"%"))
                        stats <- data.frame(stats)
                        names(stats) <- c("Origin", "Destination", "Carrier", "DepartHour", 
                              "Result", "Number of Flights", "Percent")
                        stats[,5:7]
                  })
            })
            # Render histogram of delay length for delayed flights
            output$diff <- renderPlot({
                  input$calcButton
                  isolate({
                  delstats <- filter(data(), RESULT=="delayed") %>%
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

# Scratch code for debugging
# input <- list(depcode = "LGA", arrcode = "DTW", carrier = "DL", dephour = 7) 