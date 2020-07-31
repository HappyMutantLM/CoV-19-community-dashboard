#####

packages <- c("tidyr",
              "dplyr",
              "readr",
              "stringr",
              "scales",
              "lubridate",
              "ggplot2",
              "cowplot",
              "zoo",
              "kableExtra",
              "knitr"
              
)
sapply(packages, library, character.only = TRUE)

US_cases_confirmed_URL <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv"
US_cases_deceased_URL <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv"
 COVID_project_URL <- "https://covidtracking.com/api/v1/states/daily.csv"
########## current value.
rolling_mean_time <- 5L # days
rolling_mean_time_new_dead <- 5L # days
current_days <- 14L # Number of days to use when calculating 
recovery_time <- 14L # Days
selected_VISN <- "09"
#########
if (selected_VISN == "09") {VISN_primary_states <- c("Tennessee", "Kentucky")}

non_state <- c("Guam", "Samoa", "Micronesia", "Islands", "Philippines",
               "Palau", "Overseas", "Puerto"
               )

county_types <- c("County", "Parish", "Borough", "and Borough", "Census Area",
                  "Area", "City", "Municipality")

#state_name_abb <- sapply(1:50, function(x) paste(state.abb[x], "=", state.name[x]))
state_name_abb <- state.name
names(state_name_abb) <- state.abb

prevalence_current <- NA
prevalence_overall <- NA
hospitalization_rate_overall <- NA
hospitalization_rate_current <- NA
CFR_current <- NA
CFR_overall <- NA
ICU_current <- NA
ventilator_current <- NA
R0 <- NA
