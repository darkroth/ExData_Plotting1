library(data.table)
filename <- "household_power_consumption.txt"

library(microbenchmark)
##runtime <- microbenchmark(rawdata <- fread(filename,na.strings="?",stringsAsFactors=FALSE),times=10)
rawdata <- fread(filename,na.strings="?",stringsAsFactors=FALSE, 
                 ## verbose=TRUE,
                 skip="1/2/2007",
                 nrows=2880)
headerLine <- fread(filename,na.strings="?",stringsAsFactors=FALSE, nrows=0)
setnames(rawdata,names(headerLine)) ## Copy header names over
## class(rawdata)

rawdata$Time <- paste(rawdata$Date, rawdata$Time) ## Merge time and date strings, 
## else time objects reflect current date
rawdata$Date <- as.Date(rawdata$Date,format="%d/%m/%Y") ## Convert to Date objects
rawdata$Time <- as.POSIXct(strptime(rawdata$Time,format="%d/%m/%Y %H:%M:%S")) ## Convert to Time objects

## Plot histogram of Global Active Power
hist(rawdata$Global_active_power,
     xlab="Global Active Power (kilowatts)",
     ylab="Frequency",
     main="Global Active Power",
     col="red")

dev.copy(png,filename="plot1.png",width=480,height=480)
dev.off()