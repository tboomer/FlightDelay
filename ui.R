# ui.R Code
airport <- c("ATL","BOS","BWI","CLT","DEN","DFW","DTW","EWR","IAH","JFK",
             "LAS","LAX","LGA","MCO","MSP","ORD","PHX","SEA","SFO","SLC")
airline <- c("AA", "DL")

shinyUI(fluidPage(
      headerPanel("Flight Delay Probability"),
            sidebarPanel(
            selectInput(inputId="depcode", label="Departure Airport Code",
                        choices = airport),
            selectInput(inputId="arrcode", label="Destination Airport Code",
                        choices = airport),
            selectInput(inputId="carrier", label="Two Letter Airline Code",
                        choices = c("DL","AA")),
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
                     h4("Errors"),
                     em("Error: argument env is missing, with no default"),
                     p("This error message indicates there are no flights for 
                        the selected combination of inputs. 
                        Change the parameters and try again."),
                     h4("Suggestion"),
                     p("Delta (DL) has roughly hourly flights between LGA and DTW
                       for most of the day.")
                     )
                  )
      )
)
)