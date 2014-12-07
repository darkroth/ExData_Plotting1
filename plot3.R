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

## Plot sub_meteringX over time
png(file="plot3.png",width=480,height=480)
linecolors=c("black","red","blue")
plot(rawdata$Time,rawdata$Sub_metering_1,
     type="l",
     xlab="datetime",
     ylab="Energy sub metering",
     col=linecolors[[1]])
lines(rawdata$Time,rawdata$Sub_metering_2,
      col=linecolors[[2]])
lines(rawdata$Time,rawdata$Sub_metering_3,
      col=linecolors[[3]])
linelabels=c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
legend(x="topright",
       legend=linelabels,
       lwd=c(1,1,1),
       col=linecolors)
dev.off()