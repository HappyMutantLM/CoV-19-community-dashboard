
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