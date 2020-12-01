#'////////////////////////////////////////////////////////////////////////////
#' FILE: app.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-03-15
#' MODIFIED: 2020-12-01
#' PURPOSE: a simple responsive datatable with images
#' STATUS: in.progress
#' PACKAGES: shiny; accessibleshiny
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' install packages
#' install.packages("shiny")
#' install.packages("rlang")
#' install.packages("purrr")
#' install.packages("htmltools")
#' install.packages("golem")

#' pkgs
suppressPackageStartupMessages(library(shiny))

#' load data
birds <- readRDS("data/birds.RDS")

# set golem
golem::with_golem_options(
    app = shinyApp(
        ui = app_ui,
        server = app_server
    ),
    golem_opts = list(
        data = birds
    )
)