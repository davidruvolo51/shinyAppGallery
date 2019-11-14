#'//////////////////////////////////////////////////////////////////////////////
#' FILE: server.R
#' AUTHOR: David Ruvolo
#' CREATED: 2019-01-27
#' MODIFIED: 2019-11-14
#' PURPOSE: handle all user input and viz
#' PACKAGES: tbd
#' STATUS: in.progress
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)
server <- function(input, output, session) {
    
    source("scripts/data_01_summarize.R")

    # send values to ui via handlers
    js$innerHTML(elem = "#distance-tot", string = runData$highlights$dist_tot, session = session)
    js$innerHTML(elem = "#distance-avg", string = runData$highlights$dist_avg, session = session)
    js$innerHTML(elem = "#days-total", string = runData$highlights$days, session = session)
    js$innerHTML(elem = "#days-run-total", string = runData$highlights$runningDays, session = session)
    js$innerHTML(elem = "#days-run-week", string = runData$highlights$week_avg, session = session)
    js$innerHTML(elem = "#days-run-month", string = runData$highlights$month_avg, session = session)

    # render charts
    source("scripts/data_02_visualize.R")
    output$runDaysByMonth <- renderHighchart({ viz$runDaysByMonth })
    output$runDaysByWeekday <- renderHighchart({ viz$runDaysByWeekday })
    output$runsByRoute <- renderHighchart({ viz$runsByRoute })
    output$reasonsNotRun <- renderHighchart({ viz$reasonsNotRun })
    output$timeStartRun <- renderHighchart({ viz$timeStartRun })

    #'//////////////////////////////////////////////////////////////////////////////

    # render charts based on radio button input
    observe({
        # default = days
        if (input$distanceToggle == "days") {
            output$distBy <- renderHighchart({ viz$distanceByDay })
        }

        # 'on' = distance
        if (input$distanceToggle == "months") {
            output$distBy <- renderHighchart({ viz$distanceByMonth })
        }
    })

    observe({
        # default runs
        if(input$binToggle == "runs"){
            output$distanceBinned <- renderHighchart({ viz$runsByDistanceBinned })
        }
        
        # default average time by bin
        if(input$binToggle == "time"){
            output$distanceBinned <- renderHighchart({ viz$timeByDistanceBinned })
        }
    })
    
    #'//////////////////////////////////////////////////////////////////////////////
    # Event: newEnty ----
    # process new entry button click

    observeEvent(input$newEntry, {

        # send binary to js file to determine which entry form to display
        if (max(responses$date) == format(Sys.Date(), "%Y-%m-%d")) {
            js$hideElem(id="main", session=session)
            js$showElem(id = "dialog_logged_done", session=session)
        } else {
            js$hideElem(id="main", session=session)
            js$showElem(id = "dialog_run_initial", session = session)
        }

        # run = "no"
        observeEvent(input$no, {
            js$hideElem(id = "dialog_run_initial", session = session)
            js$showElem(id = "dialog_run_no", session = session)

            # form action = cancel
            observeEvent(input$`form-no-cancel`, {
                js$hideElem(id="dialog_run_no", session = session)
                js$showElem(id="main", session = session)
            },ignoreInit=TRUE)

            # form action = submit
            observeEvent(input$`form-no-submit`, {
                js$consoleLog(value="no", session=session)

                # build data
                newData <- file$blankDF()
                newData$country <- profile$country
                newData$date <- format(Sys.Date(), "%Y-%m-%d")
                newData$reason_not_run <- NA
                newData$status <- "yes"
                newData$time_logged <- Sys.time()

                # save data
                saveRDS(rbind(responses, newData), "data/running_data.RDS")

                # show completed modal
                js$hideElem(id="dialog_run_no", session=session)
                js$showElem(id="dialog_logged_complete", session=session)

            },ignoreInit=TRUE)
        }, ignoreInit=TRUE)

        # run = "yes"
        observeEvent(input$yes, {
            js$hideElem(id="dialog_run_initial", session = session)
            js$showElem(id = "dialog_run_yes", session = session)

            # form action = cancel
            observeEvent(input$`form-yes-cancel`, {
                js$hideElem(id="dialog_run_yes", session = session)
                js$showElem(id="main", session = session)
            },ignoreInit=TRUE)

            # form action = submit
            observeEvent(input$`form-yes-submit`, {

                # create blank data.frame
                newData <- file$blankDF()
                newData$country <- profile$country
                newData$date <- format(Sys.Date(), "%Y-%m-%d")
                newData$distance <- ifelse(input$run_dist == "", NA, input$run_dist)
                newData$dur_est <- ifelse(input$run_dur == "", NA, input$run_dur)
                newData$max_temp <- ifelse(input$temp_min == "", NA, input$temp_min)
                newData$min_temp <- ifelse(input$temp_max == "", NA, input$temp_max)
                newData$route <- ifelse(input$run_route == "", NA, input$run_route)
                newData$run_temp <- ifelse(input$temp_run == "", NA, input$temp_run)
                newData$status <- "yes"
                newData$time_logged <- Sys.time()
                newData$time_run_start <- ifelse(input$runtime == "", NA, paste0("12/31/2099 ",input$runtime))

                # save data
                saveRDS(rbind(responses, newData), "data/running_data.RDS")

                # show completed modal
                js$hideElem(id="dialog_run_yes", session=session)
                js$showElem(id="dialog_logged_complete", session=session)

            },ignoreInit=TRUE)
        },ignoreInit=TRUE)
    }, ignoreInit = TRUE)

    # event for logged complete
    observeEvent(input$loggedComplete, {
        js$hideElem(id="dialog_logged_complete", session=session)
        js$showElem(id="main", session=session)
    }, ignoreInit=TRUE)
    
    # event for already logged
    observeEvent(input$`btn-back`, {
        js$hideElem(id="dialog_logged_done", session=session)
        js$showElem(id="main", session=session)
    }, ignoreInit=TRUE)

}
