
ui <- navbarPage (
  h2("Title of our app"), #rename these
  page_one,
  page_two
)

page_one <- tabPanel(
  "Name the page",
  sidebarLayout()
)

page_two <- tabPanel(
  "Name the page",
)


  
  
  
  
  # radioButtons(
  #   inputId = "radio",
  #   label = h3("Sex"),
  #   choices = list("Male" = Male, "Female" = Female),
  #   #selected =1
  # )