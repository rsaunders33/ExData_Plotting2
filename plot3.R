#Load Libraries
library(dplyr)
library(ggplot2)
library(grid)
library(data.table)

#Load Data
if (!exists("NEI")) {NEI <- as.data.table(readRDS("data/summarySCC_PM25.rds"))}
if (!exists("SCC")) {SCC <- as.data.table(readRDS("data/Source_Classification_Code.rds"))}

#Subset Data
NEI.f<-filter(NEI, fips=="24510")

#Summarize Data
sumData<-summarize(group_by(NEI.f, Year=year, Source=type),Emissions=sum(Emissions))
minYear<-min(sumData$Year)
maxYear<-max(sumData$Year)

#Assign Plot to Variable
g<-ggplot(sumData,aes(Year, Emissions))+
        geom_bar(stat="identity",aes(fill=Source))+
        facet_grid(.~Source)+
        geom_smooth(method="lm", color="darkblue", size=1, se=FALSE, linetype=2)+
        labs(title=expression('Total PM '[2.5]*'  Emissions in Baltimore City, MD by Year (With Regression)'),
             y=expression('Total PM '[2.5]*'  Emissions'), x="Year")+
        scale_x_continuous(breaks=seq(minYear, maxYear, by=3))+
        theme(panel.margin = unit(1, "lines"))+
        theme(plot.title=element_text(size=15, vjust=1.5, face="bold"))

#Create Layout of Grid and Print to Grid
png(file = "plot3.png",width = 800, height = 480)
print(g)
dev.off()
