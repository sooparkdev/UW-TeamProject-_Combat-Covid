library("shiny")

# makes UI page for table
ui_page_three <- fluidPage(
  title = "Death Percentages per State",
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "percentages_df"',
        checkboxGroupInput("variables", "Columns in df to show:",
                           choices = colnames(percentages_df),
                           selected = colnames(percentages_df))
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
