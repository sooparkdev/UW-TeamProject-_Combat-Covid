library("ggplot2")
library("dplyr")
library("tidyverse")
library("ggthemes")

# creates bar chart filtering by age group, covid deaths, gender, and state
create_bar_chart <- function(dataframe, col) {
  filtered_df <- dataframe %>%
    select(age_group, sex, covid_19_deaths, state) %>%
    group_by(sex) %>%
    filter(sex %in% c("Male", "Female")) %>%
    filter(!is.na(covid_19_deaths)) %>%
    filter(state != c("United States"))
  graph <- ggplot(filtered_df,
                  aes(x = age_group, y = covid_19_deaths, fill = sex)) +
    geom_bar(stat = "identity", width = .75) +
    coord_flip() +
    labs(
      title = "Population Pyramid for Covid-19 Deaths; Covid-19 Death Funnel",
      x = "Age Group",
      y = "Covid 19 Deaths"
    ) +
    theme_clean() +
    theme(plot.title = element_text(hjust = .5),
          axis.ticks = element_blank())
  return(graph)
}