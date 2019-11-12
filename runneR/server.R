#'//////////////////////////////////////////////////////////////////////////////
#' FILE: server.R
#' AUTHOR: David Ruvolo
#' CREATED: 27 January 2019
#' MODIFIED: 27 January 2019
#' PURPOSE: handle all user input and viz
#' PACKAGES: tbd
#' STATUS: in.progress
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)

# SERVER 
server <- function(input, output, session){
    
    # load uis and modules
    source("utils/function_02_handlers.R", local = TRUE)
    
    # process all data objects
    running_color = "#507DBC"
    restday_color = "#5D576B"
    running_color_alpha = "rgba(80, 125, 188, 0.3)"


    # quick stats and innerHTML: weeklyMean, monthlyMean, distanceMean, distanceTotal
    daysRun <- responses %>% 
        group_by("yyyy_mm" = format(as.Date(date), "%Y-%m-01")) %>% 
        filter(status == "yes") %>%
        count()

    daysRunNo <- responses %>% 
        group_by("yyyy_mm" = format(as.Date(date), "%Y-%m-01")) %>% 
        filter(status == "no") %>% 
        count()

    days <- NROW(responses)
    runningDays <- sum(daysRun$n)
    week_avg <- round(sum(daysRun[2])/(days/7),1)
    month_avg <- round(sum(daysRun[2])/NROW(daysRun),1)
    dist_avg <- round(sum(responses$distance)/runningDays, 2)
    dist_tot <- round(sum(responses$distance), 2)

    # days run
    runDF <- responses %>% filter(status == "yes")

    # routes sum
    routesSum <- responses %>% 
        group_by(route) %>% 
        filter(status == "yes") %>%
        summarize(count=n()) %>%
        arrange(desc(count))

    # reasons not run
    reasonsSum <- responses %>%
        filter(status =="no") %>%
        group_by(reason_not_run) %>%
        summarize(count=n()) %>%
        arrange(desc(count))

    # days run by the day of the week
    weekDist <- responses %>% 
        select(date, status) %>% 
        mutate(date = format(date, "%A")) %>%
        mutate(status = ifelse(status == "yes", 1, 0)) %>%
        group_by(date) %>%
        summarize(rate = sum(status)) %>% # optional if you want count
        mutate(date = factor(date,levels=c("Sunday","Monday","Tuesday", "Wednesday","Thursday","Friday","Saturday"))) %>%
        arrange(date)

    # summarize data by month
    monthRunDF <- responses %>%
        filter(status == "yes") %>% 
        group_by(date = format(date,"%Y-%m-01")) %>%
        summarize("avg" = round(mean(distance),2))

    # send values to ui via handlers
    js$innerHTML(elem="#distance-tot", string = dist_tot, session = session)
    js$innerHTML(elem="#distance-avg", string = dist_avg, session = session)
    js$innerHTML(elem="#days-total", string = days, session = session)
    js$innerHTML(elem="#days-run-total", string = runningDays, session = session)
    js$innerHTML(elem="#days-run-week", string = week_avg, session = session)
    js$innerHTML(elem="#days-run-month", string = month_avg, session = session)

    #'////////////////////////////////////////////////////////////////////////////////
    # start plotting!

    # plot: distribution by day
    output$daysPlot <- renderHighchart({
        highchart() %>%
            hc_chart(type = "line", zoomType = "xy") %>%
            hc_xAxis(categories = format(as.POSIXct(daysRun$yyyy_mm), "%b %Y")) %>%
            hc_yAxis(title=list(text="number of days")) %>%
            hc_add_series(daysRun$n, name="Running Days", color= running_color) %>%
            hc_add_series(daysRunNo$n, name="Off Days", color= restday_color) %>%
            hc_tooltip(
                crosshairs = TRUE,
                shared = FALSE,
                headerFormat = "Distance: {point.x}<br>",
                pointFormat = "Days: {point.y}",
                shadow = T,
                backgroundColor = "white",
                padding = 12,
                borderWidth = 1.5,
                borderRadius = 10
            )
    })

    # plot: distribution by week
    output$weekDist <- renderHighchart({
        highchart() %>%
            hc_xAxis(categories=weekDist$date) %>%
            hc_yAxis(tickInterval = 5, title=list(text="cout")) %>%
            hc_add_series(weekDist$rate,
                          type="column", 
                          name="Running Days",
                          color= running_color) %>%
            hc_tooltip(crosshairs = TRUE,
                       shared = FALSE,
                       headerFormat = "{point.x}<br>",
                       pointFormat="{point.y}",
                       shadow=T,
                       backgroundColor="white",
                       padding=12,
                       borderWidth=1.5,
                       borderRadius=10) %>%
            hc_legend(enabled = FALSE)
    })

    # plot distance by day
    days_plot <- highchart() %>%
            hc_chart(zoomType = "xy") %>%
            hc_xAxis(type="dateTime", categories = format(as.POSIXct(runDF$date), "%b %d")) %>%
            hc_yAxis(title=list(text="kms")) %>%
            hc_add_series(type="scatter", 
                        data = runDF$distance,
                        marker=list(symbol = "circle",
                                    lineWidth = "1px",
                                    fillColor = running_color_alpha,
                                    lineColor = running_color),
                        backgroundColor = "white",
                        color = running_color,
                        name = "Distance") %>%
            hc_add_series(type = "line",round(lowess(runDF$distance)$y,2),
                        marker = F,
                        shadow = T,
                        lineWidth = "1px",
                        color = "#636363",
                        name = "Trend") %>%
            hc_tooltip(crosshairs = TRUE,
                    shared = FALSE,
                    headerFormat = "Date: {point.x}<br>",
                    pointFormat = "Distance: {point.y} kms",
                    shadow = T,
                    backgroundColor = "white",
                    padding = 12,
                    borderWidth = 1.5,
                    borderRadius = 10)

    months_plot <- highchart() %>%
            hc_chart(zoomType = "xy") %>%
            hc_xAxis(type = "dateTime",categories = format(as.POSIXct(monthRunDF$date), "%b %Y")) %>%
            hc_yAxis(title = list(text = "kms")) %>%
            hc_add_series(type = "line", 
                        data = monthRunDF$avg,
                        marker = list(symbol = "circle", 
                                        lineWidth = "1px", 
                                        fillColor = running_color_alpha, 
                                        lineColor = running_color),
                        backgroundColor = "white",
                        color = running_color,
                        name = "Avg. Distance") %>%
            hc_tooltip(crosshairs = TRUE,
                    shared = FALSE,
                    headerFormat = "Date: {point.x}<br>",
                    pointFormat = "Avg. Distance: {point.y} kms",
                    shadow = T,
                    backgroundColor = "white",
                    padding = 12,
                    borderWidth = 1.5,
                    borderRadius = 10)

    # duration of runs
    output$runDuration <- renderHighchart({
    
        # get entries where running status == yes and duration was logged
        durDF <- responses %>% 
            filter(status == "yes", !is.na(time_run_start)) %>%
            select(date, status, distance, dur_est)

        # init column + bin distance
        durDF$distanceBin <- NA
        for(i in 1:NROW(durDF)){
            durDF$distanceBin[i] <- binDistance(durDF$distance[i])
        }

        # factor col
        durDF$distanceBin <- factor(durDF$distanceBin, levels = c("0-2km","2-3km","3-4km", "4-5km","5-6km","6-7km", "7-8km","8-9km","9-10km", "10-11km","11-12km","12-13km", "13-14km","14-15km","15km+"))
    
        # group by distance bins and summarize
        durDFSum <- durDF %>% 
            group_by(distanceBin) %>%
            summarize(avg = round(mean(dur_est),2))  %>%
            arrange(distanceBin)
    
        # build chart
        highchart() %>%
            hc_xAxis(categories = durDFSum$distanceBin) %>%
            hc_yAxis(title = list(text = "Average Minutes Run")) %>%
            hc_add_series(type = "column",
                        data = durDFSum$avg,
                        name = "Distance (kms)",
                        marker = list(symbol = "circle",
                                        lineWidth = "1px",
                                        fillColor = running_color_alpha,
                                        lineColor = running_color),
                        backgroundColor = "white",
                        color = running_color) %>%
            hc_tooltip(crosshairs = TRUE,
                    shared = FALSE,
                    headerFormat = "Distance: {point.x}<br>",
                    pointFormat = "Avg Minutes: {point.y}",
                    shadow = T,
                    backgroundColor = "white",
                    padding = 12,
                    borderWidth = 1.5,
                    borderRadius = 10) %>%
            hc_legend(enabled = FALSE)
        
    })
    
    # runs by route
    output$runsByRoute <- renderHighchart({
        highchart() %>%
            hc_xAxis(categories=routesSum$route) %>%
            hc_yAxis(tickInterval = 5) %>%
            hc_add_series(data = routesSum$count,
                        type="bar", 
                        name="Runs by Route",
                        color = running_color) %>%
            hc_tooltip(crosshairs = TRUE,
                    shared = FALSE,
                    headerFormat = "Route: {point.x}<br>",
                    pointFormat = "Count: {point.y}",
                    shadow = T,
                    backgroundColor = "white",
                    padding = 12,
                    borderWidth = 1.5,
                    borderRadius = 10) %>%
            hc_legend(enabled = FALSE)
    })
        
    # reasons not run
    output$reasonsNotRun <- renderHighchart({
        highchart() %>%
            hc_xAxis(categories = reasonsSum$reason_not_run) %>%
            hc_yAxis(tickInterval = 5) %>%
            hc_add_series(data = reasonsSum$count,
                        type = "bar", 
                        name = "Off Days",
                        color = restday_color) %>%
            hc_tooltip(crosshairs = TRUE,
                    shared = FALSE,
                    headerFormat = "Reason: {point.x}<br>",
                    pointFormat = "Count: {point.y} days",
                    shadow = T,
                    backgroundColor = "white",
                    padding = 12,
                    borderWidth = 1.5,
                    borderRadius = 10) %>%
            hc_legend(enabled = FALSE)
    })
        
        
    # time of day started running
    output$timeStartRun <- renderHighchart({
        
        # summarize - bin to a consistent date
        startTime <- responses %>% 
            filter(status == "yes", !is.na(time_run_start)) %>%
            mutate(start_time = format(lubridate::mdy_hm(time_run_start), "2099-12-31 %H:00")) %>%
            group_by(start_time) %>%
            summarize(count=n())
        
        # plot
        highchart() %>%
            hc_xAxis(type="dateTime",
                    dateTimeLabelFormats = list(hour = '%H:%M', day="%H:%M"),
                    categories = format(as.POSIXct(startTime$start_time), "%H:%M")) %>%
            hc_yAxis(title=list(text="count")) %>%
            hc_add_series(data = startTime$count,
                        type = "column",
                        name="Time of Day",
                        marker=list(symbol="circle",
                                    lineWidth="1px",
                                    fillColor=running_color,
                                    lineColor=running_color_alpha),
                        backgroundColor="white",
                        color= running_color) %>%
            hc_tooltip(crosshairs = TRUE,
                    shared = FALSE,
                    headerFormat = "Hour: {point.x}<br>",
                    pointFormat="Count: {point.y}",
                    shadow=T,
                    backgroundColor="white",
                    padding=12,
                    borderWidth=1.5,
                    borderRadius=10) %>%
            hc_legend(enabled = FALSE)
    })

    #'//////////////////////////////////////////////////////////////////////////////

    # render chart based on slider toggle
    observe({
        # default = days
        if(input$distanceToggle == "days"){
            output$distBy <- renderHighchart({ days_plot })
        }
        
        # 'on' = distance
        if(input$distanceToggle == "months"){
            # render plot
            output$distBy <- renderHighchart({ months_plot }) 
        }
    })

    #'//////////////////////////////////////////////////////////////////////////////
    # Event: newEnty ----
    # process new entry button click
    
    # observeEvent({
    #     input$newEntry
    #     input$newData},{
        
    #     # send binary to js file to determine which entry form to display
    #     if(max(responses$date) == format(Sys.Date(),"%Y-%m-%d")){
    #         value <- "status-logged"
    #     } else {
    #         value <- TRUE
    #     }
        
    #     # send message
    #     session$sendCustomMessage(type = "firstformshow", value)
        
    # })
    
    # observeEvent(input$`btn-yes`,{
    #     value <- "status-yes-run"
    #     session$sendCustomMessage(type = "newYesEntryForm",value)
    # })
    
    # observeEvent(input$`btn-no`,{
    #     value <- "status-no-run"
    #     session$sendCustomMessage(type="newNoEntryForm",value)
    # })
    
    
    #'////////////////////////////////////////
    # Event: cancel entry ----
    # observeEvent(input$`yes-form-cancel`,{
        
    #     # set value and send message
    #     value <- 0
    #     session$sendCustomMessage(type = "cancel-yes-form", value)
        
    # })
    
    # observeEvent(input$`no-form-cancel`,{
        
    #     # set value and send message
    #     value <- 0
    #     session$sendCustomMessage(type = "cancel-no-form", value)
        
    # })
    
}
