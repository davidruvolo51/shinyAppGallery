#'//////////////////////////////////////////////////////////////////////////////
#' FILE: function_03_database.R
#' AUTHOR: David Ruvolo
#' CREATED: 2019-11-12
#' MODIFIED: 2019-11-12
#' PURPOSE: functions to save and load dataset from file
#' STATUS: in.progress
#' PACKAGES: see global
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////
# create nested functions
file <- list()
file$blankDF <- function(){
    data.frame(
        country = NA,
        date = NA,
        distance = NA,
        dur_est = NA,
        max_temp = NA,
        min_temp = NA,
        reason_not_run = NA,
        route = NA,
        run_temp = NA,
        status = NA,
        time_logged = NA,
        time_run_start = NA,
        stringsAsFactors = FALSE
    )
}
