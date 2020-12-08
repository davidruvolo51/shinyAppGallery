#'////////////////////////////////////////////////////////////////////////////
#' FILE: mod_highcharts.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-12-08
#' MODIFIED: 2020-12-08
#' PURPOSE: highcharts for report modules
#' STATUS: in.progress
#' PACKAGES: highcharts
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' hc_column
#'
#' @param id a unique Id
#'
#' @noRd
hc_column <- function(id) {
    ns <- NS(id)
    highchartOutput(outputId = ns("hc-column"))
}

#' hc_column_server
#'
#' Create a column chart using the Highcharts R package
#'
#' @param data input data
#' @param x xaxis variable; must be categorical
#' @param y yaxis variable (continuous)
#' @param name series name
#' @param color color for the bars (default: `#700548`)
#'
#' @noRd
hc_column_server <- function(data, x, y, name, color = "#700548") {
    ns <- session$ns
    output$`hc-column` <- renderHighchart({
        highchart() %>%
            hc_xAxis(categories = data[, x]) %>%
            hc_yAxis(tickInterval = 5) %>%
            hc_add_series(
                data,
                hcaes(x = x, y = y),
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