suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("tidyverse"))
suppressPackageStartupMessages(library("ggthemes"))

# creates bar chart filtering by age group, covid deaths, gender, and state
create_bar_chart <- function(dataframe) {
  filtered_df <- dataframe %>%
    select(Age.group, Sex, COVID.19.Deaths, State) %>%
    group_by(Sex) %>%
    filter(Sex %in% c("Male", "Female")) %>%
    filter(!is.na(COVID.19.Deaths)) %>%
    filter(State != c("United States"))
  graph <- ggplot(filtered_df,
                  aes(x = Age.group, y = COVID.19.Deaths, fill = Sex)) +
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