#'////////////////////////////////////////////////////////////////////////////
#' FILE: mod_ranking_viz.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-12-09
#' MODIFIED: 2020-12-19
#' PURPOSE: Ggplot2 ranked viz
#' STATUS: in.progress
#' PACKAGES: ggplot2
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' ranking_viz
#'
#' @param id a unique identifier
#'
#' @noRd
ranking_viz <- function(id) {
    highchartOutput(NS(id, "ranking"))
}

#' ranking_viz_server
#'
#' @param id a unique identifier
#' @param data input dataset
#' @param fo_id field office Id
#'
#' @noRd
ranking_viz_server <- function(id, data, fo_id) {
    moduleServer(id, function(input, output, session) {
        dat <- reactive({
            data %>%
                arrange(tot.cases) %>%
                mutate(
                    codes = factor(codes, codes),
                    group = case_when(
                        codes == fo_id ~ "target",
                        TRUE ~ "default"
                    ),
                    fill = case_when(
                        group == "target" ~ "#700548",
                        TRUE ~ "#857a74"
                    )
                ) %>%
                ungroup()
        })

        output$ranking <- renderHighchart({
            highchart() %>%
                hc_xAxis(categories = unique(dat()$codes)) %>%
                hc_yAxis(tickInterval = 50) %>%
                hc_add_series(
                    data = dat(),
                    hcaes(x = codes, y = tot.cases, color = fill),
                    type = "column"
                ) %>%
                hc_tooltip(
                    crosshairs = TRUE,
                    shared = FALSE,
                    headerFormat = "{point.x}<br>",
                    pointFormat = "Count: {point.y}",
                    shadow = TRUE,
                    backgroundColor = "white",
                    padding = 12,
                    borderWidth = 1.5,
                    borderRadius = 10
                ) %>%
                hc_legend(enabled = FALSE)
        })
    })
}