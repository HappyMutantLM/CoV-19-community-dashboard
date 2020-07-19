
import_JHU_data <- function() {
##### Import and clean JHU data #######

clean_JHU_data <- function(data, value) {
  clean_JHU_data <- data %>%
    select(State = Province_State,
           County = Admin2,
           FIPS,
           ends_with("20") # Select all date columns
    ) %>%
    filter(!is.na(County),
           !is.na(FIPS)
    ) %>%
    pivot_longer(cols = ends_with("20"),
                 names_to = "Date",
                 values_to = value
    )
  return(clean_JHU_data)
}

# Get JHU data sets, clean and initial processing
download.file(US_cases_confirmed_URL , "data/US_cases_confirmed.csv")
US_cases_confirmed <- read_csv(file = "data/US_cases_confirmed.csv")

download.file(US_cases_deceased_URL , "data/US_cases_deceased.csv")
US_cases_deceased <- read_csv(file = "data/US_cases_deceased.csv")

US_cases_confirmed <- clean_JHU_data(US_cases_confirmed, "Cases")
US_cases_deceased <- clean_JHU_data(US_cases_deceased, "Died")

US_cases_all <- full_join(US_cases_confirmed, US_cases_deceased) %>%
  mutate(Alive = Cases - Died,
         Date = as.Date(Date, "%m/%d/%y")
  ) %>%
  filter(Alive >= 0) %>% # Negative values occur in counties named "unassigned".
  mutate(FIPS = as.character(FIPS),
         # Add leading zero to 4 digit FIPS
         FIPS = if_else(nchar(FIPS) == 4, paste0("0", FIPS), FIPS)
  )
# Extract the date of the most recent data point to use as the data-set date
JHU_data_date <<- format(max(as_date(US_cases_all$Date, format = "%m/%d/%y")), "%B %d, %Y") 

return(US_cases_all)
}


