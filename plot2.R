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
#### Question 2
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == “24510”) from 1999 to 2008? Use the base plotting system to make a
# plot answering this question.

# Aggregate the PM2.5 for each year
library(dplyr)
str(lapply)
PMyearBalt <- summarize(group_by(filter(NEI, fips == "24510"), year),
                        Emissions = sum(Emissions))
PMyearBalt
PMyearBalt$Emissions

# Open png graphics device
{
png('plot2.png')
# Plot Emissions per Year
# Note, remove x axis scale (xaxt = "n") and replace using axis annotation below
?barplot
plot2 <- barplot(height = PMyearBalt$Emissions/1000, names.arg = PMyearBalt$year,
      xlab = "Years",
      ylab = expression("Total PM"[2.5]*" Emissions / 1000"),
      ylim = c(0, 4))

# provide text lablels of the actual emissions above each data point
text(x = plot2, y = round(PMyearBalt$Emissions/1000, 2),
     label = round(PMyearBalt$Emissions/1000, 2),
     pos = 3, cex = 0.8, col = "black")
title(main = expression("Total PM"[2.5]*" Emissions in Baltmore"))
# close png graphics device
dev.off()
}
