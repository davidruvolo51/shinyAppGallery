#'//////////////////////////////////////////////////////////////////////////////
#' FILE: radio_group.R
#' AUTHOR: David Ruvolo
#' CREATED: 2018-09-18
#' MODIFIED: 2019-11-11
#' PURPOSE: build radio input group
#' PACKAGES: shiny
#' STATUS: in.progress
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)


# function build a single radio input
radioButton <- function(id, name, label, value, selected){
    # build <label> and <input type=radio>
    lab <- htmltools::tags$label( `for`=id, label, class="radio-label")
    radio <- tags$input( id=id, name=name, value=value, type="radio", class="radio-input")

    # add selected attribute
    if( isTRUE(selected)){
        radio$attribs$checked <- "checked"
    }

    # build item
    htmltools::tags$div(class="radio-item", radio, lab)
}


# function to build multiple radio inputs
radioGroup <- function(id,name, label, value, selected, title){
    
    # collapse inputs to build multiple inputs
    tmp <- data.frame( label = label, value = value, selected = selected, stringsAsFactors = FALSE )
    lapply(
        X = 1:NROW(tmp),
        FUN = function(x){
            radioButton(
                id = paste0(id,"-",tmp$value[x]), name = id, label = tmp$label[x], value = tmp$value[x], selected= tmp$selected[x]
            )
        }
    )    
}

# function to build a complete set of radio inputs
radioInputGroup <- function(inputId, label, value, selected){

    # set parent classes
    css <- "form-group shiny-input-radiogroup shiny-input-container shiny-input-container-inline"

    # build widget in form > fieldset > div > input + label 
    tags$fieldset(class=css, `role`="radiogroup", id=inputId,
        radioGroup(id = inputId, name = inputId, label = label, value = value, selected = selected)
    )

}

