# Creates an interactive Table
page_three <- tabPanel("Table",
    mainPanel(
      DT::dataTableOutput("mytable")
    )
)
