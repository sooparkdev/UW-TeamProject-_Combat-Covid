library("shiny")

#load the ui and server
source("page_one_server.R")
source("page_one_ui.R")

source("page_three_server.R")
source("page_three_ui.R")

#shinyApp(ui = ui, server = server)
#shinyApp(ui = ui_page_one, server = server_page_one)
#shinyApp(ui = ui_page_two, server = server_page_two)
shinyApp(ui = ui_page_three, server = server_page_three)

