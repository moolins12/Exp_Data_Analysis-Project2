############ ############ ############ ############ ############ ############ 
############ Project      ############ ############ ############ ############ 
############ ############ ############ ############ ############ ############ 

#### Clustering Case study using the Samsung movement data

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
View(SCC)

#### Question 5
# How have emissions from motor vehicle sources changed from 1999-2008 in
# Baltimore City?

head(SCC$EI.Sector)

# Aggregate the PM2.5 for each year in US
library(dplyr)

# Identify cases with for On-Road in Baltimore
PMroad <- NEI[(NEI$fips == "24510") & (NEI$type == "ON-ROAD"), ]

PMroadyear <- summarize(group_by(PMroad, year),
                        Emissions = sum(Emissions))

library(ggplot2)

{
# Open png graphics device
png('plot5.png')
# Plot Emissions per Year
# define the data, use aesthetics to set x axis, define y axis, define conditions
ggplot(PMroadyear, aes(x = factor(year), y = Emissions, fill = year,
      label = round(Emissions, 2))) +
      geom_bar(stat = "identity") + 
      xlab("Year") +
      ylab(expression("Total PM"[2.5]*" Emissions in Tons")) +
      ggtitle("Baltimore Emissions from Vehicle Sources")
      geom_label(aes(fill = year),colour = "white", fontface = "bold") 
      
# close png graphics device
dev.off()
}
