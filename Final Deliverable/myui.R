library("shiny")
library("ggplot2")
library("stringr")
library("dplyr")

# Load the dataframe
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

# Dataframe with only the 'State' column
State <- select(df_coords, State)

# basic UI outline


#Interactive Map
page_one <- tabPanel(
  sidebarLayout(

    # User input of the states
    sidebarPanel(
      selectInput(
        inputId = "state",
        label = h2("Select the State of Your Interest"),
        choices = State
      )
    ),
    
    #Output of the interactive map
    mainPanel(
      leafletOutput(outputId = "usmap")
    ),
    position = "left",
    fluid = TRUE
  )
)

# page_two <- tabPanel(
#   "Bar Graph",
#   sidebarLayout(
#     
#     #User select Sex
#     radioButtons(
#       inputId = "sex",
#       label = h3("Sex"),
#       choices = list("Male" = Male, "Female" = Female),
#       selected = Male
#     ),
#     
#     # User select Age
#     sliderInput(
#       inputId = "age",
#       label = h3("Age"),
#       min = 1,
#       max = 100,
#       value = 42   # is the default increment by 1?
#     ),
#     
#     # Ouput of the Bar graph
#     mainPanel(
#       plotlyOutput(outputId = "bar")
#     )
#   )
# )

ui <- navbarPage (
  h2("COVID somethin"), #rename these
  page_one
  #page_two,
  #page_three
)

  
  
  
  
   