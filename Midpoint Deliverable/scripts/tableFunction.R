suppressPackageStartupMessages(library(dplyr))

health_data <- read.csv("data/us-deaths.csv"
                        , stringsAsFactors = FALSE)

get_table <- function(data) {
  dataset <- data %>%
    # makes new columns for %
    mutate(Covid_percent = round((COVID.19.Deaths /
                                    Total.Deaths) * 100, digits = 2),
           Pneunomia_percent = round((Pneumonia.Deaths /
                                        Total.Deaths) * 100, digits = 2),
           Influenza_percent = round((Influenza.Deaths /
                                        Total.Deaths) * 100, digits = 2)) %>%
    # leaves only these four columns
    select(State, Covid_percent,
           Pneunomia_percent, Influenza_percent) %>%
    group_by(State) %>%
    # leaves only the highest % of each state
    summarise(total_Covid_death_percentage = max(Covid_percent),
              total_Pneumonia_death_percentage = max(Pneunomia_percent),
              total_Influenza_death_percentage = max(Influenza_percent)) %>%
    # gets rid of na rows and United States row
    filter(!is.na(total_Covid_death_percentage),
           !is.na(total_Influenza_death_percentage),
           !is.na(total_Pneumonia_death_percentage), State != "United States") %>%
    # highest to lowest covid % and only top 11 values
    arrange(-total_Covid_death_percentage) %>%
    head(11)
  return(dataset)
}

health_table <- get_table(health_data)
