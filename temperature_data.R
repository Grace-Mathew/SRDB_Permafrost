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
df <- SRDB_Data %>% 
  select("Study_midyear", "Longitude", "Latitude", "Manipulation", "Rs_annual", "Rh_annual", "MAT", "MAP", "Biome", "Ecosystem_type")

# Items from BBL email -- summary, etc.
ncol(df)
nrow(df)
plot(df$Study_midyear, df$Rs_annual)
plot(df$MAT, df$Rh_annual)

# Make a map

---

df <- read.csv(SRDB_Data) %>%
  select("Author", "Study_midyear", "Biome", "Rs_annual", "Rh_annual", "Rs_growingseason", "Ecosystem_type", "MAT")
world_coordinates <- map_data("world") 

temperature <- df %>%
  filter(MAT < 2)

# World map on ggplot2

world <- ne_countries()
ggplot(world)+
  geom_sf()+
  geom_point(data = temperature, aes(x=Longitude, y=Latitude, colour = MAT), size = 1.5)+
  scale_color_viridis_c()
 
