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

#### Question 6
# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California
# (fips == “06037”). Which city has seen greater changes over time in motor
# vehicle emissions?

# Aggregate the PM2.5 for each year in US
library(dplyr)

# Identify cases with for On-Road in Baltimore and LA
PMyearBalt <- summarize(group_by(filter(NEI, fips == "24510" & type == "ON-ROAD"),
                                 year), Emissions = sum(Emissions))
PMyearLA <- summarize(group_by(filter(NEI, fips == "06037" & type == "ON-ROAD"),
                                 year), Emissions = sum(Emissions))

# Add a label for the county to each dataset
PMyearBalt$County <- "Baltimore"
PMyearLA$County <- "Los Angeles"
# Combine the counties
PMyearboth <- rbind(PMyearBalt, PMyearLA)

library(ggplot2)

{
# Open png graphics device
png('plot6.png')
# Plot Emissions per Year
# define the data, use aesthetics to set x axis, define y axis, define conditions
ggplot(PMyearboth, aes(x = factor(year), y = Emissions, fill = County, label = round(Emissions, 2))) +
      geom_bar(stat = "identity") + 
      facet_grid(County ~ ., scales = "free") +
      xlab("Year") +
      ylab(expression("Total PM"[2.5]*" Emissions in Tons")) +
      ggtitle("Emissions from Vehicle Sources in Baltimore and LA")
      geom_label(aes(fill = County), colour = "white", fontface = "bold") 
      
# close png graphics device
dev.off()
}
