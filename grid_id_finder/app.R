#'////////////////////////////////////////////////////////////////////////////
#' FILE: app.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-11-30
#' MODIFIED: 2020-11-30
#' PURPOSE: primary script for running application
#' STATUS: in.progress
#' PACKAGES: shiny
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' install pkgs
#' install.packages("shiny")
#' install.packages("dplyr")
#' install.packages("stringr")
#' install.packages("golem")
#' remotes::install_github("davidruvolo51/browsertools")

#' load pkgs
suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(dplyr))

#' load data
grid_ac <- readRDS("data/grid_merged.RDS")

#' build county names
countries <- grid_ac %>%
    select(country) %>%
    distinct() %>%
    arrange(country) %>%
    pull(.) %>%
    c("", .) %>%
    as.character(.)

#' shiny options
options(shiny.port = 9000, shiny.launch.browser = TRUE)

#' run app
golem::with_golem_options(
    app = shiny::shinyApp(
        ui = app_ui,
        server = app_server
    ),
    golem_opts = list(
        countries = countries,
        data = grid_ac
    )
)
