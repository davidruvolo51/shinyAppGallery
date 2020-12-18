#'////////////////////////////////////////////////////////////////////////////
#' FILE: mod_report_title.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-12-07
#' MODIFIED: 2020-12-18
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
    tags$h2(id = NS(id, "report-title"))
}

#' mod_report_server
#'
#' Send title from server to client
#'
#' @param title
#'
#' @noRd
report_office_title_server <- function(id, structure, title) {
    moduleServer(
        id,
        function(input, output, session) {
            browsertools::inner_html(
                elem = paste0("#", id, "-report-title"),
                content = paste0("Summary of the ", title, " office")
            )
        }
    )
}

#'//////////////////////////////////////

#' report_office_summary
#'
#' @param id ui identifier
#'
#' @noRd
report_office_summary <- function(id) {
    tags$p(id = NS(id, "field-office-summary"), class = "fo-summary")
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
    moduleServer(
        id,
        function(input, output, session) {
            browsertools::inner_html(
                elem = paste0("#", id, "-field-office-summary"),
                content = tagList(
                    tags$span(city, ", ", state),
                    tags$span(code),
                    tags$span("(", lat, ",", lng, ")")
                )
            )
        }
    )
}

#'//////////////////////////////////////

#' report_office_table
#'
#' @param id ui identifier
#'
#' @noRd
report_office_table <- function(id) {
    uiOutput(NS(id, "dt"))
}


#' report_office_table_server
#'
#' @param id ui identifier
#' @param data data object to render into responsive table
#'
#' @noRd
report_office_table_server <- function(id, data) {
    moduleServer(
        id,
        function(input, output, session) {
            # format cases function
            format_cases <- function(x) {
                case_when(
                    x == 0 ~ "no cases",
                    x == 1 ~ "1 case",
                    x > 1 ~ paste0(x, " cases"),
                    TRUE ~ NA_character_
                )
            }

            # summarize data by year
            years <- reactive({
                data %>%
                    ungroup() %>%
                    group_by(Year.Cased.Opened) %>%
                    summarize(count = n()) %>%
                    ungroup()
            })

            # init summary object
            d <- reactive({
                data.frame(
                    prop = c(
                        "Total",
                        "Year Range",
                        "Avg. Cases by Year",
                        "Fewest Cases",
                        "Highest Cases"
                    ),
                    value = c(
                        NROW(data),
                        paste0(
                            min(years()$Year.Cased.Opened),
                            " - ",
                            max(years()$Year.Cased.Opened)
                        ),
                        format_cases(round(mean(years()$count), 2)),
                        format_cases(min(years()$count)),
                        format_cases(max(years()$count))
                    )
                )
            })

            # render table
            output$dt <- renderUI({
                datatable(
                    data = d(),
                    caption = "Summary of Allegations",
                    classnames = "field-office-table"
                )
            })
        }
    )
}