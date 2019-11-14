#'//////////////////////////////////////////////////////////////////////////////
#' FILE: viz_01_chart.R
#' AUTHOR: David Ruvolo
#' CREATED: 2019-11-12
#' MODIFIED: 2019-11-13
#' PURPOSE: build charts
#' STATUS: working
#' PACKAGES: see global
#' COMMENTS: load after data_01_summarize.R as all data objects come from runData
#'//////////////////////////////////////////////////////////////////////////////

# pkgs for debugging
# suppressPackageStartupMessages(library(highcharter))

# build object
viz <- list()

# build options list
opts <- list()
opts$colors <- list()
opts$colors$runDays <- "#507DBC"
opts$colors$restDays <- "#5D576B"
opts$colors$runDaysAlpha <- "rgba(80, 125, 188, 0.3)"
opts$titles$runDays <- "Running Days"
opts$titles$restDays <- "Rest Days"

#'////////////////////////////////////////

# ~ 1 ~
# Create a time series plot that shows the number of days per month that were
# running days and rest days
viz$runDaysByMonth <- highchart() %>%
    hc_chart(type = "line", zoomType = "xy") %>%
    hc_xAxis(categories = format(as.POSIXct(runData$summaries$runDaysByMonth$yyyy_mm), "%b %Y")) %>%
    hc_yAxis(title = list(text = "number of days")) %>%
    hc_add_series(
        runData$summaries$runDaysByMonth$n, 
        name = opts$titles$runDays, 
        color = opts$colors$runDays
    ) %>%
    hc_add_series(
        runData$summaries$restDaysByMonth$n, 
        name = opts$titles$runDays,
        color = opts$colors$restDays
    ) %>%
    hc_tooltip(
        headerFormat = "Distance: {point.x}<br>",
        pointFormat = "Days: {point.y}",
        backgroundColor = "white"
    )

# ~ 2 ~
# Create a column chart that shows the distribution of runs by the day of the 
# week. By default, the days are factored started with Sunday.

viz$runDaysByWeekday <- highchart() %>%
    hc_xAxis(categories = runData$summaries$runsByWeekday$date) %>%
    hc_yAxis(tickInterval = 5, title = list(text = "cout")) %>%
    hc_add_series(
        runData$summaries$runsByWeekday$count,
        type = "column",
        name = opts$titles$runDays,
        color = opts$colors$runDays
    ) %>%
    hc_tooltip(
        headerFormat = "{point.x}<br>",
        pointFormat = "{point.y}",
        backgroundColor = "white"
    ) %>%
    hc_legend(enabled = FALSE)


# ~ 3 ~
# create a scatter plot that shows the distance per run day, as well as a trend line
viz$distanceByDay <- highchart() %>%
    hc_chart(zoomType = "xy") %>%
    hc_xAxis(
        type = "dateTime", 
        categories = format(as.POSIXct(runData$data$runDF$date), "%b %d")
    ) %>%
    hc_yAxis(title = list(text = "kms")) %>%
    hc_add_series(
        type = "scatter",
        data = runData$data$runDF$distance,
        marker = list(
            symbol = "circle",
            lineWidth = "1px",
            fillColor = opts$colors$runDaysAlpha,
            lineColor = opts$colors$runDays
        ),
        backgroundColor = "white",
        color = opts$colors$runDays,
        name = "Distance"
    ) %>%
    hc_add_series(
        type = "line", 
        round(lowess(runData$data$runDF$distance)$y, 2),
        marker = FALSE,
        shadow = FALSE,
        lineWidth = "1px",
        color = "#636363",
        name = "Trend"
    ) %>%
    hc_tooltip(
        headerFormat = "Date: {point.x}<br>",
        pointFormat = "Distance: {point.y} kms",
        backgroundColor = "white"
    )


# ~ 4 ~
# create a time series plot that shows the average distance ran by month
viz$distanceByMonth <- highchart() %>%
    hc_chart(zoomType = "xy") %>%
    hc_xAxis(
        type = "dateTime", 
        categories = format(as.POSIXct(runData$summaries$avgDistByMonth$date), "%b %Y")
    ) %>%
    hc_yAxis(title = list(text = "kms")) %>%
    hc_add_series(
        type = "line",
        data = runData$summaries$avgDistByMonth$avg,
        marker = list(
            symbol = "circle",
            lineWidth = "1px",
            fillColor = opts$colors$runDaysAlpha,
            lineColor = opts$colors$runDays
        ),
        backgroundColor = "white",
        color = opts$colors$runDays,
        name = "Avg. Distance"
    ) %>%
    hc_tooltip(
        headerFormat = "Date: {point.x}<br>",
        pointFormat = "Avg. Distance: {point.y} kms",
        backgroundColor = "white"
    )


