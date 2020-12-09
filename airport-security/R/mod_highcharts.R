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
#' @param id output id
#' @param data input data
#' @param x xaxis variable; must be categorical
#' @param y yaxis variable (continuous)
#' @param name series name
#' @param color color for the bars (default: `#700548`)
#'
#' @noRd
hc_column_server <- function(id, data, x, y, name, color = "#700548") {
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

#'//////////////////////////////////////

#' hc_timeseries
#'
#' @param id a unique identifier
#'
#' @noRd
hc_timeseries <- function(id) {
    ns <- NS(id)
    highchartOutput(ns("hc-timeseries"))
}

#' hc_timeseries_server
#'
#' @param id a unique identifier
#' @param data input data
#' @param x xaxis data (must be time)
#' @param y yaxis value
#' @param bg_data background data to plot behind target data
#' @param bg_yvar name of yaxis var
#'
#' @noRd
hc_timeseries_server <- function(id, data, x, y, bg_data, bg_yvar) {
    ns <- session$ns

    output$`hc-timeseries` <- renderHighchart({
        highchart() %>%
                hc_chart(zoomType = "xy") %>%
                hc_xAxis(
                    type = "dateTime",
                    categories = format(as.POSIXct(data[, x]), "%Y")
                ) %>%
                hc_yAxis(title = list(text = "Count")) %>%
                hc_add_series(
                    type = "spline",
                    data = round(bg_data[, bg_yvar], 2),
                    marker=list(
                        symbol = "circle",
                        lineWidth = "1px",
                        fillColor = "rgba(131,122,117,0.3)",
                        lineColor = "#837A75"
                    ),
                    backgroundColor = "white",
                    color = "#837A75",
                    name = "All FOs Combined"
                ) %>%
                hc_add_series(
                    type = "spline",
                    data = data[, y],
                    marker = list(
                        symbol = "circle",
                        lineWidth = "1px",
                        fillColor = "rgba(112,5,72,0.3)",
                        lineColor = "#700548"
                    ),
                    backgroundColor = "white",
                    color = "#700548",
                    name = "Field Office"
                ) %>%
                hc_tooltip(
                    crosshairs = TRUE,
                    shared = FALSE,
                    headerFormat = "Year: {point.x}<br>",
                    pointFormat = "Count: {point.y}",
                    shadow = TRUE,
                    backgroundColor = "white",
                    padding = 12,
                    borderWidth = 1.5,
                    borderRadius = 10
                )
    })
}