#Load Libraries
library(dplyr)
library(data.table)
library(ggplot2)
library(grid)
library(data.table)

#Load Data
if (!exists("NEI")) {NEI <- as.data.table(readRDS("data/summarySCC_PM25.rds"))}
if (!exists("SCC")) {SCC <- as.data.table(readRDS("data/Source_Classification_Code.rds"))}

#Filter Data
NEI.f<-filter(NEI, type %in% c("ON-ROAD","NON-ROAD"), fips=="24510")

#Summarize
sumData <- summarize(group_by(NEI.f, Year=year, Source=type),Emissions=sum(Emissions))

#Assign Plot to Variable
g<-ggplot(sumData,aes(Year, Emissions))+
        geom_bar(stat="identity", aes(fill=Source))+
        labs(title=expression('Total PM '[2.5]*'  Emissions from Motor Vehicles in Baltimore City, MD by Year'),
             y=expression('Total PM '[2.5]*'  Emissions (from Motor Vehicles)'), x="Year")+
        scale_x_continuous(breaks=seq(minYear, maxYear, by=3))+
        theme(text = element_text(size=16), axis.text=element_text(color="grey30"))+
        theme(axis.title.y=element_text(vjust=1),plot.title=element_text(size=15, vjust=1.5, face="bold"))

#Create Layout of Grid and Print to Grid
png(file = "plot5.png",width = 600, height = 480)
print(g)
dev.off()
