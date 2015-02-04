# This script is a scratch file that creates summary plots of the flight data which were 
# used to select factors for the FlightDelay application.
# The working directory must contain the flightdata.rda file created by Data.Prep.R.

library(ggplot2)
library(dplyr)
library(gridExtra)

load("flightdata.rda")

# Monthly Result
bymonth <- group_by(data, MONTH, RESULT)
resmonth <- summarise(bymonth, n=n()) %>%
      mutate(freq = n / sum(n))
plot1 <- qplot(MONTH, freq, color=RESULT, data=resmonth,  legend.position="none")
# There appears to be seasonality but not a strong secular trend

# Day of Week Result
bydow <- group_by(data, DAY_OF_WEEK, RESULT)
resdow <- summarise(bydow, n=n()) %>%
      mutate(freq = n / sum(n))
plot2 <- qplot(DAY_OF_WEEK, freq, color=RESULT, data=resdow)
# There is some variation. Maybe consider for subsequent version.

# Hour Result
bydephour <- group_by(data, DEP_HOUR, RESULT)
resdephour <- summarise(bydephour, n=n()) %>%
      mutate(freqdep = n / sum(n))
byarrhour <- group_by(data, ARR_HOUR, RESULT)
resarrhour <- summarise(byarrhour, n=n()) %>%
      mutate(freqarr = n / sum(n))
hour <- as.factor(0:11)
# qplot(ARR_HOUR, freqarr, data=resarrhour, color=RESULT)
plot3 <- qplot(DEP_HOUR, freqdep, data=resdephour, color=RESULT, legend.position="none")

# Airline Result
bycarrier <- group_by(data, UNIQUE_CARRIER, RESULT)
rescarrier <- summarise(bycarrier, n=n()) %>%
      mutate(freq = n / sum(n))
plot4 <- qplot(UNIQUE_CARRIER, freq, data=rescarrier, color=RESULT)

grid.arrange(plot1, plot3, plot4, ncol=3)

# Histogram
# qplot(ARR_DELAY, data=filter(data, (RESULT=="delayed" | RESULT=="ontime") & ARR_DELAY<720), 
#      geom="histogram", binwidth = 15)
