library("shiny")

# makes UI page for table
page_three <- tabPanel("Table",
    mainPanel(
      h2("Death Percentages per State"),
      DT::dataTableOutput("mytable")
    )
)



