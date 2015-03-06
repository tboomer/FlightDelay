# This script takes the dataframe of merged flight and weather data and
# reduces obersvations and variables to those required by the FlightData app.

library(dplyr)
load("fw_data.rda") # Load the dataframe of flight and weather data. Must be in same working directory

# Create factor variables for arrival and destination weather
DepWeatherCode <- rep("Other", nrow(data))
ArrWeatherCode <- DepWeatherCode
DepWeatherCode[data$dep_tstorm] <- "Thunderstorm"
DepWeatherCode[data$dep_snow] <- "Snow"
ArrWeatherCode[data$arr_tstorm] <- "Thunderstorm"
ArrWeatherCode[data$arr_snow] <- "Snow"

data$DepWeatherCode <- DepWeatherCode
data$ArrWeatherCode <- ArrWeatherCode
cbind(data, DepWeatherCode, ArrWeatherCode)

# Subset data to a smaller file required by application.
small <- data[,-c(1:3, 9, 10:17, 19:30, 34:52)] # Eliminate columns not required by app
rm(data)
airport <- c("ATL","BOS","BWI","CLT","DEN","DFW","DTW","EWR","IAH","JFK",
             "LAS","LAX","LGA","MCO","MSP","ORD","PHX","SEA","SFO","SLC")
airline <- c("AA", "DL", "UA", "US", "WN")
small <- filter(small, UNIQUE_CARRIER %in% airline, ORIGIN %in% airport, DEST %in% airport)

# Adjust result so arrival delay > 12 hours are "cancelled"
for(i in 1:nrow(small)) if(!is.na(small$ARR_DELAY[i]) & small$ARR_DELAY[i] >= 12*60)
      small$RESULT[i] = "cancelled"
small$RESULT <- factor(small$RESULT, levels(small$RESULT)[c(4,2,3,1)]) #Reorder for plotting

save(small, file="smallfltdata.rda") # Save small for use by the application
