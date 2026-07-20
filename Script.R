# Analysis - GM 2026

# Load packages
library(dplyr)
library(ggplot2)
library(tidyr)
library(sf)
library(rnaturalearth)
library(readr)
library(lubridate)
library(terra)
library(arrow)
library(DT)
theme_set(theme_bw())

# Read Data
SRDB_Data <- read.csv("srdb-data.csv")
print(SRDB_Data)

# Select only columns of interest
df <- SRDB_Data %>% select("Study_midyear", "Longitude", "Latitude", "Manipulation", "Rs_annual", "Rh_annual", "MAT", "MAP", "Biome", "Ecosystem_type")

# Items from BBL email -- summary, etc.
ncol(df)
nrow(df)
plot(df$Study_midyear, df$Rs_annual)
plot(df$MAT, df$Rh_annual)

# Make a map


world_coordinates <- map_data("world")

# World map on ggplot2

world <- ne_countries()
ggplot(world)+
  geom_sf()+
  geom_point(data = SRDB_Data, aes(x=Longitude, y=Latitude, colour = Rs_annual), size = 1.5)+
  scale_color_viridis_c(limits = c(0,2000), breaks = seq(0,2000,by=500), oob = scales::squish)



