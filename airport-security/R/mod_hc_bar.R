#'////////////////////////////////////////////////////////////////////////////
#' FILE: mod_highcharts.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-12-08
#' MODIFIED: 2020-12-12
#' PURPOSE: highcharts for report modules
#' STATUS: in.progress
#' PACKAGES: highcharts
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' hc_bar
#'
#' @param id a unique Id
#'
#' @noRd
hc_bar <- function(id) {
    highchartOutput(NS(id, "hc_bar"), width = "375px")
}

#' hc_bar_server
#'
#' Create a column chart using the Highcharts R package
#'
#' @param id output id
#' @param data input data
#' @param x xaxis variable; must be categorical
#' @param y yaxis variable (continuous)
#' @param name series name
#' @param color color for the bars (default: `#700548`)
#'
#' @noRd
hc_bar_server <- function(id, data, x, y, name, color = "#700548") {
    moduleServer(
        id,
        function(input, output, session) {
            output$hc_bar <- renderHighchart({
                highchart() %>%
                    hc_chart(data = data) %>%
                    hc_xAxis(categories = unique(data[[x]])) %>%
                    hc_yAxis(tickInterval = 5) %>%
                    hc_add_series(
                        data = data,
                        hcaes(x = .data[[x]], y = .data[[y]]),
                        type = "bar",
                        name = name,
                        color = color
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
                    )
            })
        }
    )
}