# duration of runs by distance refactored
viz$timeByDistanceBinned <- highchart() %>%
    hc_xAxis(categories = runData$summaries$timeAndRunsByDistBin$distance_bin) %>%
    hc_yAxis(title = list(text = "Average Minutes Run")) %>%
    hc_add_series(
        type = "column",
        data = runData$summaries$timeAndRunsByDistBin$time,
        name = "Distance (kms)",
        marker = list(
            symbol = "circle",
            lineWidth = "1px",
            fillColor = opts$colors$runDays,
            lineColor = opts$colors$restDays
        ),
        backgroundColor = "white",
        color = opts$colors$runDays
    ) %>%
    hc_tooltip(
        headerFormat = "Distance: {point.x}<br>",
        pointFormat = "Avg Minutes: {point.y}",
        backgroundColor = "white"
    ) %>%
    hc_legend(enabled = FALSE)

# number of runs by distance refactored
viz$runsByDistanceBinned <- highchart() %>%
    hc_xAxis(categories = runData$summaries$timeAndRunsByDistBin$distance_bin) %>%
    hc_yAxis(title = list(text = "Number of Runs")) %>%
    hc_add_series(
        type = "column",
        data = runData$summaries$timeAndRunsByDistBin$runs,
        name = "Distance (kms)",
        marker = list(
            symbol = "circle",
            lineWidth = "1px",
            fillColor = opts$colors$runDays,
            lineColor = opts$colors$restDays
        ),
        backgroundColor = "white",
        color = opts$colors$runDays
    ) %>%
    hc_tooltip(
        headerFormat = "Distance: {point.x}<br>",
        pointFormat = "Number of Runs: {point.y}",
        backgroundColor = "white"
    ) %>%
    hc_legend(enabled = FALSE)

# runs by route
viz$runsByRoute <- highchart() %>%
    hc_xAxis(categories = runData$summaries$runsByRoute$route) %>%
    hc_yAxis(tickInterval = 5) %>%
    hc_add_series(
        data = runData$summaries$runsByRoute$count,
        type = "bar",
        name = "Runs by Route",
        color = opts$colors$runDays
    ) %>%
    hc_tooltip(
        headerFormat = "Route: {point.x}<br>",
        pointFormat = "Count: {point.y}",
        backgroundColor = "white"
    ) %>%
    hc_legend(enabled = FALSE)

# reasons not run
viz$reasonsNotRun <- highchart() %>%
    hc_xAxis(categories = runData$summaries$restDaysByReason$reason_not_run) %>%
    hc_yAxis(tickInterval = 5) %>%
    hc_add_series(
        data = runData$summaries$restDaysByReason$count,
        type = "bar",
        name = "Off Days",
        color = opts$colors$restDays
    ) %>%
    hc_tooltip(
        headerFormat = "Reason: {point.x}<br>",
        pointFormat = "Count: {point.y} days",
        backgroundColor = "white"
    ) %>%
    hc_legend(enabled = FALSE)


# time of day started running
viz$timeStartRun <- highchart() %>%
    hc_xAxis(
        type = "dateTime",
        dateTimeLabelFormats = list(hour = '%H:%M', day = "%H:%M"),
        categories = format(as.POSIXct(runData$summaries$runsByHour$start_time), "%H:%M")
    ) %>%
    hc_yAxis(title = list(text = "count")) %>%
    hc_add_series(
        data = runData$summaries$runsByHour$count,
        type = "column",
        name = "Time of Day",
        marker = list(
            symbol = "circle",
            lineWidth = "1px",
            fillColor = opts$colors$runDays,
            lineColor = opts$colors$runDaysAlpha
        ),
        backgroundColor = "white",
        color = opts$colors$runDays
    ) %>%
    hc_tooltip(
        headerFormat = "Hour: {point.x}<br>",
        pointFormat = "Count: {point.y}",
        backgroundColor = "white"
    ) %>%
    hc_legend(enabled = FALSE)
