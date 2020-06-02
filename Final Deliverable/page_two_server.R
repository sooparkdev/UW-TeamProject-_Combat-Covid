#Server for Bar Graph
library("ggplot2")
library("plotly")
library("dplyr")


server_page_two <- function(input, output) {
  output$bar <- renderPlotly({
    health_df <- read.csv("data/us-deaths.csv", stringsAsFactors = FALSE) # do i have load it inside? asking this not in terms of style
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
      filter(Sex == input_sex) %>%  ##########input$sex
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
      geom_col(mapping = aes(x = reorder(causes, -num_of_death), y = num_of_death)) +
      labs(
        title = "Top Cause of Death by Age Group and Sex",
        x = "Causes",
        y = "Number of Death"
      )
    bar_graph
    ggplotly(bar_graph)
  })

}





