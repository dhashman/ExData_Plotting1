# Script to create plot 4 png of Exploratory Data Analysis Project 1 from a subset of the University of
# California Irvine (UCI) Machine Learning Repository's Individual household electric power consumption
# (HPC) dataset.
#
# See http://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption.
#
# If it doesn't already exist in the current working directory, the tidy dataset is created from
# a cloud-based zipped copy of the UCI HPC Dataset, downloading and/or unzipping the original dataset
# as required. If the tidy dataset is newly created, it is written out as a comma-separated flat text
# file that can be subsequently read back in using fread as shown below to re-create the data table
# for further analysis. The tidy flat file can also be imported to Excel as a comma-separated text file.
#
# To prove that the re-created data table is identical, use the compare package:
#
# library(compare)
# new_dt <- fread(project_file)
# print(compare(data.frame(new_dt), data.frame(dt)))
#
# The tidy dataset consists of 8 variables for the period February 1-2, 2007 (2880 observations).
# See README.md for additional details. The tidy dataset is then used to create a png of plot 4
# (4 subplots: datetime vs. Global Active Power, datetime vs. Voltage, datetime vs. Sub Metering, 
# and datetime vs. Global Reactive Power).

# Load packages.
library(data.table)
library(ggplot2)

# Create and save project data table if it does not already exist.
project_file <- "./project1_hpc.txt"
if (!file.exists(project_file)) {
    
    # Unzip file to the current working directory if not already unzipped.
    unzipped_file <- "./household_power_consumption.txt" 
    if (!file.exists(unzipped_file)) {
        
        # Download zipfile into the current working directory if not already downloaded.
        local_zipfile <- "./exdata-data-household_power_consumption.zip" 
        if (!file.exists(local_zipfile)) {
            url <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
            download.file(url, destfile = local_zipfile, mode = "wb")
        }
        unzip(local_zipfile)
    }    
    # Create full data table.
    full_dt <- data.table(read.csv2(unzipped_file, stringsAsFactors = F))
    
    # Subset data table according to dates of interest.
    sub_dt <- subset(full_dt, Date == '1/2/2007' | Date == '2/2/2007')
    
    # Combine and reformat date and time into new data table.
    temp_dt <- data.table(paste(sub_dt$Date, sub_dt$Time))
    date_dt <- data.table(as.POSIXct(strptime(temp_dt$V1, "%d/%m/%Y %H:%M:%S")))
    setnames(date_dt, "datetime")
    
    # Eliminate old date and time columns.
    sub_dt$Date <- NULL
    sub_dt$Time <- NULL
    
    # Set column classes.
    sub_dt <- sub_dt[, lapply(.SD, as.numeric)]
    
    #Add datetime column to table and save as comma-separated text file.
    dt <- cbind(date_dt, sub_dt)
    write.csv(dt, project_file, row.names = F)
    
    # Clean up workspace.
    rm(full_dt, sub_dt, temp_dt, date_dt)
    
} else {
    
    # Create oroject data table from previously saved file
    dt <- fread(project_file)
    
    # Set column classes.
    dt$datetime <- as.POSIXct(dt$datetime)
    for (i in 6:8) {
        dt[[i]] <- as.numeric(dt[[i]])
    }
}
# Open png device with default 480 x 480 size and transparent background.
png("plot4.png", bg = "transparent")

# Split sceen
split.screen(rbind(c(0, 0.51, 0.47, 1), c(0.49, 1, 0.47, 1),
                   c(0, 0.51, 0, 0.53), c(0.49, 1, 0, 0.53)))

# Plot screen 1: datetime vs. Global_active_power.
screen(1)
plot(dt$datetime, dt$Global_active_power, type="l", xlab = NA,
     ylab = "Global Active Power", cex.axis = 0.75, cex.lab = 0.75)

# Plot screen 2: datetime vs. Voltage.
screen(2)
plot(dt$datetime, dt$Voltage, type="l", xlab = "datetime", ylab = "Voltage",
     cex.axis = 0.75, cex.lab = 0.75)

# Plot screen 3: datetime vs. Sub_metering_1 and set y limits for overlay.
screen(3)
plot(dt$datetime, dt$Sub_metering_1, type="l", xlab = NA,
     ylab = "Energy sub metering", cex.axis = 0.75, cex.lab = 0.75,
     ylim = range(c(dt$Sub_metering_1, dt$Sub_metering_2, dt$Sub_metering_3)))

# Add legend.
legend("topright", names(dt)[6:8], col = c("black","red","blue"), lty = 1, 
       cex = 0.75, bty = "n")

# Overlay plot datetime vs. Sub_metering_2 in red, keeping same y limits.
par(new=T)
plot(dt$datetime, dt$Sub_metering_2, type="l", xlab = NA, ylab = NA, axes = F, col = "red",
     ylim = range(c(dt$Sub_metering_1, dt$Sub_metering_2, dt$Sub_metering_3)))

# Overlay plot datetime vs. Sub_metering_3 in blue, keeping same y limits.
par(new=T)
plot(dt$datetime, dt$Sub_metering_3, type="l", xlab = NA, ylab = NA, axes = F, col = "blue",
     ylim = range(c(dt$Sub_metering_1, dt$Sub_metering_2, dt$Sub_metering_3)))

# Plot datetime vs. Global_reactive_power.
screen(4)
plot(dt$datetime, dt$Global_reactive_power, type="l", xlab = "datetime", 
     ylab = "Global_reactive_power", cex.axis = 0.75, cex.lab = 0.75)

# Close screens and png device.
close.screen(all = T)
dev.off()
