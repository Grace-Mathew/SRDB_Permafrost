# Match SRDB data with WorldClim data

# Load Packages
library(geodata)
library(terra)
#library(janitor)
library(dplyr)
library(tidyr)
library(sf)
library(ggplot2)
library(rnaturalearth)
library(readr)
library(lubridate)
library(arrow)
library(DT)

SRDB_Data <- read.csv("srdb-data.csv")

# We need longitude and latitude data to do anything, so filter for that
SRDB_Data |>
  as_tibble() |>
  select(Longitude, Latitude, MAT, Rs_annual, Record_number) |>
  filter(!is.na(Longitude), !is.na(Latitude)) ->
  SRDB_filtered

coords <- SRDB_filtered %>% select(Longitude, Latitude)
print(SRDB_Data)
# Start simple and small, with 10 degree resolutions (smallest data)
temp_data <- worldclim_global(var = "tavg", res = 10, path = "worldclim_data/")



temp_values <- terra::extract(temp_data, coords)
print(temp_values)

# Now, we want to compute MAT - mean of the 12 data columns
SRDB_filtered$MAT_wc <- rowMeans(temp_values[, -1], na.rm = TRUE)
print(MAT)
head(SRDB_filtered)


# Acid test: plot MAT versus MAT_worldclim
ggplot(data = SRDB_filtered, aes(x = MAT, y = MAT_wc, color = Latitude))+
  geom_point(size = 2)+
  geom_abline() 
#  scale_colour_manual(values = c("MAT" = "red", "MAT_wc" = "blue"))


world_coords <- map_data("world")
world <- ne_countries()
ggplot(world)+
  geom_sf()+
  geom_point(data = SRDB_filtered, aes(x=Longitude, y=Latitude, colour = MAT_wc), size = 1)+
  scale_color_viridis_c()
