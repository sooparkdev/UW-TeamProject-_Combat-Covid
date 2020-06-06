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
                    options = list(lengthMenu = c(10, 25, 50)))
    })
    
    # creates bar chart filtering by age group, covid deaths, gender, and state
    filtered_df <- health_df %>%
      filter(Age.group != "All Ages") %>%
      filter(Age.group != "All ages") %>%
      filter(Age.group != "Male, all ages") %>%
      filter(Age.group != "Female, all ages") %>%
      filter(Sex == "All Sexes")

    output$agebar <- renderPlot({
        age_bar_graph <- ggplot(filtered_df, aes(x = Age.group, y = COVID.19.Deaths)) +
          geom_bar(stat = "identity", width = .75) +
          coord_flip() +
          labs(
            title = "Occurence of COVID 19 Death by Age Group",
            x = "Age Group",
            y = "Covid 19 Deaths"
          )
        return(age_bar_graph)
      })
    
    state_df <- health_df %>%
      group_by(State) %>%
      # filters redundant information
      filter(Age.group == "All Ages") %>%
      filter(State != "United States") %>%
      filter(State != "United States Total") %>%
      summarize(
        covid_death = sum(COVID.19.Deaths, na.rm = TRUE)
      ) %>%
      # arranges the dataframe in a descending order
      arrange(-covid_death) %>%
      # leaves only ten rows with the highest covid deaths
      head(10)
    
    output$stategraph <- renderPlot({
      pie_chart <- ggplot(data = state_df,
                          aes(x = "", y = covid_death, color = State, fill = State)) +
        geom_bar(stat = "identity", width = 1, color = "white") +
        coord_polar("y", start = 0) +
        # gets rid of unnecessary factors in the plot
        ggtitle("Top 10 States with Highest COVID19 Deaths") +
        theme(panel.background = element_blank(),
              axis.line = element_blank(),
              axis.text = element_blank(),
              axis.ticks = element_blank(),
              axis.title = element_blank(),
        ) +
        geom_text(aes(label = paste0(covid_death)),
                  position = position_stack(vjust = 0.5), hjust = 0.5,
                  color = "white", size = 2.8)
      return(pie_chart)
    })
    
    sex_df <- health_df %>%
      filter(State == "United States") %>%
      filter(Sex == "Male Total" | Sex == "Female Total") %>%
      group_by(Sex) %>%
      mutate(tot_death = sum(COVID.19.Deaths) + sum(Pneumonia.Deaths) + sum(Influenza.Deaths)) %>%
      select(Sex, tot_death) %>%
      mutate(all_gender = "Gender") 
    
    output$sexchart <- renderPlot({
      ggplot(sex_df, aes(fill = Sex, x = all_gender, y = tot_death)) +
        geom_bar(position = "dodge", stat = "identity") +
        labs(
          title = "Total Death Rates by Sex",
          x = "Gender",
          y = "Total Deaths"
        )
    })
}

  