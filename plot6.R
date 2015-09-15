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
NEI.f<-filter(NEI, type %in% c("ON-ROAD","NON-ROAD"), fips %in% c("24510","06037"))

#Alter Names of Cities
NEI.f<-mutate(NEI.f, City=ifelse(fips=="24510", "Baltimore City, MD", "Los Angeles County, CA"))

#Summarize
sumData <- summarize(group_by(NEI.f, Year=year, Source=type, City=City),Emissions=sum(Emissions))

#Assign Plots to Variables
g1<-ggplot(sumData,aes(Year, Emissions))+
        geom_bar(stat="identity", aes(fill=Source))+
        geom_smooth(method="lm", color="darkblue", size=1, se=FALSE, linetype=2)+
        facet_wrap(~City)+
        labs(title=expression('Total PM '[2.5]*'  Emissions from Motor Vehicles by City (Same Scale)'),
             y=expression('Total PM '[2.5]*'  Emissions'), x="Year")+
        scale_x_continuous(breaks=seq(minYear, maxYear, by=3))+
        theme(text = element_text(size=16), axis.text=element_text(color="grey30"))+
        theme(axis.title.y=element_text(vjust=1),plot.title=element_text(size=15, vjust=1.5, face="bold"))

g2<-ggplot(sumData,aes(Year, Emissions))+
        geom_bar(stat="identity", aes(fill=Source))+
        geom_smooth(method="lm", color="darkblue", size=1, se=FALSE, linetype=2)+
        facet_wrap(~City, scales = "free")+
        labs(title=expression('Total PM '[2.5]*'  Emissions from Motor Vehicles by City (Free Scale)'),
             y=expression('Total PM '[2.5]*'  Emissions'), x="Year")+
        scale_x_continuous(breaks=seq(minYear, maxYear, by=3))+
        theme(text = element_text(size=16), axis.text=element_text(color="grey30"))+
        theme(axis.title.y=element_text(vjust=1),plot.title=element_text(size=15, vjust=1.5, face="bold"))

#Create Layout of Grid and Print to Grid
png(file = "plot6.png",width = 800, height = 800)

grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 1)))
vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
print(g1, vp = vplayout(1, 1))  # key is to define vplayout
print(g2, vp = vplayout(2, 1))

dev.off()
