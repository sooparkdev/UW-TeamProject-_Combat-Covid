library("shiny")

page_two_ui <- tabPanel(
     "Bar Graph",
     sidebarLayout(
       
       #User select Sex
       radioButtons(
         inputId = "sex",
         label = h3("Sex"),
         choices = list("Male" = 1, "Female" = 2),
         selected = 1
       ),
       
       # User select Age
       sliderInput(
         inputId = "age",
         label = h3("Age"),
         min = 1,
         max = 100,
         value = 42   # is the default increment by 1?
       ),
       
       # Ouput of the Bar graph
        mainPanel(
          plotlyOutput(outputId = "bar", width = "100%", height = "400px", inline = FALSE)
       )
     )
   )
  