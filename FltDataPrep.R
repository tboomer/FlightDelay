# This script opens downloaded DOT files and builds the database for
# the FlightDelay application. Data was downloaded by month in the specified
# directory from the DOT website.
# Working Directory: The working directory needs to be the folder with 
# the downloaded data files.

library(dplyr)

# Read and append files from December, 2013 through November, 2014
# Data files are downloaded by month at the DOT website. The suffix
# -YYYYMM is appended to the file name for the script to process the files.
# Files are downloaded from: 
# http://www.transtats.bts.gov/DL_SelectFields.asp?Table_ID=236&DB_Short_Name=On-Time
# Select the same data fields as flightdata.rda

# Read first file
monthdat <- read.csv(unzip("T_ONTIME-201401.zip"), header=TRUE)
data <- monthdat
print(length(monthdat))

# Read and append data from subsequent files
print("month columns")
for(i in 2:12) {
      per <- as.integer(201400 + i)
      filename <- paste("T_ONTIME-",per, ".zip", sep = "")
      monthdat <- read.csv(unzip(filename), header=TRUE)
      print(c(i, length(monthdat)))
      data <- rbind(data, monthdat)
}
# Convert variable types
data$FL_DATE <- as.Date(data$FL_DATE, "%Y-%m-%d")
data$DIVERTED <- as.logical(data$DIVERTED)
data$CANCELLED <- as.logical(data$CANCELLED)

data$DELAYED <- data$ARR_DELAY > 10 # Create logical variable for delayed

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
