#Load Libraries
library(dplyr)
library(data.table)
library(ggplot2)
library(grid)

#Load Data
if (!exists("NEI")) {NEI <- as.data.table(readRDS("data/summarySCC_PM25.rds"))}
if (!exists("SCC")) {SCC <- as.data.table(readRDS("data/Source_Classification_Code.rds"))}

#Merge the Data
mergedData <- merge(NEI,SCC,by="SCC")

#Data just for Coal Combustion
CoalCombData<-mergedData[grep(".*comb.*coal.*",mergedData$Short.Name, ignore.case=TRUE)]

#Summarize Data
sumData<-summarize(group_by(CoalCombData, Year=year),Emissions=sum(Emissions))
minYear<-min(sumData$Year)
maxYear<-max(sumData$Year)

#Assign Plot to Variable
g<-ggplot(sumData,aes(Year, Emissions))+
        geom_bar(stat="identity", fill="steelblue")+
        labs(title=expression('Total PM '[2.5]*'  Emissions from Coal Combustion Sources by Year'),
             y=expression('Total PM '[2.5]*'  Emissions (from Coal Combustion)'), x="Year")+
        scale_x_continuous(breaks=seq(minYear, maxYear, by=3))+
        theme(text = element_text(size=16), axis.text=element_text(color="grey30"))+
        theme(axis.title.y=element_text(vjust=1),plot.title=element_text(size=15, vjust=1.5, face="bold"))

#Create Layout of Grid and Print to Grid
png(file = "plot4.png",width = 600, height = 480)
print(g)
dev.off()

