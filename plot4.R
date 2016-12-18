# Get the data set if we don't already have it
dataName <- "household_power_consumption.txt"
zipName <- sub(".txt", ".zip", dataName)
if (!file.exists(dataName)) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                  destfile=zipName, method="curl")
    unzip(zipName)
}

dat <- read.table(dataName, header=TRUE, sep=";", na.strings="?",
                  colClasses=c("character", "character", "numeric", "numeric",
                               "numeric", "numeric", "numeric", "numeric",
                               "numeric"))
# Change Date variable so that it contains both date and time
dat$Date <- strptime(paste(dat$Date, dat$Time), "%d/%m/%Y %H:%M:%S")
# Watch out: "year" starts at 0 for 1900 and "mon" starts at 0 for January
dat <- subset(dat, (dat$Date$year + 1900 == 2007) &
                   (dat$Date$mon + 1 == 2) &
                   (dat$Date$mday == 1 | dat$Date$mday == 2))

# Make the plot
png(filename="plot4.png")
# 2x2, in order of going down the columns
par(mfcol=c(2,2))
# The top left plot, same as plot2.R except for the y label
plot(dat$Date, dat$Global_active_power, type="n", main="", xlab="",
     ylab="Global Active Power")
lines(dat$Date, dat$Global_active_power)

# The bottom left plot, same as plot3.R except no border around the legend
plot(dat$Date, dat$Sub_metering_2, type="n", main="", xlab="",
     ylab="Energy sub metering", ylim=c(0, max(dat$Sub_metering_1)))
lines(dat$Date, dat$Sub_metering_1)
lines(dat$Date, dat$Sub_metering_2, col="red")
lines(dat$Date, dat$Sub_metering_3, col="blue")
legend("topright",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lwd=c(1,1,1), col=c("black","red","blue"), bty="n")

# The top right plot, this is new
plot(dat$Date, dat$Voltage, type="n", main="", xlab="datetime", ylab="Voltage")
lines(dat$Date, dat$Voltage)

# The bottom right plot, also new
plot(dat$Date, dat$Global_reactive_power, type="n", main="", xlab="datetime",
     ylab="Global_reactive_power")
lines(dat$Date, dat$Global_reactive_power)

# Done all the plots
dev.off()
