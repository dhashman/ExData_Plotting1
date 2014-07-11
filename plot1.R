# Script to create plot 1 png of Exploratory Data Analysis Project 1 from a subset of the University of
# California Irvine (UCI) Machine Learning Repository's Individual household electric power consumption
# (HPC) dataset.
#
# See http://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption.
#
# If it does not already exist in the current working directory, the script extracts a cloud-based zipped
# copy of the UCI HPC Dataset and creates a tidy dataset consisting of 8 variables for the period
# February 1-2, 2007 (2880 observations). See README.md for additional details.
#
# If it didn't already exist in the current working directory, the tidy dataset is written out as a
# comma-separated flat text file that can be subsequently read back in using fread as shown below to
# re-create the data table for further analysis. The tidy flat file can also be imported to Excel as
# a comma-separated text file.
#
# To prove that the re-created data table is identical, use the compare package:
#
# library(compare)
# new_dt <- fread(project_file)
# print(compare(data.frame(new_dt), data.frame(dt)))
#
# The tidy dataset is then used to create a png of plot 1 (histogram of Global Active Power).

# Load packages.
library(data.table)
library(ggplot2)

# URL of cloud-based zipped copy of UCI individual electric household power consumption dataset.
url <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Download zipfile into the current working directory if not already downloaded.
local_zipfile <- "./exdata-data-household_power_consumption.zip"
if (!file.exists(local_zipfile)) {
    download.file(url, destfile = local_zipfile, mode = "wb")
}

# Unzip file to the current working directory if not already unzipped.
unzipped_file <- "./household_power_consumption.txt"
if (!file.exists(unzipped_file)) {
    unzip(local_zipfile)
}

# Create and save project data table if it does not already exist.
project_file <- "./project1_hpc.txt"
if (!file.exists(project_file)) {
    
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
# Set global plot parameters.
par(mar = c(3, 3, 1, 1), bg = "transparent")

# Open png device with default 480 x 480 size.
png("plot1.png")

# Plot base histogram.
hist(dt$Global_active_power, xlab = NA, ylab = NA, main = NA, axes = F, col = "red")

# Add custom axes to match example.
axis(side = 1, tck = -.015, labels = NA)
axis(side = 2, tck = -.015, labels = NA)
axis(side = 1, lwd = 0, line = -.4, cex.axis = 0.9, font = 2)
axis(side = 2, lwd = 0, line = -.4, las = 0, cex.axis = 0.9, font = 2, pos = -0.25)

# Add custom labels to match example.
mtext("Global Active Power (kilowatts)", side = 1, line = 2, font = 2, cex = 0.9, adj = 0.53)
mtext("Frequency", side = 2, line = 2.5, font = 2, cex = 0.9)
mtext("Global Active Power", side = 3, line = 0, font = 2, cex = 1.2)

# Close png device.
dev.off()
