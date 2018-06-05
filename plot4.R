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


#### Question 4
# Across the United States, how have emissions from coal combustion-related
# sources changed from 1999-2008?

head(SCC$EI.Sector)

# Aggregate the PM2.5 for each year in US
library(dplyr)

# Identify cases with Coal from SCC dataframe
coal <- grepl("Fuel Comb.*Coal*", SCC$EI.Sector)
# Subset the SCC dataframe for only coal cases
coal_data <- SCC[coal, ]
# Use the SCC ID to identify and subset only coal cases in the NEI emissions
coal_emiss <- NEI[NEI$SCC %in% coal_data$SCC]
      
PMcoalyear <- summarize(group_by(NEI, year),
                        Emissions = sum(Emissions))

library(ggplot2)
?qplot
getwd()
{
# Open png graphics device
png('plot4.png')
# Plot Emissions per Year
# define the data, use aesthetics to set x axis, define y axis, define conditions
ggplot(PMcoalyear, aes(x=factor(year), y = Emissions/1000,fill=year,
      label = round(Emissions/1000, 2))) +
      geom_bar(stat="identity") + 
      xlab("year") +
      ylab(expression("Total PM"[2.5]*" Emissions in Kilotons")) +
      ggtitle("U.S. Emissions from Coal Sources")+
      geom_label(aes(fill = year),colour = "white", fontface = "bold") 
      
# close png graphics device
dev.off()
}
