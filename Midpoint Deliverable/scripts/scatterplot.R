install.packages("ggplot2")
install.packages("plotly")
install.packages("maps")
install.packages("leaflet")
library(ggplot2)
library(plotly)
library(dplyr)
library(maps)
library(leaflet)
library(knitr)
library(stringr)
library(lintr)

# The purpose of this scatterplot is to clearly visualize
# the amount of death caused by Pneumonia in each state.
# Organizes the state in Alphabetical order.

pneumonia_death_scatter_plot <- function(new_dataset_df, pneumonia_death) {
  filtered_df <- our_dataset_df %>%
    filter(str_detect(State, "Total$"))
  new_dataset_df <- filtered_df[-1, ]
  plot_graph <-
  ggplot(data = new_dataset_df, mapping =
           aes(x = State, y = Pneumonia.Deaths)) +
  theme(axis.text.x = element_text(size  = 7, angle = 90)) +
  labs(title = "Total Pneumonia Death by State",
       x = "State", y = "Pneumonia Deaths") +
  geom_point()
  return(plot_graph)
}
