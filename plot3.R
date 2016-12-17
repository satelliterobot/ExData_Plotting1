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
png(filename="plot3.png")
# This one is tricky because if the plot sets xlim and ylim automatically from
# Sub_metering_1, xlim is too narrow. But if it sets xlim and ylim from
# Sub_metering_2, ylim will be too short. So use Sub_metering_2 and then set
# ylim manually.
plot(dat$Date, dat$Sub_metering_2, type="n", main="", xlab="",
     ylab="Energy sub metering", ylim=c(0, max(dat$Sub_metering_1)))
lines(dat$Date, dat$Sub_metering_1)
lines(dat$Date, dat$Sub_metering_2, col="red")
lines(dat$Date, dat$Sub_metering_3, col="blue")
legend("topright",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lwd=c(1,1,1), col=c("black","red","blue"))
dev.off()
