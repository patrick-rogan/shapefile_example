library(ggmap)
library(ggplot2)
library(maptools)
library(viridis)

area = readShapePoly("states.shp")
area$STATE_NAME = as.character(area$STATE_NAME)
area$STATE_NAME = gsub("\\.", "", area$STATE_NAME)

minw = read.csv("2015.csv")
colnames(minw) = c("STATE_NAME","MINIMUM_WAGE")

minw$STATE_NAME = as.character(minw$STATE_NAME)
minw$MINIMUM_WAGE = gsub("n.a.","0",minw$MINIMUM_WAGE) #if no state min, replace with federal
minw$MINIMUM_WAGE = gsub("\\$","",minw$MINIMUM_WAGE)
minw$MINIMUM_WAGE = as.numeric(minw$MINIMUM_WAGE)  

area.map = fortify(area, region = "STATE_NAME")
colnames(area.map) = gsub("id", "STATE_NAME",colnames(area.map))
area.map = merge(minw, area.map, by = "STATE_NAME")

png("State_MinW_C_US.png",width=800, height= 600, units = "px")
ggplot(area.map, aes(x = long, y= lat, group = group, fill=MINIMUM_WAGE)) + 
  xlim(-125,-65) + ylim(25,50) +
  coord_map()+geom_polygon(colour = "black", size = 0.25, aes(group = group))  + 
  ggtitle("2015 State Minimum Wage: Continental US") + theme(plot.title = element_text(size = 15)) +
  ylab("Latitude (Degrees)") + xlab("Longitude (Degrees)") +
  scale_fill_viridis()
dev.off()

