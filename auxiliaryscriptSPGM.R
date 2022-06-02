library(tidyverse)

#cleaning the database
datos <- read.csv("database.csv")
names(datos)
str(datos)

datos <- datos %>% 
  select(lat:lon)

saveRDS(datos, "locations.Rds")

#looking at some shape files
library(sf)
shape_one <- st_read("borough_boundaries/geo_export_a88ff5b0-7fb1-479d-a22b-224328f6d976.shp")
plot(shape_one$geometry)
NY_border <- shape_one$geometry

#Changing the crs for the border
NY_border <- st_transform(NY_border, "+proj=utm +zone=18 elips=WGS84")

#transforming the data from lon, lat to utm
locations <- st_sfc(st_multipoint(as.matrix(datos[, 2:1])), crs = "+proj=longlat +zone=18 elips=WGS84")
locations <- st_transform(locations, "+proj=utm +zone=18 elips=WGS84")
locations <- st_intersection(NY_border, locations) #leaving only inside NY points

#saving previous objects
save(NY_border, locations, file = "Contour_Points.RData")

plot(NY_border)
plot(locations, add = T, pch = 20, col = "red")

#creating ppp objects
library(spatstat)
library(maptools)
load("Contour_Points.RData")

obs.win <- as(as(st_sf(NY_border), "Spatial"), "owin")
ppp.NY <- ppp(x = st_coordinates(locations)[, 1],
              y = st_coordinates(locations)[, 2],
              window = obs.win)
coord.units <- c("metre", "metres")
unitname(ppp.NY) <- coord.units
plot(ppp.NY)
saveRDS(ppp.NY, "pppNY.Rds")

