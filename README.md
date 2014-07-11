## Introduction
Project 1 of the Exploratory Data Analysis class involves creating 4 plots from a subset of the University of the California Irvine (UCI) Machine Learning Repository's Individual household electric power consumption (HPC) dataset. See http://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption.

This repository is forked and cloned from https://github.com/rdpeng/ExData_Plotting1. Each of the scripts in this repository (plot1.R, plot2.R, plot3.R, and plot4.R) follows the same logic:
- If it doesn't already exist in the current working directory, the tidy dataset is created from a cloud-based zipped copy of the UCI HPC Dataset (http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip), with the original dataset downloaded and/or unzipped as required. The tidy dataset consists of 8 variables for the period February 1-2, 2007 (2880 observations). 
- If the tidy dataset is newly created by a script, it is written out as a comma-separated flat text file that can be subsequently read back in for further analysis by other scripts. The tidy flat file can also be imported to Excel as a comma-separated text file.
- The tidy dataset is then used to create a png of the required plot and save it in the current working directory as plot1.png, plot2.png, plot3.png, or plot4.png.

This repository also contains the output of each script (plot1.png, plot2.png, plot3.png, and plot4.png) and a copy of the tidy dataset (project1_hpc.txt). In addition, there is a figure folder from the original fork that contains the example plots.

## Description of the original UCI HPC dataset
The UCI HPC dataset consists of measurements of electric power consumption in one household with a one-minute sampling rate over a period of almost 4 years. Different electrical quantities and some sub-metering values are available.

The dataset has 2,075,259 rows and 9 columns. The 9 variables for each observation are:
<ol>
<li><b>Date</b>: Date in format dd/mm/yyyy </li>
<li><b>Time</b>: time in format hh:mm:ss </li>
<li><b>Global_active_power</b>: household global minute-averaged active power (in kilowatt) </li>
<li><b>Global_reactive_power</b>: household global minute-averaged reactive power (in kilowatt) </li>
<li><b>Voltage</b>: minute-averaged voltage (in volt) </li>
<li><b>Global_intensity</b>: household global minute-averaged current intensity (in ampere) </li>
<li><b>Sub_metering_1</b>: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered). </li>
<li><b>Sub_metering_2</b>: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light. </li>
<li><b>Sub_metering_3</b>: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.</li>
</ol>
NOTE: Missing values in this dataset are coded as "?".

## Description of the tidy subset of UCI HPC dataset
The tidy subset of the UCI HPC dataset consists of 8 variables and 2880 observations, derived using the following logic:
- Only data from February 1-2, 2007 is used.
- The original Date and Time columns have been removed and replaced with a single <b>datetime</b> column in POSIXct format that contains the combined date and time for each observation.
- The remaining 7 original variables are kept as numeric values with the same names as the original dataset.
 
## Description of the plots and scripts
All of the plots for this assignment were reconstructed from the examples using the base R plotting system. Each plot was:
- Constructed and saved to a PNG file in the current working directory with a default 480 x 480 pixel size.
- Named as plot1.png, plot2.png, etc.
- Created using a separate R code file (plot1.R, plot2.R, etc.) that constructed the plot from the data, including recreating the tidy subset as necessary from the original data.

The 4 plots included in this assignment are:
- Plot 1: Histogram of Global Active Power.
- Plot 2: X-Y plot of datetime vs. Global Active Power.
- Plot 3: X-Y plot of datetime vs. Sub Metering (with overlays for Sub_metering_1, Sub_metering_2, and Sub_metering_3).
- Plot 4: 4 subplots (4 X-Y subplots: datetime vs. Global Active Power, datetime vs. Voltage, datetime vs. Sub Metering, and datetime vs. Global Reactive Power).