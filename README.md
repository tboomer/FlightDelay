# FlightDelay Shiny Application
This app summarizes flight delay history for selected city pairs. The application hosted on shiny.io can be found at: https://tboomer.shinyapps.io/FlightDelay/. Key source files include:

- FlightDataPrep.R: a script that processes the downloaded DOT zip files into the dataframe used for exploratory analysis and for the application.
- WeatherDataPrep.R: a script that processes downloaded NOAA weather data and joins it to the flight data.
- AppDataPrep.R: a script that reduces the size of the data file to include only those observations and variables required by the FlightData app.
- ExpAnalysis.R: the script that runs various plots used to identify which factors to use as selection criteria.
- index.html: a summary presentation (This is now out of date.)
- server.R and ui.R: the scripts for the shiny application
