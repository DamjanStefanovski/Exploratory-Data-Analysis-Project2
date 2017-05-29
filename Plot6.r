# Packs

library(plyr)
library(ggplot2)
library(RColorBrewer)
library(ggthemes)
# Setting a theme
theme_set(theme_fivethirtyeight())


#  Read Data 
NEI <- readRDS("./summarySCC_PM25.rds")
SCC <- readRDS("./Source_Classification_Code.rds")


## elaborate plotdata:Total PM25 emission from Baltimore City and 
## Los Angeles County per year for motor vehicles

# get Baltimore and Los Angeles NEI data
NEIBaLa <- subset(NEI, fips == "24510" | fips == "06037")

# get motor vehicle SCC
VehicleSCC <- SCC[grepl("Vehicle", SCC$EI.Sector),]

# select baltimore data based on vehicle sources
vehicleBaLa <- subset(NEIBaLa, NEIBaLa$SCC %in% VehicleSCC$SCC)

# assign the city name, based on fips code
vehicleBaLa$city <- rep(NA, nrow(vehicleBaLa))
vehicleBaLa[vehicleBaLa$fips == "06037", ][, "city"] <- "Los Angeles County"
vehicleBaLa[vehicleBaLa$fips == "24510", ][, "city"] <- "Baltimore City"


# make plotdata
plotdata <- aggregate(vehicleBaLa[c("Emissions")], 
                      list(city = vehicleBaLa$city, 
                           year = vehicleBaLa$year), sum)
# Create and plot a file 

png('plot6.png', width=480, height=480)

ggp <- ggplot(plotdata, aes(x=factor(year), y=Emissions, fill=city)) +
        geom_bar(aes(fill=year),stat="identity") +
        facet_grid(scales="free", space="free", .~city) +
        guides(fill=FALSE) + theme_fivethirtyeight() +
        labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
        labs(title=expression("PM"[2.5]*"Emissions in Baltimore & LA, 1999-2008 for Motor Vehicles"))

print(ggp)

dev.off()





