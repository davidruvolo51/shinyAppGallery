#'////////////////////////////////////////////////////////////////////////////
#' FILE: mod_report_title.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-12-07
#' MODIFIED: 2020-12-07
#' PURPOSE: generate report title
#' STATUS: in.progress
#' PACKAGES: NA
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' report_title
#'
#' Component for generating report title from server-side data. Text is
#' rendered from the server
#'
#' @param id instance ID
#'
#' @noRd
report_office_title <- function(id) {
    ns <- NS(id)
    tags$h2(id = ns("report-title"))
}

#' mod_report_server
#'
#' Send title from server to client
#'
#' @param title
#'
#' @noRd
report_office_title_server <- function(id, structure, title) {
    ns <- session$ns
    browsertools::inner_html(
        elem = paste0("#", ns("report-title")),
        content = paste0("Summary of the ", title, " office")
    )
}

#'//////////////////////////////////////

#' report_office_summary
#'
#' @param id ui identifier
#'
#' @noRd
report_office_summary <- function(id) {
    ns <- NS(id)
    tags$p(id = ns("field-office-summary"), class = "fo-summary")
}

#' report_office_summary_server
#'
#' @param id ui identifier
#' @param city location of the office (city)
#' @param state location of the office (state)
#' @param code office id
#' @param lat location of the office (lat)
#' @param lng location of the office (lng)
#'
#' @noRd
report_office_summary_server <- function(id, city, state, code, lat, lng) {
    ns <- session$ns
    browsertools::inner_html(
        elem = paste0("#", ns("field-office-summary")),
        content = tagList(
            tags$span(city, ", ", state),
            tags$span(code),
            tags$span("(", lat, ",", lng, ")")
        )
    )
}

#'//////////////////////////////////////

#' report_office_table
#'
#' @param id ui identifier
#'
#' @noRd
report_office_table <- function(id) {
    ns <- NS(id)
    uiOutput(id = "field-office-datatable")
}


#' report_office_table_server
#'
#' @param id ui identifier
#' @param data data object to render into responsive table
#'
#' @noRd
report_office_table_server <- function(id, data) {
    ns <- session$ns

    # format cases function
    format_cases <- function(x) {
        case_when(
            x == 0 ~ "no cases",
            x == 1 ~ "1 case",
            x > 1 ~ paste0(x, " cases"),
            TRUE ~ NA
        )
    }

    # summarize data by year
    years <- data() %>%
        group_by(Year.Cased.Opened) %>%
        summarize(count = n())

    # init summary object
    d <- data.frame(
        prop = c(
            "Total",
            "Year Range",
            "Avg. Cases by Year",
            "Fewest Cases",
            "Highest Cases",
        ),
        value = c(
            NROW(data()),
            paste0(
                min(years$Year.Cased.Opened),
                " - ",
                max(years$Year.Cased.Opened)
            ),
            format_cases(round(mean(years$count), 2)),
            format_cases(min(years$count)),
            format_cases(max(years$count))
        )
    )

    # render table
    output$`field-office-datatble` <- renderUI({
        datatable(
            data = d,
            caption = "Summary of Allegations",
            classnames = "field-office-table"
        )
    })
}