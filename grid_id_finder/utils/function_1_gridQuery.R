#'//////////////////////////////////////////////////////////////////////////////
#' FILE: function_1_gridQuery.R
#' AUTHOR: David Ruvolo
#' CREATED: 15 May 2018
#' MODIFIED: 25 June 2018
#' PURPOSE: write a function that takes a query and returns a university
#' PACKAGES: tidyverse
#' STATUS: working; complete
#' COMMENTS:
#' HISTORY: 
#'    - 2018-05-25: Added filter for city
#'//////////////////////////////////////////////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)

# def
gridQuery <- function(filter_country = NULL, filter_city=NULL, query = NULL){
  
  # pkgs
  require(tidyverse)
  
  # transform inputs
  f_country <- ifelse(is.null(filter_country),NA,as.character(tolower(filter_country)))
  f_city <- ifelse(is.null(filter_city),NA,as.character(tolower(filter_city)))
  q <- ifelse(is.null(search),NA,as.character(tolower(query)))
  
  #'////////////////////////////////////////
  # Run query based on input combination
  
  # country:exists  +  city:exists  +  phrase:exists
  if(!is.na(f_country) & !is.na(f_city) & !is.na(q)){
    
    result <- gridDF %>%
      filter(country == f_country, city == f_city) %>%
      mutate(flag = case_when(
        str_detect(string = name, pattern = q) == TRUE ~ TRUE
      ))  %>%
      filter(flag == TRUE)
  }
  
  # country:exists  +  city:exists  +  phrase:empty
  else if(!is.na(f_country) & !is.na(f_city) & is.na(q)){
    
    result <- gridDF %>%
      filter(country == f_country, city == f_city)
  }
  
  # country:exists  +  city:empty  +  phrase:exists
  else if(!is.na(f_country) & is.na(f_city) & !is.na(q)){
    
    result <- gridDF %>%
      filter(country == f_country) %>%
      mutate(flag = case_when(
        str_detect(string = name, pattern = q) == TRUE ~ TRUE
      ))  %>%
      filter(flag == TRUE)
  }
  
  # country:exists  +  city:empty  +  phrase:empty
  else if(!is.na(f_country) & is.na(f_city) & is.na(q)){
    result <- gridDF %>%
      filter(country == f_country)
  }
  
  # country:empty  +  city:exists  +  phrase:empty
  else if(is.na(f_country) & !is.na(f_city) & is.na(q)){
    result <- gridDF %>%
      filter(city == f_city)
  }
  
  # country:empty  +  city:exists  +  phrase:exists
  else if(is.na(f_country) & !is.na(f_city) & !is.na(q)){
    result <- gridDF %>%
      filter(city == f_city) %>%
      mutate(flag = case_when(
        str_detect(string = name, pattern = q) == TRUE ~ TRUE
      ))  %>%
      filter(flag == TRUE)
  }
  
  # country:empty  +  city:empty  +  phrase:exists
  else if(is.na(f_country) & is.na(f_city) & !is.na(q)){
    result <- gridDF %>%
      mutate(flag = case_when(
        str_detect(string = name, pattern = q) == TRUE ~ TRUE
      ))  %>%
      filter(flag == TRUE)
  }
  
  
  # country:empty  +  city:empty  +  phrase:empty
  else {
    resut <- gridDF
  }
  
  
  
  #'////////////////////////////////////////
  
  # finalize output by selecting columns
  result <- result %>% 
    select(grid_id, 
           name, 
           city, 
           state, 
           state_code, 
           country,
           country_code,
           acronym, 
           alias)
  
  
  # return result and then grid.id
  result
  
  
  
}

# run
# gridQuery(query = "unsw")
# gridQuery(filter_country = "australia")
# gridQuery(filter_city = "sydney")
# gridQuery(filter_country = "australia",filter_city = "melbourne")
# gridQuery(filter_country = "australia",filter_city = "melbourne", q="health")
# gridQuery(filter_country = "australia", q="health")


