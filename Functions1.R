
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
# and send to global environment.
JHU_data_date <<- format(max(as_date(US_cases_all$Date, format = "%m/%d/%y")), "%B %d, %Y") 

return(US_cases_all)
}

build_USA_VHA_JHU_data <- function(){
USA_FIPS_data = read_csv(file = "data/VHA_FIPS_20170920.csv") %>%
  select(State, County, FIPS, VISN, Market = `Market Description`, Network = `VISN Description`) %>%
  mutate(Market = str_remove(Market, "^.{4}"))  %>% # Remove the first 4 characters
  mutate(Market = str_replace_all(Market, "_", " ")) %>%
  mutate(Network = str_remove(Network, "^VA "))  %>% # Drop leading "VA "
  mutate(State = str_to_title(State)) %>%
  mutate(State =ifelse(grepl(paste(non_state, collapse = "|"), State), NA, State)) %>%  # Drop non-states. The paste() function creates a RegEx of values separated by '|'.
  drop_na()

JHU_data = import_JHU_data() %>%
  select(-State, -County) %>%
  filter(Cases > 0) %>%
  right_join(y = USA_FIPS_data, by = "FIPS")
return(JHU_data)
}

build_USA_VHA_TCP_data <- function() {
  
  ## Query the COVID Project API and download state-level data
  download.file(COVID_project_URL , "data/COVID_project_data.csv")
  COVID_project_data <- read_csv(file = "data/COVID_project_data.csv")
  
  ## Select relevant columns
  USA_VHA_TCP_data <- COVID_project_data %>%
    select(
      date,
      state,
      hospitalizedCurrently,
      hospitalizedIncrease,
      inIcuCurrently,
      onVentilatorCurrently
    ) %>% 
    mutate(date = as.Date(as.character(date), "%Y%m%d"))  %>%
    mutate(state = str_replace_all(state, state, state.name)) 

  return(USA_VHA_TCP_data)
}

merge_census <- function(data, geography) {
  ## Taking the input value of "state" or "county" adds a column "Census"
  ## to the supplied data frame. County data is joined by state and county while
  ## state data is joined by state name.
  ##
  census_data <-
    read.csv(file = "data/US_counties_2019_census.csv") %>%
    mutate(
      State = str_extract(County_State, ",.*"),
      County_State = str_remove(County_State, ",.*"),
      County_State = str_remove(County_State, "\\."),
      State = str_remove(State, ","),
      State = str_trim(State, side = "both"),
      County_State = str_remove(County_State, paste(county_types, collapse = "|")),
      County_State = str_trim(County_State, side = "both")
    ) %>%
    select(State, County = County_State, Census) %>%
    mutate(Census = str_remove_all(Census, ","),
           Census = as.numeric(Census))
  
  if (geography == "county") {
    df <-  left_join(data, census_data, by = c("State", "County"))
  }     else {
    census_data <- census_data %>%
      group_by(State) %>%
      summarise(Census = sum(Census))
    df <- left_join(data, census_data, by = c("state" = "State"))
  }
  return(df)
}


