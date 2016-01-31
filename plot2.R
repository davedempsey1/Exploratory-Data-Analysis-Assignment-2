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
AllBaltimoreEmissions <- aggregate(Emissions ~ year, NEIBaltimore, sum)

#Plot data
barplot(AllBaltimoreEmissions$Emissions, names.arg=AllBaltimoreEmissions$year, xlab="Year", ylab="PM2.5 Baltimore Emissions", main="Total PM2.5 Baltimore Emissions From All US Sources")

#Resultant plot shows Emissions have not decreased over the years in
#Baltimore despite Question 1 results