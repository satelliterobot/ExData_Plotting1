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
png(filename="plot2.png")
plot(dat$Date, dat$Global_active_power, type="n", main="", xlab="",
     ylab="Global Active Power (kilowatts)")
lines(dat$Date, dat$Global_active_power)
dev.off()

