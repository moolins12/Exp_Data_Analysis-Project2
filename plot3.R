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


#### Question 3
# Of the four types of sources indicated by the type (point, nonpoint, onroad,
# nonroad) variable, which of these four sources have seen decreases in
# emissions from 1999-2008 for Baltimore City? Which have seen increases in 
# emissions from 1999-2008? Use the ggplot2 plotting system to make a plot 
# answer this question.

# Aggregate the PM2.5 for each year in Baltimore
library(dplyr)
str(lapply)
PMyearBalt <- summarize(group_by(filter(NEI, fips == "24510"), year, type),
                        Emissions = sum(Emissions))
PMyearBalt
PMyearBalt$Emissions

library(ggplot2)

{
# Open png graphics device
png('plot3.png')
# Plot Emissions per Year
# define the data, use aesthetics to set x axis, define y axis, define conditions
ggplot(PMyearBalt, aes(x=factor(year), y=Emissions, fill = type,
            label = round(Emissions,2))) + # provide bar labels
            geom_bar(stat = "identity") + 
            facet_grid(. ~ type) +
            xlab("year") +
            ylab(expression("Total PM"[2.5]*" Emissions in Tons")) +
            ggtitle(expression("PM"[2.5]*paste(" Emissions in Baltimore ",
                                               "City by various source types", sep="")))+
            geom_label(aes(fill = type), colour = "white", fontface = "bold")
# close png graphics device
dev.off()
}
