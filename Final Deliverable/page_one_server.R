library("shiny")
library("ggplot2")
library("plotly")
library("stringr")
library("dplyr")
library("tidyr")
library("leaflet")

health_df <- read.csv("data/us-deaths.csv", stringsAsFactors = FALSE)
us_coords <- read.csv("data/orgState.csv", stringsAsFactors = FALSE)

# Filter rows with only the state total
state_tot_df <- health_df %>%
  filter(str_detect(State, "Total$")) %>%
  filter(!str_detect(State, "New York City")) %>%
  filter(!str_detect(State, "Puerto Rico"))

# Get rid of the US total
filtered_df <- state_tot_df[-1, ]

# Merge dataframe with coordinates
df_for_map <- cbind(filtered_df, Latitude = us_coords$Latitude, Longitude = us_coords$Longitude)

server_page_one <- function(input, output) {
  
  output$usmap <- renderLeaflet({
  
  #Server for Interactive Map
  state_of_interest <- df_for_map %>%
  filter(df_for_map$State == input$state)
  
  locations <- data.frame(
    label = paste(
      "Covid-19 Deaths:", state_of_interest$COVID.19.Deaths, "<br>",
      "Pneumonia Deaths:", state_of_interest$Pneumonia.Deaths, "<br>",
      "Influenza Deaths:", state_of_interest$Influenza.Deaths, "<br>",
      "Total Deaths (includes other causes):", state_of_interest$Total.Deaths
    ),
    latitude = state_of_interest$Latitude,
    longitude = state_of_interest$Longitude
  )
  
  map <- leaflet(data = locations) %>%
    addTiles() %>%
    #addProviderTiles("CartoDB.Positron") %>%
    setView(lng = -98.5556199, lat = 39.8097343, zoom = 4) %>%
    # addCircles(
    #   lat = ~latitude,
    #   lng = ~longitude,
    #   popup = ~label,
    #   radius = ~ 50000,
    #   stroke = FALSE,
    #   opacity = 0.8,
    # ) 
    addMarkers(
      lng = ~longitude, lat = ~latitude,
      popup = ~label,
      #label = ~label
      #labelOptions
      
      
    ) 
  
  })
  
}