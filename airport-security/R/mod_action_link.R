#'////////////////////////////////////////////////////////////////////////////
#' FILE: mod_action_link.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-12-12
#' MODIFIED: 2020-12-12
#' PURPOSE: shiny action link
#' STATUS: in.progress
#' PACKAGES: Shiny
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' action_link
#'
#' A href link styled like a button
#'
#' @param id a unique identifier
#' @param label button label (default next)
#' @param to location to route users to
#' @param classnames optional css classes to append to
#'
#' @noRd
action_link <- function(id = NULL, label = "Next", to, classnames = NULL) {
    link <- tags$a(class = "action_link", href = to, label)
    if (!is.null(id)) {
        ns <- NS(id)
        link$attribs$id <- ns("actionlink")
    }
    if (!is.null(classnames)) {
        link$attribs$class <- paste0(link$attribs$class, classnames)
    }
    return(link)
}