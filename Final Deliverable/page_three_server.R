library("dplyr")
library("shiny")

health_df <- read.csv("data/us-deaths.csv", stringsAsFactors = FALSE)

# makes a dataframe that only includes states
# and death percentages for the table
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

col_names <- c("State", "Covid Death Percentage", "Pneumonia Death Percentage", "Influenza Death Percentage", "Total Deaths (inluding other causes)")
# makes a server for the table
# takes in 
server_page_three <- function(input, output) {
  percentages2 = percentages_df[sample(nrow(percentages_df), 50), ]
  output$mytable <- DT::renderDataTable({
    DT::datatable(percentages2[, input$variables, drop = FALSE],
                  class = 'cell-border stripe', colnames = col_names,
                  caption = "This table reveals the percentages of
                  deaths that are related to these causes. It also includes
                  the total number of deaths as a comparison")
  })
}
