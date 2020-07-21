#####

packages <- c("tidyr",
         #     "plyr",
              "dplyr",
              "readr",
              "stringr",
              "scales",
              "lubridate",
              "ggplot2",
              "cowplot",
              "zoo"
              
)
sapply(packages, library, character.only = TRUE)

US_cases_confirmed_URL <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv"
US_cases_deceased_URL <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv"
COVID_project_URL <- "https://covidtracking.com/api/v1/states/daily.csv"
#########
rolling_mean_time <- 5L # days
rolling_mean_time_new_dead <- 5L # days
recovery_time <- 14L # Days
VISN <- 9
#########

non_state <- c("Guam", "Samoa", "Micronesia", "Islands", "Philippines",
               "Palau", "Overseas", "Puerto"
               )




