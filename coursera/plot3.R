
#Before starting script, setting up working directory and libraries

setwd("c:\\users\\jh126\\")
library(plyr)
library(dplyr)
library(lubridate)
library(tidyr)

# Get the file and unzip it
zipfile<- "test_zip.zip"
if (!file.exists(zipfile)){
  fileURL <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
  download.file(fileURL, zipfile)
}  
if (!file.exists("household_power_consumption.txt")) { 
  unzip(zipfile) 
}


#Read table
x <- read.table("household_power_consumption.txt",sep=";", header=TRUE)

##Create Datetime variable
x$Datetime <- paste(x$Date,x$Time)
x$Datetime <- dmy_hms(x$Datetime, tz="America/New_York")

##Filter to observations between 2007-02-01 and 2007-02-02
x1 <- filter(x, Datetime >= "2007-02-01 00:00:00" & Datetime <= "2007-02-02 23:59:59")

## Transform variables to numeric
x1$Global_active_power <- as.numeric(as.character(x1$Global_active_power))
x1$Global_reactive_power <- as.numeric(as.character(x1$Global_reactive_power))
x1$Voltage <- as.numeric(as.character(x1$Voltage))
x1$Global_intensity <- as.numeric(as.character(x1$Global_intensity))
x1$Sub_metering_1 <- as.numeric(as.character(x1$Sub_metering_1))
x1$Sub_metering_2 <- as.numeric(as.character(x1$Sub_metering_2))

## Setup Graph Parameters
par(mfcol = c(1,1))


## Code to get the chart
x1_test<- select(x1, Datetime, Sub_metering_1,Sub_metering_2,Sub_metering_3)
x1_test_1 <- gather(x1_test, key = "Metering", value = measurement, Sub_metering_1, Sub_metering_2, Sub_metering_3)
with(x1_test_1, plot(Datetime,measurement, xlab= "", ylab="Energy sub metering", type="n"))
with(subset(x1_test_1,Metering == "Sub_metering_1"), lines(Datetime,measurement, col="black"))
with(subset(x1_test_1,Metering == "Sub_metering_2"), lines(Datetime,measurement, col="red"))
with(subset(x1_test_1,Metering == "Sub_metering_3"), lines(Datetime,measurement, col="blue"))
legend("topright", pch="-", col = c("blue","red","green"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))


## Copy to PNG File
dev.copy(png, file = "plot3.png")
dev.off()

