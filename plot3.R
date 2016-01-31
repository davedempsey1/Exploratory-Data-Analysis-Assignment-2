#Load the libraries needed for assignment
library(ggplot2)
library(plyr)

#Assuming file is located in working directory
#unzip file to working directory
unzip("exdata-data-NEI_data.zip")

#read SDS files and set variables to them
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#convert year, type, pollutant SCC and fips columsn to factor
colToFactor <- c("year", "type", "Pollutant","SCC","fips")
NEI[,colToFactor] <- lapply(NEI[,colToFactor], factor)

#take care of NA columns
levels(NEI$fips)[1] = NA
NEIdata<-NEI[complete.cases(NEI),]
colSums(is.na(NEIdata))

#Subset Baltimore data from full set
NEIBaltimore<-subset(NEIdata, fips == "24510")

#Plot data using ggplot2
g<-ggplot(aes(x = year, y = Emissions, fill=type), data=NEIBaltimore)
g + geom_bar(stat="identity") + facet_grid(.~type) + labs(x="year", y=expression("Total PM2.5 Emission (Tons)")) + labs(title=expression("PM2.5 Emissions, Baltimore City 1999-2008 by Source Type")) + guides(fill=FALSE)

# All sources except for "POINT" show a decrease over time
# POINT shows an increase up to 2005 then its own decrease