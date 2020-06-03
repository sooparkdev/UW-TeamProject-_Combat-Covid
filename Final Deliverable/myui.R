library("shiny")
library("ggplot2")
library("stringr")
library("dplyr")
source("page_one_ui.R")
source("page_two_ui.R")
source("page_three_ui.R")

ui <- navbarPage (
  "US Death Exploration", 
  page_one,
  page_two,
  page_three
)

  
  
  
  
   