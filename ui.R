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
airport <- c("ATL","BOS","BWI","CLT","DEN","DFW","DTW","EWR","IAH","JFK",
             "LAS","LAX","LGA","MCO","MSP","ORD","PHX","SEA","SFO","SLC")
airline <- c("AA", "DL", "UA", "US", "WN")

# UI Code
shinyUI(fluidPage(
      headerPanel("Flight Delay Probability"),
            sidebarPanel(
            selectInput(inputId="depcode", label="Departure Airport Code",
                        choices = airport),
            selectInput(inputId="arrcode", label="Destination Airport Code",
                        choices = airport),
            selectInput(inputId="carrier", label="Two Letter Airline Code",
                        choices = airline),
            sliderInput(inputId="dephour", label="Departure Hour: 0=Midnight to 23=11:00 PM",
                        min=5, value=12, max=23, step=1),
            actionButton("calcButton", "Show Results")
      ),
      mainPanel(
            tabsetPanel(                  
                  tabPanel("Main",
                        dataTableOutput("result"),
                        plotOutput("diff")
                        ),
                  tabPanel("Documentation",
                     p("This application summarizes the historical outcomes 
                       over 1 year for flights between the two airports for the selected 
                       departure hour and carrier. Due to performance 
                       constraints on the shiny server, only a small subset 
                       of airports and carriers are available."),
                     p("1. Select the departure and arrival airport code"),
                     p("2. Select the departure hour on a 24 hour scale (23=11PM)"),
                     p("3. Press Show Results"),
                     p("The table summarizes the outcome for flights matching the criteria."),
                     p("The histogram summarizes how many minutes delayed flights were delayed"),
                     h4("Version History"),
                     p("The original version of this application was the course project submission
                        for the Johns Hopkins Data Products in January, 2015. 
                        This version--2Feb2015--is an update that expands the selections 
                        to include flights between the top 10 airports for the top 5 carriers."),
                     h4("Further Details"),
                     p("Copyright (C) 2015 Timothy Boomer"),
                     p("This program comes with ABSOLUTELY NO WARRANTY.
                        This is free software, and you are welcome to redistribute it
                        under certain conditions;", a(href="https://github.com/tboomer/FlightDelay/blob/master/LICENSE.htm",
                        "Click Here"), "for details.")
                     )
                  )
      )
)
)