# This script opens downloaded DOT files and builds the database for
# the FlightDelay application. Data was downloaded by month in the specified
# directory from the DOT website.
# Working Directory: The working directory needs to be the folder with 
# the downloaded data files.

library(dplyr)

# Read and append files from December, 2013 through November, 2014
# Data files are downloaded by month at the DOT website. The suffix
# -YYYYMM is appended to the file name for the script to process the files.

# Read first file
monthdat <- read.csv(unzip("1040658657_T_ONTIME-201312.zip"), header=TRUE)
data <- monthdat

# Read and append data from subsequent files
for(i in 1:11) {
      per <- as.integer(201400 + i)
      filename <- paste("1040658657_T_ONTIME-",per, ".zip", sep = "")
      monthdat <- read.csv(unzip(filename), header=TRUE)
      data <- rbind(data, monthdat)
}
# Convert variable types
data$FL_DATE <- as.Date(data$FL_DATE, "%Y-%m-%d")
data$DIVERTED <- as.logical(data$DIVERTED)
data$CANCELLED <- as.logical(data$CANCELLED)

data$DELAYED <- data$ARR_DELAY > 0 # Create logical variable for delayed

# Create RESULT factor variable.
RESULT <- rep("ontime", nrow(data))
for(i in 1:nrow(data)) if(!is.na(data$CANCELLED[i]) & (data$CANCELLED[i]==TRUE)) RESULT[i] = "cancelled"
for(i in 1:nrow(data)) if(!is.na(data$DIVERTED[i]) & (data$DIVERTED[i]==TRUE)) RESULT[i] = "diverted"
for(i in 1:nrow(data)) if(!is.na(data$DELAYED[i]) & (data$DELAYED[i]==TRUE)) RESULT[i] = "delayed"
RESULT <- as.factor(RESULT)
data <- cbind(data, RESULT)
data$DEP_HOUR <- as.factor(data$CRS_DEP_TIME %/% 100) # Convert departure hour to factor
data$ARR_HOUR <- as.factor(data$CRS_ARR_TIME %/% 100) # Convert arrival hour to factor

# Save (full) data file
save(data, file = "flightdata.rda")

# Subset data to a smaller file required by application.
small <- data[,-c(3, 9, 10:17, 19:30)] # Eliminate columns not required by app
airport <- c("ATL","BOS","BWI","CLT","DEN","DFW","DTW","EWR","IAH","JFK",
             "LAS","LAX","LGA","MCO","MSP","ORD","PHX","SEA","SFO","SLC")
airline <- c("AA", "DL", "UA", "US", "WN")
small <- filter(small, UNIQUE_CARRIER %in% airline, ORIGIN %in% airport, DEST %in% airport)

# Adjust result so arrival delay > 12 hours are "cancelled"
for(i in 1:nrow(small)) if(!is.na(small$ARR_DELAY[i]) & small$ARR_DELAY[i] >= 12*60)
      small$RESULT[i] = "cancelled"

save(small, file="smallfltdata.rda") # Save small for use by the application
