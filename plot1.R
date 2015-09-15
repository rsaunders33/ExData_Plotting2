#Load Libraries
library(dplyr)
library(data.table)

#Load Data
if (!exists("NEI")) {NEI <- as.data.table(readRDS("data/summarySCC_PM25.rds"))}
if (!exists("SCC")) {SCC <- as.data.table(readRDS("data/Source_Classification_Code.rds"))}

#Summarize Data
sumData<-summarize(group_by(NEI, Year=year),Emissions=sum(Emissions))

#Plot
png(file = "plot1.png",width = 480, height = 480)

barplot(height=sumData$Emissions, names.arg=sumData$Year, 
        col="steelblue", ylab=expression('Total PM '[2.5]*'  Emissions'), xlab="Year", 
        main=expression('Total PM '[2.5]*'  Emissions by Year'))

dev.off()

