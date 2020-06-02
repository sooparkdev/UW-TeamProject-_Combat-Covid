
ui_page_three <- fluidPage(
  title = "Death Percentages per State",
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "function_trial2"',
        checkboxGroupInput("checkboxID", "Columns in df to show:",
                           names(function_trial2), selected = names(function_trial2))
      ),
    ),
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("otherID", DT::dataTableOutput("mytable"))
      )
    )
  )
)