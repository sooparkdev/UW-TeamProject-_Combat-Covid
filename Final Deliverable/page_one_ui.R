State <- select(df_coords, State)

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
      leafletOutput(outputId = "usmap", height = 650, width = 910)
    ),
    position = "left",
    fluid = TRUE
  )
)

ui_page_one <- navbarPage (
  h2("COVID somethin"), #rename these
  page_one
)