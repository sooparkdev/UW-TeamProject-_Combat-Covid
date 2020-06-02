library("shiny")

#load the ui and server
source("page_one_server.R")
source("page_one_ui.R")


#shinyApp(ui = ui, server = server)
shinyApp(ui = ui_page_one, server = server_page_one)
#shinyApp(ui = ui_page_one, server = server_page_one)
#shinyApp(ui = ui_page_one, server = server_page_one)

