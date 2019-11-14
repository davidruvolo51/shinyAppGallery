#'//////////////////////////////////////////////////////////////////////////////
#' FILE: funcs.R
#' AUTHOR: David Ruvolo
#' CREATED: 28 January 2019
#' MODIFIED: 28 January 2019
#' PURPOSE: functions for app
#' PACKAGES: NA
#' STATUS: in.progress
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////

# ~ 1 ~
# recode distance function

binDistance <- function(input){
    if(input < 2){
        return("0-2km")
    } else if(input >=2 & input < 3){
        return("2-3km")
    } else if(input >=3 & input < 4){
        return("3-4km")
    } else if(input >=4 & input < 5){
        return("4-5km")
    } else if(input >= 5 & input < 6){
        return("5-6km")
    } else if(input >= 6 & input < 7){
        return("6-7km")
    } else if(input >= 7 & input < 8 ){
        return("7-8km")
    } else if(input >= 8 & input < 9 ){
        return("8-9km")
    } else if(input >= 9 & input < 10 ){
        return("9-10km")
    } else if(input >= 10 & input < 11 ){
        return("10-11km")
    } else if(input >= 11 & input < 12 ){
        return("11-12km")
    } else if(input >= 12 & input < 13 ){
        return("12-13km")
    } else if(input >= 13 & input < 14 ){
        return("13-14km")
    } else if(input >= 14 & input < 15 ){
        return("14-15km")
    } else if(input >= 15 ){
        return("15km+")
    } else {
        return("NA")
    }
}
