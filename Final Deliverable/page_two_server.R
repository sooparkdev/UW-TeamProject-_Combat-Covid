#Server for Bar Graph
library("ggplot2")
library("plotly")
library("dplyr")

health_df <- read.csv("data/us-deaths.csv", stringsAsFactors = FALSE)

page_two_server <- function(input, output) {
  output$bar <- renderPlot({
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
    
    
    
    
 
