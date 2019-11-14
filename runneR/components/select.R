#'//////////////////////////////////////////////////////////////////////////////
#' FILE: select.R
#' AUTHOR: David Ruvolo
#' CREATED: 2019-11-12
#' MODIFIED: 2019-11-12
#' PURPOSE: R ui component for building select inputs from options
#' STATUS: in.progress
#' PACKAGES: shiny
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////


# function to build individual <option>
# generate html element and then evaluate if option should be selected
selectOption <- function(value, string, selected){
    option <- htmltools::tags$option(value=value, string)
    if( isTRUE(selected)) {
        option$attribs$selected = "true"
    }
    return(option)
}

# function to build all options
# create tmp data.frame and then iterate over input array
selectOptionList <- function(value, string, selected){
    tmp <- data.frame( value = value, string = string, selected = selected )
    list <- lapply(
        X = 1:NROW(tmp),
        FUN = function(x){
            selectOption(value=tmp$value[x], string=tmp$string[x], selected=tmp$selected[x])      
        }
    )
    return(list)
}

# function to build <select>
selectOptions <- function(inputId, value, string, selected = NULL){
    css <- "shiny-bound-input"

    # warn if no strings entered
    if( is.null(string)) {
        stop("ERROR: no data supplied to argument 'string'")
    }
    # assign strings to values by default
    if( is.null(value)) {
        value <- string
    }

    # select the first option by default
    if( is.null(selected)) {
        flags <- rep(FALSE, length(string))
        flags[1] <- TRUE
    }

    # build input element
    htmltools::tags$select(id=inputId, class=css, 
        selectOptionList(value = value, string = string, selected = flags)
    )
}