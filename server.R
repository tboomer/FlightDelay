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
library(scales)
library(dplyr)
load("smallfltdata.rda")

airport <- matrix(c("ATL","BOS","BWI","CLT","DEN","DFW","DTW","EWR","IAH","JFK",
                    "LAS","LAX","LGA","MCO","MSP","ORD","PHX","SEA","SFO","SLC", 
                    "Atlanta", "Boston", "Baltimore/Washington Intl.", "Charlotte",
                    "Denver", "Dallas/Fort Worth", "Detroit", "Newark Intl.","Houston",
                    "NY-JFK", "Las Vegas", "Los Angeles", "NY-LaGuardia", "Orlando",
                    "Minneapolis/St. Paul", "Chicago-OHare", "Phoenix", "Seattle",
                    "San Francisco", "Salt Lake City"), 20,2, byrow=FALSE)
airline <- matrix(c("AA", "DL", "UA", "US", "WN", "American Airlines", "Delta",
                    "United Airlines", "USAir", "Southwest Airlines"), 5,2, byrow=FALSE)

# Server Code
shinyServer(
      function(input, output) {
            output$deptxt <- renderText({airport[which(airport[,1]==input$depcode),2]})
            output$arrtxt <- renderText({airport[which(airport[,1]==input$arrcode),2]})
            output$carrtxt <- renderText({airline[which(airline[,1]==input$carrier),2]})
            # Validate inputs and return data table
            day.data <- reactive({
                  validate(
                       need(nrow(filter(small, ORIGIN == input$depcode,
                                        DepWeatherCode == input$depweather,
                                        DEST == input$arrcode,
                                        ArrWeatherCode == input$arrweather,
                                          UNIQUE_CARRIER == input$carrier))>0, 
                             "There is no data for the selected route and carrier."
                        )
                  )
                  filter(small, ORIGIN == input$depcode,
                         DepWeatherCode == input$depweather,
                         DEST == input$arrcode,
                         ArrWeatherCode == input$arrweather,
                         UNIQUE_CARRIER == input$carrier
                  )
            })

            # Output graph of results by hour
            output$result <- renderPlot({
                  input$calcButton
                  isolate({
                        stats <- group_by(day.data(), ORIGIN, DEST, UNIQUE_CARRIER, DEP_HOUR, RESULT) %>%
                              summarise(n=n()) %>%
                              mutate(freq = paste(round(100*n / sum(n),1),"%"))
                        stats <- data.frame(stats)
                        names(stats) <- c("Origin", "Destination", "Carrier", "DepartHour", 
                              "Result", "NumberofFlights", "Percent")

                  ggplot(stats, aes(color, x=DepartHour, y=NumberofFlights, fill=Result)) +
                        geom_bar(stat="identity", position = "fill") +
                        scale_fill_manual(values=c("#66CC66", "#996633", "#006699", "#CC0000")) +
                        scale_y_continuous(labels = percent_format()) +
                        labs(title="Flight Results by Hour") +
                        ylab("Percent of Flights") + xlab("Departure Hour")
                        })
                  })
            # Render histogram of delay length for delayed flights
            output$diff <- renderPlot({
                  input$calcButton
                  isolate({
                  delstats <- filter(day.data(), RESULT=="delayed") %>%
                        group_by(ORIGIN, DEST, UNIQUE_CARRIER, DEP_HOUR, ARR_DELAY) %>%
                        summarise(n=n()) %>%
                        mutate(freq = n / sum(n))
                  
                  ggplot(delstats, aes(ARR_DELAY)) + geom_histogram(binwidth = 15) +
                        scale_x_continuous(breaks = round(seq(0, max(delstats$ARR_DELAY, 
                                                                     na.rm=TRUE), by = 60),1)) +
                        ggtitle("Delayed Flights Only: Delay in Minutes") +
                        xlab("Delay (Minutes)") + 
                        ylab("Number of Flights")
                  })
            })
      }
)

