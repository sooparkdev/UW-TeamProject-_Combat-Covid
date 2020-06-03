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

# Dataframe with only the 'State' column
states <- select(df_for_map, State)

page_one <- tabPanel("Interactive Map",
  sidebarLayout(
    
    # User input of the states
    sidebarPanel(
      selectInput(
        inputId = "state",
        label = h2("Select the State of Your Interest"),
        choices = states
      )
    ),
    
    #Output of the interactive map
    mainPanel(
      leafletOutput(outputId = "usmap", height = 650, width = 800)
    )
  )
)