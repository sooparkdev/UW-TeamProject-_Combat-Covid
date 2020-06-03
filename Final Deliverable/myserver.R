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

server <- function(input, output) {
  
  # Server for Interactive Map
  output$usmap <- renderLeaflet({
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
    setView(lng = -98.5556199, lat = 39.8097343, zoom = 4) %>%
    addMarkers(
      lng = ~longitude, lat = ~latitude,
      popup = ~label,
    ) 
  })
  
  # Server for the Bar Graph
  output$bar <- renderPlotly({
    # compares to find out in what 'age group' the user inputted 'age' falls under
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
    
    if(input$sex == 1) {
      input_sex = "Male"
    } else {
      input_sex = "Female"
    }
    
    df_for_age_sex <- health_df %>%
      # leaves only the rows with user inputted 'age' and 'sex'
      filter(Age.group == age_group) %>%
      filter(Sex == input_sex) %>%  
      # filters the dataframe so that only the relevant information is left
      filter(State == "United States") %>%
      select(COVID.19.Deaths, Pneumonia.Deaths, Influenza.Deaths)
    
    # reorganizes the dataframe to plot the bar graph
    df_for_plot <- gather (
      df_for_age_sex,
      key = causes,
      value = num_of_death
    )
    
    bar_graph <- ggplot(data = df_for_plot) +
      geom_col(mapping = aes(x = causes, y = num_of_death)) +
      labs(
        title = "Top Cause of Death by Age Group and Sex",
        x = "Causes",
        y = "Number of Death"
      )
    
    # creates the interactive version of the bar graph
    ggplotly(bar_graph)
  })
  
  # Filtering the Data Frame for the Table Server
  percentages_df <- health_df %>%
    mutate(Covid_percent = round((COVID.19.Deaths /
                                    Total.Deaths) * 100, digits = 2),
           Pneunomia_percent = round((Pneumonia.Deaths /
                                        Total.Deaths) * 100, digits = 2),
           Influenza_percent = round((Influenza.Deaths /
                                        Total.Deaths) * 100, digits = 2)) %>%
    select(State, Covid_percent,
           Pneunomia_percent,
           Influenza_percent,
           Total.Deaths) %>%
    group_by(State) %>%
    summarise(Covid_death_percentage = max(Covid_percent),
              Pneumonia_death_percentage = max(Pneunomia_percent),
              Influenza_death_percentage = max(Influenza_percent),
              Total_deaths = max(Total.Deaths)) %>%
    filter(!is.na(Covid_death_percentage),
           !is.na(Influenza_death_percentage),
           !is.na(Pneumonia_death_percentage),
           State != "United States")
  
  col_names <- c("State", "Covid Death Percentage", "Pneumonia Death Percentage",
                 "Influenza Death Percentage", "Total Deaths (inluding other causes)")
  
  # Server for the Table
    percentages2 = percentages_df[sample(nrow(percentages_df), 50), ]
    output$mytable <- DT::renderDataTable({
      DT::datatable(percentages2,
                    class = 'cell-border stripe', colnames = col_names,
                    caption = "This table reveals the percentages of
                    deaths that are related to these causes. It also includes
                    the total number of deaths as a comparison",
                    options = list(lengthMenu = c(10, 25, 50)))
    })
}
  