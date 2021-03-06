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

# Define scope of airports and carriers.
airport <- matrix(c("ATL","BOS","BWI","CLT","DEN","DFW","DTW","EWR","IAH","JFK",
             "LAS","LAX","LGA","MCO","MSP","ORD","PHX","SEA","SFO","SLC", 
             "Atlanta", "Boston", "Baltimore/Washington Intl.", "Charlotte",
             "Denver", "Dallas/Fort Worth", "Detroit", "Newark Intl.","Houston",
             "NY-JFK", "Las Vegas", "Los Angeles", "NY-LaGuardia", "Orlando",
             "Minneapolis/St. Paul", "Chicago-OHare", "Phoenix", "Seattle",
             "San Francisco", "Salt Lake City"), 20,2, byrow=FALSE)
airline <- matrix(c("AA", "DL", "UA", "US", "WN", "American Airlines", "Delta",
                    "United Airlines", "USAir", "Southwest Airlines"), 5,2, byrow=FALSE)

# UI Code
shinyUI(fluidPage(
      headerPanel("Flight Delay History"),
            sidebarPanel(
            selectInput(inputId="depcode", label="Departure Airport Code",
                        choices = airport[,1]),
            selectInput(inputId="depweather", label="Departure Weather",
                        choices = c("Other", "Thunderstorm", "Snow")),
            selectInput(inputId="arrcode", label="Destination Airport Code",
                        choices = airport[,1]),
            selectInput(inputId="arrweather", label="Arrival Weather",
                        choices = c("Other", "Thunderstorm", "Snow")),
            selectInput(inputId="carrier", label="Two Letter Airline Code",
                        choices = airline[,1]),
            actionButton("calcButton", "Show Results")
      ),
      mainPanel(
            tabsetPanel(                  
                  tabPanel("Main",
                        h3("Input Values"),
                        p("Departure Airport: ", textOutput("deptxt", inline=TRUE)),
                        p("Arrival Airport: ", textOutput("arrtxt", inline=TRUE)),
                        p("Airline: ", textOutput("carrtxt", inline=TRUE)),
                        h3("Flight Results-One Year History"),
                        plotOutput("result"),
                        plotOutput("diff"),
                        p("Note: Includes only flights delayed more than 10 minutes.")
                        ),
                  tabPanel("Documentation",
                     p("This application summarizes US commercial flight statistics for Jan through
                        Dec, 2014. To use the application:"),
                     p("1. Select the departure and arrival airport codes and airline."),
                     p("2. Select whether there are thunderstorms or snow at either airport."),
                     p("3. Press Show Results"),
                     p("The top chart summarizes flight outcomes for the selected route and carrier
                       by hour."),
                     p("The histogram looks at flights that arrived more than 10 minutes late and displays
                       the distribution of the arrival delay."),
                     h4("Version History"),
                     p("The original version of this application was the course project submission
                        for the Johns Hopkins Data Products in January, 2015. 
                        This version--6Mar2015--adds the filter for weather conditions."), 
                     h4("Further Details"),
                     p("Copyright (C) 2015 Timothy Boomer"),
                     p("This program comes with ABSOLUTELY NO WARRANTY.
                        This is free software, and you are welcome to redistribute it
                        under certain conditions;", a(href="https://github.com/tboomer/FlightDelay/blob/master/LICENSE.htm",
                        "Click Here"), "for details."),
                     p("Source Data: US Dept. of Transportation Airline On-Time Statistics and 
                       NOAA National Climactic Data Center")
                     )
                  )
      )
)
)