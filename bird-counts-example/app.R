#'////////////////////////////////////////////////////////////////////////////
#' FILE: app.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-03-15
#' MODIFIED: 2020-03-15
#' PURPOSE: a simple responsive datatable with images
#' STATUS: in.progress
#' PACKAGES: shiny; accessibleshiny
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////
options(stringsAsFactors = FALSE)

# pkgs
library(shiny)

# load data
birds <- readRDS("data/birds.RDS")

# ui
ui <- tagList(
    accessibleshiny::use_accessibleshiny(),
    tags$head(

        # define document meta elements
        tags$meta(charset = "utf-8"),
        tags$meta(
            `http-quiv` = "x-ua-compatible",
            content = "ie=edge"
        ),
        tags$meta(
            name = "viewport",
            content = "width=device-width, initial-scale=1"
        ),

        # link external files
        tags$link(
            rel = "stylesheet",
            type = "text/css",
            href = "styles.css"
        ),

        # add document title
        tags$title("Responsive Tables")
    ),
    tags$header(
        tags$h1("Responsive Tables")
    ),
    tags$main(id = "birdtable",
        tags$h2("Reporting Rates of Australian Birds"),
        tags$p(
            "The following table presents reporting rates of Australian Birds",
            ". This shinyapp provides an example on creating responsive data",
            "tables in R using lazy loading of images."
        )
    )
)

# server
server <- function(input, output, session) {


    tbl <- accessibleshiny::datatable(
        data = birds,
        id = "birdata",
        caption = "Top 25 Most Commonly Reported Australian Birds",
        options = list(
            html_escape = FALSE
        )
    )
    shiny::insertUI(
        selector = "#birdtable",
        where = "beforeEnd",
        ui = tbl
    )
}

# app
shinyApp(ui, server, options = list(launch.browser = FALSE))