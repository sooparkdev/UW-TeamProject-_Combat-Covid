
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
      leafletOutput(outputId = "usmap", height = 650, width = 910)
    )
  )
)

# ui_page_one <- navbarPage (
#   "US Death Exploration", 
#   page_one
# )