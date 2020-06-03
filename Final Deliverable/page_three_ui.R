# makes UI page for table
page_three <- tabPanel("Table",
    mainPanel(
      DT::dataTableOutput("mytable")
    )
)



