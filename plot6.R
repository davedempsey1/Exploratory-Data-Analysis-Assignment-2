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

SCCvehicle<-grepl(pattern = "vehicle", SCC$EISector, ignore.case = TRUE)
SCCvehicleSCC <- SCC[SCCvehicle,]$SCC

NEIvehicleSSC <- NEIdata[NEIdata$SCC %in% SCCvehicleSCC, ]
NEIvehicleBaltimore <- subset(NEIvehicleSSC, fips == "24510")
NIEvehicleBaltimoreTotEm<-aggregate(Emissions~year, NEIvehicleBaltimore, sum)

NEIvehicleBalti<-subset(NEIvehicleSSC, fips == "24510")
NEIvehicleBalti$city <- "Baltimore City"
NEIvehiclela<-subset(NEIvehicleSSC, fips == "06037")
NEIvehiclela$city <- "Los Angeles County"
NEIBothCity <- rbind(NEIvehicleBalti, NEIvehiclela)

ggplot(NEIBothCity, aes(x=year, y=Emissions, fill=city)) + geom_bar(aes(fill=year),stat="identity") + facet_grid(.~city) + guides(fill=FALSE) + theme_bw() + labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))

#Vehicle source emissions appear to be overal much better in Baltimore
#than in LA County where decreasing trend is also seen in Baltimore
#that is not seen in LA County until 2005 on