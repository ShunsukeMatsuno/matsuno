#' For a dataframe, check if a unique key is actually unique.
#' Typically the data frame is a panel data and the identifier is `(year, id)`, but this works for other general cases as well
#' 
#' 
#' @param df A data frame
#' @param key Key to check, e.g., "id", c("id", "year")
#'
#' @example examples/check_key_example.R 
#' 
#' @export

check_key <- function(df, key){
  # In messages, {key} is replaced by the input key.
  # For example, for check_key(df, c("id", "t")), the message should display 
  # "key (id, t) is unique" etc.
  
  # Check if key is string or a vector of strings
  if (!is.character(key)) {
    stop(paste("The key (", paste(key, collapse = ", "), ") must be a string or a vector of strings", sep = ""))
  }
  
  # Check if the key is a subset of the column names of the dataframe
  if (!all(key %in% names(df))) {
    stop(paste("The key (", paste(key, collapse = ", "), ") must be a subset of the column names of the dataframe", sep = ""))
  }
  
  # Check if the key has at least one element
  if (length(key) == 0) {
    stop(paste("The key (", paste(key, collapse = ", "), ") must have at least one element", sep = ""))
  }
  
  # Check if the key is unique
  df_duplicates <- df |> 
    dplyr::group_by(across(all_of(key))) |> 
    dplyr::summarize(n = dplyr::n(), .groups = "drop") |>
    dplyr::filter(n > 1) 
  
  if (NROW(df_duplicates) == 0) {
    message(paste("The key (", paste(key, collapse = ", "), ") is unique", sep = ""))
  } else {
    message(paste("The key (", paste(key, collapse = ", "), ") is not unique. Here are the duplicates:", sep = ""))
    return(df_duplicates)
  }
}
