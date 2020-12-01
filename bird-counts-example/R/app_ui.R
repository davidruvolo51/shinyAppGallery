#'////////////////////////////////////////////////////////////////////////////
#' FILE: app_ui.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-12-01
#' MODIFIED: 2020-12-01
#' PURPOSE: application UI
#' STATUS: in.progress
#' PACKAGES: see `app.R`
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////


#' app_ui
#'
#' @noRd
app_ui <- function(request) {
    tagList(
        tags$head(
            tags$meta(charset = "utf-8"),
            tags$meta(
                `http-quiv` = "x-ua-compatible",
                content = "ie=edge"
            ),
            tags$meta(
                name = "viewport",
                content = "width=device-width, initial-scale=1"
            ),
            tags$link(
                rel = "stylesheet",
                type = "text/css",
                href = "styles.css"
            ),
            tags$title("Responsive Tables")
        ),
        tags$header(
            tags$h1("Responsive Tables")
        ),
        tags$main(
            id = "birdtable",
            tags$h2("Reporting Rates of Australian Birds"),
            tags$p(
                "The following table presents reporting rates of Australian ",
                "Birds. This shinyapp provides an example on creating ",
                "responsive data tables in R using lazy loading of images."
            )
        )
    )
}