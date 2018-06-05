############ ############ ############ ############ ############ ############ 
############ Project      ############ ############ ############ ############ 
############ ############ ############ ############ ############ ############ 

data_folder <- "Project Data"
filename <- "Project_Data.zip"

if(!file.exists(data_folder)) {
      dir.create(data_folder)
}

path <- paste(getwd(), data_folder, sep = "/")
setwd(path)

if (!file.exists(filename)) {
      fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
      download.file(fileURL, destfile = paste(path, filename, sep = "/"), method = "curl")
}
list.files()
if(file.exists(filename)) {
      unzip(filename)
}
list.files()

library(data.table)
SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))

names(SCC)
names(NEI)
head(SCC)
head(NEI)
str(SCC)
str(NEI)

?.SD
#### Question 1 
# Have total emissions from PM2.5 decreased in the United States from 1999 to
# 2008? Using the base plotting system, make a plot showing the total PM2.5
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.

# Aggregate the PM2.5 for each year
library(dplyr)
str(lapply)
PMyear <- summarize(group_by(NEI, year), Emissions = sum(Emissions))
PMyear

# Open png graphics device
{
png('plot1.png')
# Plot Emissions per Year
# Note, remove x axis scale (xaxt = "n") and replace using axis annotation below
plot(PMyear$year, PMyear$Emissions/1000, xlab = "Years",
      ylab = expression("Total PM"[2.5]*" Emissions / 1000"),
      xaxt = "n", type = "l", ylim = c(2000, 8000))
axis(1, at = seq(1999, 2008, by = 3), las = 2)

# provide text lablels of the actual emissions above each data point
#text(x = PMyear$year, y = round(PMyear$Emissions/1000, 2),
#     label = round(PMyear$Emissions/1000, 2),
#     pos = 3, cex = 0.8, col = "black")
title(main = expression("Total PM"[2.5]*" Emissions in U.S."))

# close png graphics device
dev.off()
}
