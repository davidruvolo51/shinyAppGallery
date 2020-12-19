#'////////////////////////////////////////////////////////////////////////////
#' FILE: mod_hc_timeseries.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-12-08
#' MODIFIED: 2020-12-19
#' PURPOSE: highcharts for report modules
#' STATUS: in.progress
#' PACKAGES: highcharts
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' hc_timeseries
#'
#' @param id a unique identifier
#'
#' @noRd
hc_timeseries <- function(id) {
    highchartOutput(NS(id, "hc_timeseries"), width = "100%")
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
    moduleServer(id, function(input, output, session) {
        output$hc_timeseries <- renderHighchart({
            highchart() %>%
                hc_chart(zoomType = "xy") %>%
                hc_xAxis(
                    type = "dateTime",
                    categories = format(as.POSIXct(data[[x]]), "%Y")
                ) %>%
                hc_yAxis(title = list(text = "Count")) %>%
                hc_add_series(
                    type = "spline",
                    data = round(bg_data[, bg_yvar], 2),
                    marker = list(
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
                    data = data[[y]],
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
    })
}