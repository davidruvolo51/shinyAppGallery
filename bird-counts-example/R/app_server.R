#'////////////////////////////////////////////////////////////////////////////
#' FILE: app_server.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-12-01
#' MODIFIED: 2020-12-01
#' PURPOSE: application server
#' STATUS: working
#' PACKAGES: see `app.R`
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' app_server
#'
#' @noRd
app_server <- function(input, output, session) {
    birds <- golem::get_golem_options("data")
    tbl <- datatable(
        data = birds,
        id = "birdata",
        caption = "Top 25 Most Commonly Reported Australian Birds",
        html_escape = FALSE
    )
    shiny::insertUI(
        selector = "#birdtable",
        where = "beforeEnd",
        ui = tbl
    )
}