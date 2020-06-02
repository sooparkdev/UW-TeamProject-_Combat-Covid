library("shiny")

# makes UI page for table
ui_page_three <- fluidPage(
  title = "Death Percentages per State",
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("Death Percentages per State",
                 DT::dataTableOutput("mytable"))
      ),
      
      )
    )



