#####

packages <- c("tidyr",
              "plyr",
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

#########
rolling_mean_time <- 5L # days
rolling_mean_time_new_dead <- 5L # days
recovery_time <- 14L # Days
#########