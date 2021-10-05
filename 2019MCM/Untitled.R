library(readxl)
library(ggplot2)
library(dplyr)
library(maps)
library(ggmap)
library(mapproj)
library(RColorBrewer)
display.brewer.all() ;##显示所有调色板以供选择
cols <- brewer.pal(n=11,name="Spectral") ##设定颜色为set3调色板，n根据调色 板相应的改变



MCM_NFLIS_Data <- read_excel("Downloads/2019_MCM-ICM_Problems/2018_MCMProblemC_DATA/MCM_NFLIS_Data.xlsx", 
                             +     sheet = "Data")
Longi <- read_table2("Desktop/Longi.txt", 
                     +     col_names = FALSE, col_types = cols(X2 = col_double()))
View(Longi)
View(MCM_NFLIS_Data)
View(ACS_10_5YR_DP02_metadata)

summary(MCM_NFLIS_Data)
unique(MCM_NFLIS_Data$SubstanceName)
unique(MCM_NFLIS_Data$COUNTY)
unique(MCM_NFLIS_Data$State)

a=merge(MCM_NFLIS_Data,Longi,by.x = 'State', by.y = 'X1') 

# save api key
register_google(key = "YOUR_API_KEY")

ggmap(
  ggmap = get_map(
    "Dayton",
    zoom = 13, scale = "auto",
    maptype = "satellite",
    source = "google"),
  extent = "device",
  legend = "topright"
)
#> Source : https://maps.googleapis.com/maps/api/staticmap?center=Dayton&zoom=13&size=640x640&scale=2&maptype=satellite&language=en-EN&key=AIzaSyBmXB5S5_NIqo6lAGH-_U-TbhrQjhOsplU
#> Source : https://maps.googleapis.com/maps/api/geocode/json?address=Dayton&key=AIzaSyBmXB5S5_NIqo6lAGH-_U-TbhrQjhOsplU
map <- get_map(location = 'China', zoom = 4)
key<-"AIzaSyDn06hjcJEFz2HRfPI463e7oVIY5ZKGPss"
register_google(key = key)
showing_key()
map <- get_map(location = 'us', zoom = 4)xun


map('state', region = c('Ohio', 'Kentucky', 'West Virginia', 'Virginia', 'Tennessee'),
    fill = FALSE, mar = c(2, 3, 4, 3))
title("Map")

cols_x<-cols[1:40] ##设定颜色矩阵
map('state', region = c('Ohio', 'Kentucky', 'West Virginia', 'Virginia', 'Tennessee'),
    fill = TRUE, col = cols_x, mar = c(2, 3, 4, 3))
title("Map")




geocode("Ohio")









split(MCM_NFLIS_Data$SubstanceName,MCM_NFLIS_Data$YYYY)



qplot(yyyy, MCM_NFLIS_Data$State, data = MCM_NFLIS_Data, color = color)





library(rjson)
library(digest)
library(glue)
library(devtools)
if(!requireNamespace("devtools")) install.packages("devtools")
devtools::install_github("dkahle/ggmap", ref = "tidyup")
library(ggmap)

register_google(key = "AIzaSyDn06hjcJEFz2HRfPI463e7oVIY5ZKGPss",  # your Static Maps API key
                account_type = "standard")

map <- get_map(location = c(-75.1636077,39.9524175), zoom = 13)

ggmap(map)





