
ui_page_three <- fluidPage(
  title = "Death Percentages per State",
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "percentages_df"',
        checkboxGroupInput("checkboxID", "Columns in df to show:",
                           names(percentages_df),
                           selected = names(percentages_df))
      ),
    ),
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("Death Percentages per State",
                 DT::dataTableOutput("mytable"))
      )
    )
  )
)
