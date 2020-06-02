library("shiny")
library("ggplot2")
library("plotly")
library("stringr")
library("dplyr")
library("tidyr")
library("leaflet")

health_df <- read.csv("data/us-deaths.csv", stringsAsFactors = FALSE) #do you load this inside or outside the function
us_coords <- read.csv("data/orgState.csv", stringsAsFactors = FALSE)

# bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
# pal <- colorBin("YlOrRd", domain = states$density, bins = bins)
# 
# m <- leaflet(states) %>%
#   setView(-96, 37.8, 4) %>%
#   addProviderTiles("MapBox", options = providerTileOptions(
#     id = "mapbox.light",
#     accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')))
# 
# m %>% addPolygons(
#   fillColor = ~pal(density),
#   weight = 2,
#   opacity = 1,
#   color = "white",
#   dashArray = "3",
#   fillOpacity = 0.7)







server <- function(input, output) {
  
  #Server for Interactive Map
  filter(_coords$State == input$state) 

  output$usmap <- renderLeaflet({
    locations <- data.frame(
      label = paste(
        "Covid-19 deaths:", df_coords$COVID.19.Deaths, "<br>",
        "Pneumonia deaths:", df_coords$Pneumonia.Deaths, "<br>",
        "Influenza deaths:", df_coords$Influenza.Deaths, "<br>",
        "Total deaths (includes other causes):", df_coords$Total.Deaths
      ),
      latitude = df_coords$Latitude,
      longitude = df_coords$Longitude,
    )
    
    map <- leaflet(data = locations) %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(lng = -98.5556199, lat = 39.8097343, zoom = 4) %>%
    return(map)
  })
  
  #Server for Bar Graph
  output$bar <- renderPlotly({
    if(input$age > 84) {
      age_group = "85 years and over"
    } else if (input$age > 74) {
      age_group = "75-84 years"
    } else if (input$age > 64) {
      age_group = "65-74 years"
    } else if (input$age > 54) {
      age_group = "55-64 years"
    } else if (input$age > 44){
      age_group = "45-54 years"
    } else if (input$age > 34){
      age_group = "35-44 years"
    } else if (input$age > 24){
      age_group = "25-34 years"
    } else if (input$age > 14){
      age_group = "15-24 years"
    } else if (input$age > 4){
      age_group = "5-14 years"
    } else {
      age_group = "1-4 years"
    }
    df_for_age_sex <- health_df %>%
    filter(Age.group == age_group) %>%
    filter(Sex == input$sex) %>%
    filter(State == "United States") %>%
    select(COVID.19.Deaths, Pneumonia.Deaths, Influenza.Deaths)
    
    df_for_plot <- gather (
      df_for_age_sex,
      key = causes,
      value = num_of_death,
    )
  
    bar_graph <- ggplot(data = df_for_plot) +
      geom_col(mapping = aes(x = causes, y = num_of_death)) +
      labs(
        title = "Top Cause of Death by Age Group and Sex",
        x = "Causes",
        y = "Number of Death"
      )
    return(ggplotly(bar_graph))
  })
}



