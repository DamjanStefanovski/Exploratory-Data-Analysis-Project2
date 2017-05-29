# Packs

library(plyr)
library(ggplot2)
library(RColorBrewer)
library(ggthemes)
# Setting a theme
theme_set(theme_fivethirtyeight())

NEI <- readRDS("./summarySCC_PM25.rds")

## elaborate plotdata: aggregate total PM25 emission from Baltimore per year

baltimore <- subset(NEI, fips == "24510")
plotdata <- aggregate(baltimore[c("Emissions")], 
                      list(type=baltimore$type, year = baltimore$year), sum)


## create file
png('plot3.png', width=480, height=480)

## plot data
p <- ggplot(plotdata, aes(x=year, y=Emissions, colour=type)) +
        # fade out the points so you will see the line
        geom_point(alpha=0.1) +
        # use loess as there are many datapoints
        geom_smooth(method="loess") +
        ggtitle("Total PM2.5 Emissions in Baltimore per Type 1999-2008")
print(p)

## close device
dev.off()