library("shiny")

#load the ui and server
source("myui.R")
source("myserver.R")

shinyApp(ui = ui, server = server)

