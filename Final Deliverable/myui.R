library("shiny")
library("ggplot2")
library("stringr")
library("dplyr")
library("leaflet")
library("plotly")
library("shinydashboard")
source("page_one_ui.R")
source("page_two_ui.R")
source("page_three_ui.R")

header <- dashboardHeader(title = strong("Death Rates"), titleWidth = 250)

sidebar <- dashboardSidebar(
  width = 250,
  sidebarMenu(
    menuItem("Main Page", tabName = "main", icon = icon("home")),
    menuItem("US Map", tabName = "map", icon = icon("map")),
    menuItem("Bar Graph", tabName = "bars", icon = icon("chart-bar")),
    menuItem("Table", tabName = "table", icon = icon("table")),
    menuItem("Summary Info", tabName = "sum", icon = icon("info"))
  )
)


body <- dashboardBody(
  tags$head(tags$style(HTML('
                                /* logo */
                                .skin-blue .main-header .logo {
                                background-color: #EE6C4D;
                                }

                                /* logo when hovered */
                                .skin-blue .main-header .logo:hover {
                                background-color: #EE6C4D;
                                }

                                /* navbar (rest of the header) */
                                .skin-blue .main-header .navbar {
                                background-color: #EE6C4D;
                                }

                                /* main sidebar */
                                .skin-blue .main-sidebar {
                                background-color: #3D5A80;
                                }

                                /* active selected tab in the sidebarmenu */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                                background-color: #98C1D9;
                                }

                                /* other links in the sidebarmenu */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu a{
                                background-color: #3D5A80;
                                color: #FFFFFF;
                                }

                                /* other links in the sidebarmenu when hovered */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu a:hover{
                                background-color: #293241;
                                }
                                /* toggle button when hovered  */
                                .skin-blue .main-header .navbar .sidebar-toggle:hover{
                                background-color: #293241;
                                }

                                /* body */
                                .content-wrapper, .right-side {
                                background-color: #98C1D9;
                                }
                                
                                /* scroll body color */
                                .skin-blue .left-side, .skin-blue .wrapper {
                                background-color: #98C1D9;
                                }

                                '))),
  tabItems(
    tabItem(tabName = "main",
            img(src = "home-banner.jpg", align = "middle", height = "100%", width = "100%"),
            p("\n"),
            box(width = 12, title = strong("Overview"), p("The Coronavirus quickly became
            a growing cause of concern due to its rapid spread and ability
            to harm susceptible groups. The uncertainty surrounding this
            novel virus has led individuals to compare COVID-19 to similar
            illnesses such as the flu and pneumonia. While this comparison
            may not be accurate for determining the behavior and impact of
            the virus in the future, it can be useful in order to examine patterns.")),
            box(title = strong("Data"), p("We collected a dataset from the",
                                          tags$a(href="https://data.cdc.gov/NCHS/
                                                 Provisional-COVID-19-Death-Counts-by-Sex-Age-and-S/9bhg-hcku?
                                                 fbclid=IwAR2eaiTZ1LfuFQQ5EiJ8o1_a8r9zco3BbLfEzJ-rfLiYjMOQX1OwYZ4OCTo",
                                                 "Centers for Disease Control"),
                                          "which contains data about COVID-19, Influenza, and
                  Pneumonia deaths by age, sex, and gender. Furthermore, this data
                                          is up to date as of May 2020, which makes it
                                          more valuable as users are able to see
                                          how these causes of death impacts different age groups, sex,
                                          and its specific locations.")),
            box(title = strong("Goal"), p("We will aim to uncover who is at most risk of death
                  by each illness by looking at specific age groups and sex. Additionally, we will further examine
                  which regions have been most affected by COVID-19 specifically,
                  in order to make conclusions about which regions
                  might need additional help."))
    ),
    tabItem(tabName = "map", h2("Interactive Map: Occurences per State"),
                    box(width = 12, p("This interactive map displays occurences of death for different
                    causes depending on the given state of reader's interest. It lets
                    the reader compare the occurences for different states, and therby
                    identify ones being most affected by different causes, especially
                    the COVID-19 at this point in time. Allows readers to draw conclusions
                    about the deadliness of each illness in each state.")), page_one),
    tabItem(tabName = "bars",h2("Bar Graph: Causes by Age and Sex"), box(width = 12, p("The bar graph
                    successfully renders a chart that represents the Covid-19 Deaths,
                    Influenza Deaths, and Pneumonia Deaths based on what the user inputs
                    for the Sex and Age. User has the option to choose Sex from radio buttons
                    and Age from a slider input. The graph will illustrate three bar graphs that
                    show the specific number of deaths for each causes of death that matches
                    with what they input for their sex and age. Any combination of sex and age
                    will appropriately render the chart. It allows the users to see which age group
                    and sex is more susceptible to which disease")), page_two),
    tabItem(tabName = "table", h2("Death Percentages per State"),
                    box(width = 8, p("This table reveals the death percentages of
                    Covid-19, Influenza, and Pneumonia. It also includes
                    the total number of deaths as a comparison. This
                    chart aims to reveal the ratios of causes of deaths
                    in each state. These percentages aids in visualising the
                    severity of these illnesses. This table can be used to
                    easily view information regarding which type of death
                                      is highest and where")), page_three),
    tabItem(tabName = "sum", h2("Our Insights"))
  )
)
ui <- dashboardPage (
  header,
  sidebar,
  body
)
