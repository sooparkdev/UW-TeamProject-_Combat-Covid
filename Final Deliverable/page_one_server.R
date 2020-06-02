library("shiny")
library("ggplot2")
library("plotly")
library("stringr")
library("dplyr")
library("tidyr")
library("leaflet")

health_df <- read.csv("data/us-deaths.csv", stringsAsFactors = FALSE)
#us_coords <- read.csv("data/State.csv", stringsAsFactors = FALSE)
us_coords <- read.csv("data/orgState.csv", stringsAsFactors = FALSE)


# Filter rows with only the state total
extra_clean <- health_df %>%
  filter(str_detect(State, "Total$")) %>%
  filter(!str_detect(State, "New York City")) %>%
  filter(!str_detect(State, "Puerto Rico"))

# Get rid of the US total
Use_this <- extra_clean[-1, ]

# Merge dataframe with coordinates
df_coords <- cbind(Use_this, Latitude = us_coords$Latitude, Longitude = us_coords$Longitude)

server_page_one <- function(input, output) {
  
  #Server for Interactive Map
  #filter(df_coords$State == input$state)
  
  
  output$usmap <- renderLeaflet({
  locations <- data.frame(
    label = paste(
      "Covid-19 deaths:", df_coords$COVID.19.Deaths, "<br>",
      "Pneumonia deaths:", df_coords$Pneumonia.Deaths, "<br>",
      "Influenza deaths:", df_coords$Influenza.Deaths, "<br>",
      "Total deaths (includes other causes):", df_coords$Total.Deaths
    ),
    latitude = df_coords$Latitude,
    longitude = df_coords$Longitude
  )
  
  map <- leaflet(data = locations) %>%
    addProviderTiles("CartoDB.Positron") %>%
    setView(lng = -98.5556199, lat = 39.8097343, zoom = 4) %>%
    addPolygons()
  })
  
  # bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
  # pal <- colorBin("YlOrRd", domain = states$density, bins = bins)
  # 
  # map %>% addPolygons(
  #   fillColor = ~pal(density),
  #   weight = 2,
  #   opacity = 1,
  #   color = "white",
  #   dashArray = "3",
  #   fillOpacity = 0.7)
  
}