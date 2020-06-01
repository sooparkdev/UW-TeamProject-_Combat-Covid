suppressPackageStartupMessages(library("dplyr"))

# Returns a list with summary information
get_summary_info <- function(dataset) {
  ret <- list()
  ret$length <- length(dataset)
  # Percentage of deaths in the US caused by COVID 19
  covid_deaths <- dataset %>%
    filter(Sex == "All Sexes Total") %>%
    pull(COVID.19.Deaths)
  total_deaths <- dataset %>%
    filter(Sex == "All Sexes Total") %>%
    pull(Total.Deaths)
  covid_death_percentage <- round(covid_deaths / total_deaths * 100,
    digits = 2
  )
  # Age group with most COVID 19 deaths
  age_most_affected <- dataset %>%
    filter(State == "United States") %>%
    filter(Age.group != "All ages") %>%
    filter(Sex == "All Sexes") %>%
    filter(COVID.19.Deaths == max(COVID.19.Deaths, na.rm = TRUE)) %>%
    pull(Age.group)
  # Number of deaths caused by COVID 19 in Washington
  wa_covid_deaths <- dataset %>%
    filter(State == "Washington Total") %>%
    filter(Sex == "All sexes") %>%
    pull(COVID.19.Deaths)
  # State with most COVID 19 deaths
  deadliest_covid_state <- dataset %>%
    filter(State != "United States" & State != "United States Total") %>%
    filter(COVID.19.Deaths == max(COVID.19.Deaths, na.rm = TRUE)) %>%
    pull(State)
  # State with most total deaths
  deadliest_state <- dataset %>%
    filter(State != "United States" & State != "United States Total") %>%
    filter(Total.Deaths == max(Total.Deaths, na.rm = TRUE)) %>%
    pull(State)
  ret <- list(
    deadliest_covid_state, deadliest_state, wa_covid_deaths,
    age_most_affected, covid_death_percentage
  )
  return(ret)
}
