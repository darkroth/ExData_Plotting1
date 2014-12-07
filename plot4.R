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

png(file="plot4.png",width=480,height=480)
par(mfrow=c(2,2))
with(rawdata, {
     ## Plot Global Active Power at [1,1]
     plot(rawdata$Time,rawdata$Global_active_power,
       xlab="",
       ylab="Global Active Power (kilowatts)",
       type="l")

     ## Plot voltage over time at [1,2]
     plot(rawdata$Time,rawdata$Voltage,
          type="l",
          xlab="datetime",
          ylab="Voltage")
     
     ## Plot sub_meteringX over time at [2,1]
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
            col=linecolors,
            bty="n")
     
     ## Plot Global Reactive Power over time at [2,2]
     plot(rawdata$Time,rawdata$Global_reactive_power,
          type="l",
          xlab="datetime",
          ylab="Global_reactive_power")
})

dev.off()

## Reset multiplot grid
par(mfrow=c(1,1))