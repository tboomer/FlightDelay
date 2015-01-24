# ui.R Code
shinyUI(pageWithSidebar(
      headerPanel("Flight Delay Probability"),
      sidebarPanel(
            textInput(inputId="depcode", label="Departure Airport Code"),
            textInput(inputId="arrcode", label="Destination Airport Code"),
            selectInput(inputId="carrier", label="Two Letter Airline Code",
                        choices = c("9E","AA","AS","B6","DL","EV", 
                                    "UA","OO","US","VX","WN","YV","F9", 
                                    "FL","HA","MQ")),
            sliderInput(inputId="dephour", label="Departure Hour: 0=Midnight to 23=11:00 PM",
                        min=0, value=12, max=23, step=1),
            actionButton("calcButton", "Show Results")
      ),
      mainPanel(
            p("Departure Airport"),
            textOutput("depcode"),
            p("Arrival Airport"),
            textOutput("arrcode"),
            p("Airline"),
            textOutput("carrier"),
            p("Departure Hour"),
            textOutput("dephour"),
            dataTableOutput("result"),
            plotOutput("diff")
            )
      )
)