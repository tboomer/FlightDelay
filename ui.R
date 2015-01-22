# ui.R Code
shinyUI(pageWithSidebar(
      headerPanel("Flight Delay Probability"),
      sidebarPanel(
            textInput(inputId="depcode", label="Departure Airport Code"),
            textInput(inputId="arrcode", label="Destination Airport Code"),
            textInput(inputId="carrier", label="Two Letter Airline Code"),
            sliderInput(inputId="dephour", label="Departure Hour: 0=Midnight to 23=11:00 PM",
                        min=0, value=0, max=23, step=1),
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
            tableOutput("result")
            )
      )
)