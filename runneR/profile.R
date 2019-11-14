#'//////////////////////////////////////////////////////////////////////////////
#' FILE: profile.R
#' AUTHOR: David Ruvolo
#' CREATED: 2019-11-12
#' MODIFIED: 2019-11-12
#' PURPOSE: profile for runneR shiny app
#' STATUS: working
#' PACKAGES: NA
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////
# add all data in nested object
profile <- list()

# home country: change as needed
profile$country = "australia"

# enter the name of your routes here
profile$routes <- c(
    "",
    "kfc",
    "park bridge",
    "office works",
    "greek church",
    "greek church + office works",
    "cooks river",
    "hurlstone park",
    "newtown"
)


# enter reasons for not running here
profile$reasons <- c(
    "",
    "rest day",
    "injury",
    "holiday",
    "too hot",
    "too cold",
    "raining",
    "other weather",
    "other"
)