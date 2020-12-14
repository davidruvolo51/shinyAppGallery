#'/////////////////////////////////////////////////////////////////////////////
#' FILE: server.R
#' AUTHOR: David Ruvolo
#' CREATED: 2018-04-07
#' MODIFIED: 2020-12-06
#' PURPOSE: server side
#' PACKAGES: see `app.R`
#' STATUS: in progress
#' COMMENTS: NA
#'/////////////////////////////////////////////////////////////////////////////
app_server <- function(input, output, session) {
    tsa <- golem::get_golem_options("tsa")
    tsa_sum <- golem::get_golem_options("tsa_sum")
    tsa_sum_yr <- golem::get_golem_options("tsa_sum_yr")

    # init vals
    map_click <- mod_leaflet_server(id = "airport_map", data = tsa_sum)

    selection_df <- reactive({
        if (is.null(map_click())) {
            tsa %>%
                filter(Field.Office == "DEN")
        } else {
            tsa %>%
                filter(Field.Office == map_click()$id)
        }
    })
    # observe({
    #     print(selection_df() %>% head())
    # })

    #'/////////////////////////////////////////////////////////////////////////
    #' ObserveEvent for Button Click
    observeEvent(input$moreInfo, {
        browsertools::show_elem(elem = "#report")

        # get summary data
        info <- tsa_sum[
            tsa_sum$codes == unique(selection_df()$Field.Office),
        ]
        report_office_title_server(id = "fo-title", title = info$names)
        report_office_summary_server(
            id = "fo-meta",
            city = info$city,
            state = info$state,
            code = info$codes,
            lat = info$lat,
            lng = info$lng
        )
        report_office_table_server(id = "fo-table", data = selection_df())

        #'////////////////////////////////////////
        # create a summary of violations the selected object
        selection_df_sum <- reactive({
            selection_df() %>%
                group_by(Field.Office, Allegation) %>%
                summarize(count = n()) %>%
                ungroup() %>%
                mutate(
                    rate = sapply(count, function(x) {
                        round(x / sum(count), 5) * 100
                    })
                )

        })

        #'////////////////////////////////////////
        # create a summary of dispositions based on the selected object
        dispositions_df <- reactive({
            selection_df() %>%
                group_by(Field.Office, Final.Disposition) %>%
                summarize(count = n()) %>%
                ungroup() %>%
                mutate(
                    rate = sapply(count, function(x) {
                        round(x / sum(count), 5) * 100
                    })
                )
        })

        #'////////////////////////////////////////
        # Ranking of Selected FO
        ranking_viz_server(
            id = "fo-ranking",
            data = tsa_sum,
            fo_id = info$codes
        )

        #'////////////////////////////////////////
        # Top 10 Allegations Chart
        selection_top_allegations <- reactive({
            selection_df_sum() %>%
                top_n(10) %>%
                arrange(-count)
        })

        hc_column_server(
            id = "fo-allegations-column",
            data = selection_top_allegations,
            x = Allegation,
            y = count,
            name = "Allegations",
            color = "#700548"
        )

        #'////////////////////////////////////////
        # Top 10 Resolutions Chart
        selection_top_resolutions <- reactive({
            selection_df_sum() %>%
                arrange(-count) %>%
                top_n(10)
        })
        hc_column_server(
            id = "fo-resolutions-column",
            data = selection_top_resolutions,
            x = Final.Disposition,
            y = count,
            name = "Resolutions",
            color = "#449DD1"
        )

        #'////////////////////////////////////////
        # Allegations over time compared with all Field Offices
        # summary by POSIXct year
        select_year_sum <- selection_df() %>%
            group_by(date = paste0(Year.Cased.Opened, "-01", "-01")) %>%
            summarize(count = n())

        # filter tsaYRS df for years that match selected data
        # not all field offices have records for all years
        tsa_subset <- tsa_sum_yr %>%
            filter(
                date >= min(select_year_sum$date),
                date <= max(select_year_sum$date)
            )

        hc_timeseries_server(
            id = "fo-allegations-time",
            data = select_year_sum,
            x = "date",
            y = "count",
            bg_data = tsa_subset,
            bg_yvar = "avg"
        )

        #'////////////////////////////////////////
        # Resolutions of Allegations For Selected Field Office
        mod_sankey_server(
            id = "fo-sankey",
            data = selection_df(),
            group = "Allegation",
            value = "Final.Disposition"
        )
    })
}
