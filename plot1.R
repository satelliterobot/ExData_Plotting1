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
# Convert date variable from character to date
dat$Date <- strptime(dat$Date, format="%d/%m/%Y")
# Watch out: "year" starts at 0 for 1900 and "mon" starts at 0 for January
dat <- subset(dat, (dat$Date$year + 1900 == 2007) &
                   (dat$Date$mon + 1 == 2) &
                   (dat$Date$mday == 1 | dat$Date$mday == 2))

# Make the plot
png(filename="plot1.png")
hist(dat$Global_active_power, main="Global Active Power", col="red",
     xlab="Global Active Power (kilowatts)")
dev.off()
