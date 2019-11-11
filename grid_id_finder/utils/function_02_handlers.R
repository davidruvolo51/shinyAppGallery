#'//////////////////////////////////////////////////////////////////////////////
#' FILE: function_02_handlers.R
#' AUTHOR: David Ruvolo
#' CREATED: 2019-11-10
#' MODIFIED: 2019-11-10
#' PURPOSE: shiny handlers
#' STATUS: in.progress
#' PACKAGES: shiny
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////

# create message
js <- modules::module({
    
    # ~ 1 ~
    # build wrapper for handler: addCSS
    addCSS <- function(elem, css, session){
        session$sendCustomMessage("addCSS", list(elem, css))
    }
    
    # ~ 2 ~
    # build wrapper for handler: innerHTML
    innerHTML <- function(elem, string, session){
        session$sendCustomMessage("innerHTML", list(elem, string))
    }
    
    # ~ 3 ~
    # build wrapper for handler: refreshPage
    refreshPage <- function(session){
        session$sendCustomMessage("refreshPage", "")
    }
    
    # ~ 4 ~
    # build wrapper for handler: removeCSS
    removeCSS <- function(elem, css, session){
        session$sendCustomMessage("removeCSS", list(elem, css))
    }
    
    # ~ 5 ~
    # build wrapper for handler: setElementAttribute
    setElementAttribute <- function(elem, attr, value, session){
        session$sendCustomMessage("setElementAttribute", list(elem, attr, value))
    }
    
    # ~ 6 ~
    # build wrapper for handler: toggleCSS
    toggleCSS <- function(elem, css, session){
        session$sendCustomMessage("toggleCSS", list(elem, css))
    }
    
    
    # ~ 7 ~
    # build wrapper for handler: toggleElem
    toggleElem <- function(elem, session){
        session$sendCustomMessage("toggleElem", list(elem))
    }
    
    # ~ 8 ~
    # build wrapper for handler: consoleLog
    consoleLog <- function(value, asDir = TRUE, session){
        session$sendCustomMessage("consoleLog", list(value, asDir))
    }

    # ~ 9 ~
    # build wrapper for handler: closeWindow
    closeWindow <- function(session){
        session$sendCustomMessage("closeWindow", "")
    }
})