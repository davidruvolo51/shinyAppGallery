#'//////////////////////////////////////////////////////////////////////////////
#' FILE: server.R
#' AUTHOR: David Ruvolo
#' CREATED: 2019-01-27
#' MODIFIED: 2020-05-22
#' PURPOSE: handle all user input and viz
#' PACKAGES: tbd
#' STATUS: in.progress
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////
server <- function(input, output, session) {

    browsertools::debug()

    # send values to ui via handlers
    source("scripts/data_01_summarize.R")
    browsertools::inner_html(elem = "#distance-tot", string = runData$highlights$dist_tot)
    browsertools::inner_html(elem = "#distance-avg", string = runData$highlights$dist_avg)
    browsertools::inner_html(elem = "#days-total", string = runData$highlights$days)
    browsertools::inner_html(elem = "#days-run-total", string = runData$highlights$runningDays)
    browsertools::inner_html(elem = "#days-run-week", string = runData$highlights$week_avg)
    browsertools::inner_html(elem = "#days-run-month", string = runData$highlights$month_avg)

    # render charts
    source("scripts/data_02_visualize.R")
    output$runDaysByMonth <- renderHighchart({ viz$runDaysByMonth })
    output$runDaysByWeekday <- renderHighchart({ viz$runDaysByWeekday })
    output$runsByRoute <- renderHighchart({ viz$runsByRoute })
    output$reasonsNotRun <- renderHighchart({ viz$reasonsNotRun })
    output$timeStartRun <- renderHighchart({ viz$timeStartRun })

    #'//////////////////////////////////////

    # render charts based on radio button input
    observe({
        #' default = days
        if (input$distanceToggle == "days") {
            output$distBy <- renderHighchart({
                viz$distanceByDay
            })
        }

        #' 'on' = distance
        if (input$distanceToggle == "months") {
            output$distBy <- renderHighchart({
                viz$distanceByMonth
                })
        }
    })

    observe({
        # default runs
        if(input$binToggle == "runs") {
            output$distanceBinned <- renderHighchart({
                viz$runsByDistanceBinned
            })
        }

        # default average time by bin
        if(input$binToggle == "time") {
            output$distanceBinned <- renderHighchart({
                viz$timeByDistanceBinned
            })
        }
    })

    #'//////////////////////////////////////
    # Event: newEnty ----
    # process new entry button click

    observeEvent(input$newEntry, {

        # send binary to js file to determine which entry form to display
        if (max(responses$date) == format(Sys.Date(), "%Y-%m-%d")) {
            browsertools::hide_elem(
                elem = "#main",
                css = "hidden"
            )
            browsertools::show_elem(
                elem = "#dialog_logged_done",
                css = "hidden"
            )
        } else {
            browsertools::hide_elem(
                elem = "#main",
                css = "hidden"
            )
            browsertools::show_elem(
                elem = "#dialog_run_initial",
                css = "hidden"
            )
        }

        #' run = "no"
        observeEvent(input$no, {
            browsertools::hide_elem(
                elem = "#dialog_run_initial",
                css = "hidden"
            )
            browsertools::show_elem(
                elem = "#dialog_run_no",
                css = "hidden"
            )

            # form action = cancel
            observeEvent(input$`form-no-cancel`, {
                browsertools::hide_elem(
                    elem = "#dialog_run_no",
                    css = "hidden"
                )
                browsertools::show_elem(
                    elem = "#main",
                    css = "hidden"
                )
            }, ignoreInit = TRUE)

            # form action = submit
            observeEvent(input$`form-no-submit`, {

                # build data
                browsertools::console_log(as.character(input$`no-reason-run`))
                newData <- file$blankDF()
                newData$country <- profile$country
                newData$date <- format(Sys.Date(), "%Y-%m-%d")
                newData$reason_not_run <- NA
                newData$status <- "yes"
                newData$time_logged <- Sys.time()

                # save data
                # saveRDS(rbind(responses, newData), "data/running_data.RDS")

                # show completed modal
                #js$hideElem(id="dialog_run_no", session=session)
                #js$showElem(id="dialog_logged_complete", session=session)
                browsertools::hide_elem(
                    elem = "#dialog_run_no",
                    css = "hidden"
                )
                browsertools::show_elem(
                    elem = "#dialog_logged_complete",
                    css = "hidden"
                )
                shiny::updateSelectInput(
                    session = session,
                    inputId = "no-reason-run",
                    selected = NULL
                )

            },ignoreInit = TRUE)
        }, ignoreInit = TRUE)

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
                # saveRDS(rbind(responses, newData), "data/running_data.RDS")

                # show completed modal
                js$hideElem(id="dialog_run_yes", session=session)
                js$showElem(id="dialog_logged_complete", session=session)

            },ignoreInit = TRUE)
        },ignoreInit = TRUE)
    }, ignoreInit = TRUE)

    # event for logged complete
    observeEvent(input$loggedComplete, {
        js$hideElem(id="dialog_logged_complete", session=session)
        js$showElem(id="main", session=session)
    }, ignoreInit = TRUE)
    
    # event for already logged
    observeEvent(input$`btn-back`, {
        js$hideElem(id="dialog_logged_done", session=session)
        js$showElem(id="main", session=session)
    }, ignoreInit = TRUE)
}
