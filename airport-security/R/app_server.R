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

    map_click <- mod_leaflet_server(id = "airport_map", data = tsa_sum)

    selection_df <- reactive({
        if (is.null(map_click())) {
            tsa %>%
                filter(Field.Office == "DEN") %>%
                ungroup()
        } else {
            tsa %>%
                filter(Field.Office == map_click()$id) %>%
                ungroup()
        }
    })

    #'//////////////////////////////////////
    #' ObserveEvent for Button Click
    observeEvent(input$moreInfo, {
        browsertools::remove_css("#report", "visually-hidden")

        # get summary data
        info <- reactive({
            tsa_sum %>%
                filter(codes == unique(selection_df()$Field.Office))
        })
        report_office_title_server(id = "fo-title", title = info()$names)
        report_office_summary_server(
            id = "fo-meta",
            city = info()$city,
            state = info()$state,
            code = info()$codes,
            lat = info()$lat,
            lng = info()$lng
        )
        report_office_table_server(id = "fo-table", data = selection_df())

        #'////////////////////////////////////////
        # create a summary of violations the selected object
        allegations_df <- reactive({
            selection_df() %>%
                ungroup() %>%
                group_by(Field.Office, Allegation) %>%
                summarize(count = n()) %>%
                mutate(
                    rate = sapply(count, function(x) {
                        round(x / sum(count), 5) * 100
                    })
                ) %>%
                ungroup()

        })

        # create a summary of dispositions based on the selected object
        dispositions_df <- reactive({
            selection_df() %>%
                group_by(Field.Office, Final.Disposition) %>%
                summarize(count = n()) %>%
                mutate(
                    rate = sapply(count, function(x) {
                        round(x / sum(count), 5) * 100
                    })
                ) %>%
                ungroup()
        })

        #'////////////////////////////////////////
        # Ranking of Selected FO
        ranking_viz_server(
            id = "fo-ranking",
            data = tsa_sum,
            fo_id = info()$codes
        )

        #'////////////////////////////////////////
        # Top 10 Allegations Chart
        selection_top_allegations <- reactive({
            allegations_df() %>%
                top_n(10) %>%
                arrange(-count)
        })

        hc_bar_server(
            id = "fo_allegations",
            data = selection_top_allegations(),
            x = "Allegation",
            y = "count",
            name = "Allegations",
            color = "#700548"
        )

        #'////////////////////////////////////////
        # Top 10 Resolutions Chart
        selection_top_resolutions <- reactive({
            dispositions_df() %>%
                arrange(-count) %>%
                top_n(10)
        })

        hc_bar_server(
            id = "fo_resolutions",
            data = selection_top_resolutions(),
            x = "Final.Disposition",
            y = "count",
            name = "Resolutions",
            color = "#449DD1"
        )

        #'////////////////////////////////////////
        # Allegations over time compared with all Field Offices
        # summary by POSIXct year
        select_year_sum <- reactive({
            selection_df() %>%
                mutate(date = paste0(Year.Cased.Opened, "-01", "-01")) %>%
                group_by(date) %>%
                summarize(count = n()) %>%
                ungroup()
        })

        # # filter tsaYRS df for years that match selected data
        # # not all field offices have records for all years
        tsa_subset <- reactive({
            tsa_sum_yr %>%
                filter(
                    date >= min(select_year_sum()$date),
                    date <= max(select_year_sum()$date)
                )
        })

        hc_timeseries_server(
            id = "fo-allegations-time",
            data = select_year_sum(),
            x = "date",
            y = "count",
            bg_data = tsa_subset(),
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
