# Creates an interactive Bar Graph
page_two <- tabPanel("Bar Graph",
    sidebarLayout(

        sidebarPanel(

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
           value = 42
           )
        ),

       # Ouput of the Bar graph
        mainPanel(
          plotlyOutput(outputId = "bar")
       )
    )
)
