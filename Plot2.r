# Packs

library(plyr)
library(ggplot2)
library(RColorBrewer)
library(ggthemes)
# Setting a theme
theme_set(theme_fivethirtyeight())

#  Read Data 
NEI <- readRDS("./summarySCC_PM25.rds")

## elaborate plotdata: aggregate total PM25 emission from Baltimore per year
baltimore <- subset(NEI, fips == "24510")
plotdata <- aggregate(baltimore[c("Emissions")], list(year = baltimore$year), sum)


##  creating plot 2 and creating a file
png('plot2.png', width=480, height=480)

## plot data
plot(plotdata$year, plotdata$Emissions, type = "l", 
     main = "Total PM2.5 Emission in Baltimore 1999-2008",
     xlab = "Year", ylab = "Emissions")

## close device
dev.off()