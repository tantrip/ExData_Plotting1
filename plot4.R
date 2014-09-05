# We are using data.table instead of data frame for speed
library('data.table')

# Note: Please change the folder and file names at all locations below if you are running this code locally
# The main code to generate plot is only at the end - All the other code is common for all 4 plot files
# Duplicated in every file as per instructions instead of making it a shared function

setwd("c:/dev/data/coursera/ExData_Plotting1") # Set the working directory to where we have the data file

# Note: For unix you can use grep instead of findstr. I am using findstr as I am on windows.
# This command may infact be slower for this small dataset compared to just using fread on the entire file
# But I wanted to try this to help in the future when the datasets I read may be much much larger
# This has more predictable performance for reading slices of rows from very large files

# Get only the records we need from the file - For dates 1/2/2007 and 2/2/2007
# We are setting the full name of file in the command to ensure no conflicts
dt <- fread('findstr /b /i "1/2/2007 2/2/2007" c:\\dev\\data\\coursera\\ExData_Plotting1\\household_power_consumption.txt')

# Now we read the first row of the file to get the column names as we subsetted the file and dont have the column labels
dtnames <- readLines('household_power_consumption.txt', n=1)

# Let us split the string we read above to get the names
dtnames <- strsplit(dtnames, ";")

# We need to unlist as strsplit gives a list of strings and we need a character vector
setnames(dt, unlist(dtnames))

# Let us set the date column as date type in the data table and its format
dt$Date<-as.Date(dt$Date, format='%d/%m/%Y')

# Let us use strptime to merge date and time columns
dfc <- strptime(paste(dt$Date, dt$Time), "%Y-%m-%d %H:%M:%S")

# Convert the string list to a data frame so we can bind it
df <- data.frame(dfc)

# Set the name of the column
setnames(df, "TimeStamp")

# Column bind the timestamp column to our data table
dt <- cbind(dt, df)

# Open the png device so we can write the graph to it
png(filename="C:/dev/data/coursera/ExData_Plotting1/plot4.png", height=480, width=480, bg="transparent")

# Plot the histogram to replicate what was asked in the assignment and save it
par(mfrow=c(2,2))
plot(dt$TimeStamp, dt$Global_active_power, type="l", xlab="", ylab="Global Active Power")
plot(dt$TimeStamp, dt$Voltage, type="l", xlab="datetime", ylab="Voltage")
plot(dt$TimeStamp, dt$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering", legend = c("Sub_metering_1","Sub_metering_1", "Sub_metering_3"))
lines(dt$TimeStamp, dt$Sub_metering_2, type="l", col="Red")
lines(dt$TimeStamp, dt$Sub_metering_3, type="l", col="Blue")
legend("topright", bty='n', c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), lty=c(1,1), lwd=c(2.5,2.5), col=c("black", "red","blue"))
plot(dt$TimeStamp, dt$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")

# Close the png device - No need to worry about the non zero return code
dev.off()