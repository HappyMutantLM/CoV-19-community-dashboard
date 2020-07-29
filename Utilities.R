`%notin%` <- Negate(`%in%`)

str_ext_rm <- function(df, from, to, pattern) {
  df$to <-  str_extract(string = from, pattern = pattern)
  df$from <- str_remove(string = from, pattern = pattern)
  return(df)
}