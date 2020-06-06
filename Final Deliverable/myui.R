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

health_df <- read.csv("data/us-deaths.csv", stringsAsFactors = FALSE)

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
    tabItem(tabName = "sum", h1("Our Insights"),
            fluidRow(h3("Which age groups are most and least at risk of death from COVID-19?"),
            box(p("\n", plotOutput("agebar", height = 200, width = 500)), width = 6),
            box(p("\n","Based on our data, we found that the risk of death from
              contracting the coronavirus increased with age. Our highest
              death rates occurred among individuals above the age of 85 years
              old and our lowest death rates occurred among individuals that were
              under 1 year old and toddlers among the ages of 1-4. While the 85
              year old and over age group is leading in death rates, we saw a
              drastic death elevation after individuals reached 55 years old.
              These numbers support the conclusion that increasing age certainly
              drives death rates. On the other hand, we were able to see much
              lower death rates among people who were younger than 45."))),
            fluidRow(h3("Which regions of the United States were most affected by the COVID-19?"),
            box(plotOutput("stategraph", height = 400, width = 400)),
            box(p("\n","From the very beginning, we were interested in whether the
              geographical region was related to increased cases of COVID-19.
              Analyzing our data enabled us to see that Northeastern areas
              generated the highest number of COVID deaths with New York
              being the leading state. The broader implication of our graph
              tells us which states in the United States are being most
              impacted and in turn will provide the basis for further analysis
              that can answer why these states are most impacted and what
              measures they can take to decrease their infection and death tolls."))),
            fluidRow(h3("Does sex have any correlation to death rates among Covid-19, Pneumonia, and Influenza?"),
            box(p("\n", plotOutput("sexchart", height = 400, width = 200), width = 0.5)),
            box(p("\n","In our research, we wanted to see if the death caused by Covid-19,
              Pneumonia, or Influenza were influenced by sex. From our bar graph,
              we can see that there is a direct correlation between the death
              rates and sex. Disregardless of sex, pneumonia has always been
              the highest among the three groups. On average, men are more
              likely to contract Covid-19, which also means that the death
              rate is higher. In younger children, girls are more likely to
              contract Influenza, leading to a higher death rate. On the other
              hand, young boys are more likely to contract pneumonia, resulting
              in a higher death rate for pneumonia.  From these data, we were
              able to find that sex itself wasn’t a huge factor when it comes
              to people dying from certain illnesses. However, it is possible
              to see that certain sex groups had a higher tendency to have
              higher death rates in certain disease depending on their age
              group. This, of course, isn’t the only factor that comes with it.
              There are many other things these death rates depend on
              like location and current health status.")))
             )
            )
)
  
ui <- dashboardPage (
  header,
  sidebar,
  body
)
