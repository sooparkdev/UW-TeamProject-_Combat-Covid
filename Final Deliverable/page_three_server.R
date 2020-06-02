health_df <- read.csv("data/us-deaths.csv", stringsAsFactors = FALSE)

percentages_df <- health_df %>%
  mutate(Covid_percent = round((COVID.19.Deaths /
                                  Total.Deaths) * 100, digits = 2), 
         Pneunomia_percent = round((Pneumonia.Deaths /
                                      Total.Deaths) * 100, digits = 2),
         Influenza_percent = round((Influenza.Deaths /
                                      Total.Deaths) * 100, digits = 2)) %>%
  select(State, Covid_percent,
         Pneunomia_percent,
         Influenza_percent) %>%
  group_by(State) %>%
  summarise(Covid_death_percentage = max(Covid_percent),
            Pneumonia_death_percentage = max(Pneunomia_percent),
            Influenza_death_percentage = max(Influenza_percent)) %>%
  filter(!is.na(Covid_death_percentage), 
         !is.na(Influenza_death_percentage), 
         !is.na(Pneumonia_death_percentage)) %>%
  arrange(Covid_death_percentage)

server_page_three <- function(input, output) {
  percentages2 = percentages_df[sample(nrow(percentages_df), 10), ]
  output$mytable <- DT::renderDataTable({
    DT::datatable(percentages2[, input$checkboxID, drop = FALSE])
  })
}