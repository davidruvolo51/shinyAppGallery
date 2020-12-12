#'////////////////////////////////////////////////////////////////////////////
#' FILE: run_app.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-12-12
#' MODIFIED: 2020-12-12
#' PURPOSE: start app function
#' STATUS: in.progress
#' PACKAGES: Shiny; golem
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' run_app
#'
#' @noRd
run_app <- function() {

    #' data: formally: tsaALL, tsaSUM, tsaYRS
    tsa <- readRDS("data/tsa_cleaned.RDS")
    tsa_sum <- readRDS("data/tsa_summary.RDS")
    tsa_sum_yr <- readRDS("data/tsa_summary_year.RDS")

    #' start golem
    golem::with_golem_options(
        app = shinyApp(
            ui = app_ui,
            server = app_server
        ),
        golem_opts = list(
            tsa = tsa,
            tsa_sum = tsa_sum,
            tsa_sum_yr = tsa_sum_yr
        )
    )

}