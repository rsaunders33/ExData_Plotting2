#Load Libraries
library(dplyr)
library(data.table)

#Load Data
if (!exists("NEI")) {NEI <- as.data.table(readRDS("data/summarySCC_PM25.rds"))}
if (!exists("SCC")) {SCC <- as.data.table(readRDS("data/Source_Classification_Code.rds"))}

#Subset Data
NEI.f<-filter(NEI, fips=="24510")

#Summarize Data
sumData<-summarize(group_by(NEI.f, Year=year),Emissions=sum(Emissions))

#Plot
png(file = "plot2.png",width = 480, height = 480)

barplot(height=sumData$Emissions, names.arg=sumData$Year, 
        col="steelblue", ylab=expression('Total PM '[2.5]*'  Emissions'), xlab="Year", 
        main=expression('Total PM '[2.5]*'  Emissions in Baltimore City, MD by Year'))

dev.off()
