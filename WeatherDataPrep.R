# This script opens downloaded NOAA files and builds the database for
# the FlightDelay application. Data was downloaded by month in the specified
# directory from the DOT website.
# Working Directory: The working directory needs to be the folder with 
# the downloaded data files. Files are downloaded from:
# http://cdo.ncdc.noaa.gov/qclcd_ascii/

library(dplyr)
library(stringr)

# Read and append files from December, 2013 through November, 2014
# Data files are downloaded by month at the DOT website. The suffix
# -YYYYMM is appended to the file name for the script to process the files.

# Read first file
monthdat <- read.csv(unzip("QCLCD201401.zip", files="201401daily.txt"), header=TRUE,
                     stringsAsFactors = FALSE)
wdata <- monthdat
print("Month Number Completed")
# Read and append data from subsequent files
for(i in 2:12) {
      per <- as.integer(201400 + i)
      zipfilename <- paste("QCLCD", per, ".zip", sep = "")
      filename <- paste(per, "daily.txt", sep="")
      monthdat <- read.csv(unzip(zipfilename, files = filename), header = TRUE,
                           stringsAsFactors = FALSE)
      wdata <- rbind(wdata, monthdat)
      print(i)
}

# Convert variable types
wdata$YearMonthDay <- as.Date(as.character(wdata$YearMonthDay), "%Y%m%d")
numcol <- c(3,5,7,29,31,41,43,47)
for (i in numcol) {
      wdata[,i] <- as.numeric(wdata[,i])
}


# Read station data file to create WBAN to CallSign lookup
station <- read.table(unzip("QCLCD201411.zip", files="201411station.txt"), 
                      header=TRUE, sep="|", quote="", comment.char="")
station.lookup <- station[,c(1,3)]

# Join CallSign to wdata
wdata <- left_join(wdata, station.lookup, by="WBAN")
wdata$CallSign <- as.factor(wdata$CallSign)
save(wdata, file="fullweatherdata.RData")

# Subset weather data for airport stations
load("fullweatherdata.RData")
load("flightdata.rda")  # Load flight data
airports <- unique(data$ORIGIN) # Create factor vector of airports
sub_wdata <- filter(wdata, CallSign %in% airports) # Select only stations at airports
fields <- c(2, 23, 29, 31, 41, 43, 51)
sub_wdata <- select(sub_wdata, fields)

# Join weather data for departure and arrival airports to flight statistics
m_wdata <- sub_wdata
names(m_wdata) <- paste("dep_", names(sub_wdata), sep="")
data <- left_join(data, m_wdata, by = c("FL_DATE"="dep_YearMonthDay", "ORIGIN"="dep_CallSign"))
names(m_wdata) <- paste("arr_", names(sub_wdata), sep="")
data <- left_join(data, m_wdata, by = c("FL_DATE"="arr_YearMonthDay", "DEST"="arr_CallSign"))
rm(m_wdata)

save(data, file ="fw_data")

# Create logical variables for weather conditions
memory.limit(size=4000)
data <- mutate(data, arr_tstorm = str_detect(arr_CodeSum, "TS"))
data <- mutate(data, arr_fog = str_detect(arr_CodeSum, "FG"))
data <- mutate(data, arr_rain = str_detect(arr_CodeSum, ("RA|SH")))
data <- mutate(data, arr_snow = str_detect(arr_CodeSum, ("SN|SG|PL|IC")))
data <- mutate(data, dep_tstorm = str_detect(dep_CodeSum, "TS"))
data <- mutate(data, dep_fog = str_detect(dep_CodeSum, "FG"))
data <- mutate(data, dep_rain = str_detect(dep_CodeSum, ("RA|SH")))
data <- mutate(data, dep_snow = str_detect(dep_CodeSum, ("SN|SG|PL|IC")))

# Create ONTIME Variable for Logit Model
data <- mutate(data, ONTIME = (RESULT=="ontime"))

save(data, file ="fw_data")
