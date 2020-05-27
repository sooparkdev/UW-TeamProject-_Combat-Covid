library("dplyr")
library("ggplot2")

# creates pie chart using the COVID.19.Deaths column in the dataframe passed in
# adds up the COVID 19 deaths by states and organize them in a descending order
create_pie_chart <- function(dataframe) {
  filtered_df <- health_data %>%
    group_by(State) %>%
    filter(Age.group == "All Ages") %>%
    filter(State != "United States") %>%
    filter(State != "United States Total") %>%
    summarize(
      covid_death = sum(COVID.19.Deaths, na.rm = TRUE)
    ) %>%
    arrange(-covid_death) %>%
    head(10)
  pie_chart <- ggplot(data = filtered_df,
              aes(x = "", y = covid_death, color = State, fill = State)) +
    geom_bar(stat = "identity", width = 1, color = "white") +
    coord_polar("y", start = 0) +
    ggtitle("Top 10 States with Highest COVID19 Deaths") +
    theme(panel.background = element_blank(),
          axis.line = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          axis.title = element_blank(),
    ) +
    geom_text(aes(label = paste0(covid_death)),
              position = position_stack(vjust = 0.5), hjust = 0.5,
              color = "white", size = 2.8)
  return(pie_chart)
}
