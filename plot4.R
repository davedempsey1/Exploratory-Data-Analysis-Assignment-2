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

names(SCC)<-gsub("\\.","", names(SCC))

SCCcombustion<-grepl(pattern = "comb", SCC$SCCLevelOne, ignore.case = TRUE)
SCCCoal<-grepl(pattern = "coal", SCC$SCCLevelFour, ignore.case = TRUE)

SCCCoalCombustionSCC<-SCC[SCCcombustion & SCCCoal,]$SCC
NIECoalCombustionValues<-NEIdata[NEIdata$SCC %in% SCCCoalCombustionSCC,]
NIECoalCombustionTotalEm<-aggregate(Emissions ~ year, NIECoalCombustionValues, sum)

g<-ggplot(aes(year, Emissions/10^5), data=NIECoalCombustionTotalEm)
g + geom_bar(stat="identity",fill="grey",width=0.75) + guides(fill=FALSE) + labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions Across US from 1999-2008"))

#Somewhat decrease is seen in graph though
#there is a slight increase from 2002 to 2005