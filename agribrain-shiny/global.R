## upload button
library(shiny)
library(shinyjs)
library(readr)
library(lubridate)
library(magrittr)
library(leaflet)
library(rtide)
library(DT)
library(dygraphs)
library(shinyBS)

source('functions.R', local = TRUE)
# Modules ====
source('modules/about-server.R', local = TRUE)
source('modules/about-ui.R', local = TRUE)
source('modules/map-server.R', local = TRUE)
source('modules/map-ui.R', local = TRUE)

# ui vars  ====
proj.description <- "Display soil moisture streamed from IOT devices."
proj <- "AGRIBRAIN"

mapbox_moon <- "https://api.mapbox.com/styles/v1/sebpoisson/cjjfvxsqh1nrd2rnqabh10sx4/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1Ijoic2VicG9pc3NvbiIsImEiOiJjamk1YXBiYm4waHd0M2twNmM3ODRuZjN4In0.WKHsGJ3K7SWyqO4lObCkfA
"
disclaimer <- ""

initial_lat <- 0.468155
initial_long <- 32.611484
initial_zoom <- 16
click_zoom <- 11
leaf.pos <- "topright"
sidepanel.width <- 400

palette <- c('#07A8FF', "#FFBA00", "#FF3900")
shades <- c("#4EC0FD", "#1FB1FF", "#0091DF", "00649A")
marker <- makeIcon(
  iconUrl = "input/marker.png",
  iconWidth = 30, iconHeight = 30
)
sites <- readRDS('input/sites.rds')
appCSS <- ".mandatory_star { color: red; }"







