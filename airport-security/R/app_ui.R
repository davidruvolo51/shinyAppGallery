#'//////////////////////////////////////////////////////////////////////////////
#' FILE: ui.R
#' AUTHOR: David Ruvolo
#' CREATED: 2016-03-15
#' MODIFIED: 2020-12-13
#' PURPOSE: application UI
#' PACKAGES: see `app.R`
#' STATUS: in.progress
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////

#' app_ui
#'
#' @param request require golem argument
#'
#' @noRd
app_ui <- function(request) {
    tagList(
        browsertools::use_browsertools(),
        tags$head(
            tags$meta(charset = "utf-8"),
            tags$meta(`http-equiv` = "X-UA-Compatible", content = "IE=edge"),
            tags$meta(
                name = "viewport",
                content = "width=device-width, initial-scale=1"
            ),
            tags$link(href = "styles.css", rel = "stylesheet")
        ),
        tags$nav(
        ),
        tags$main(
            id = "main",
            class = "main",
            tags$header(
                id = "title",
                class = "block header-block",
                tags$div(
                    class = "block-content",
                    tags$h1("TSA Allegations of Misconduct Data Visualization"),
                    tags$h2(
                        "Allegations of Federal Air Marshall Misconduct ",
                        "from 2002 - 2012"
                    )
                )
            ),
            tags$section(
                id = "introduction",
                class = "block",
                tags$div(
                    class = "block-content",
                    tags$h2("Introduction"),
                    tags$p(
                        "In a ProPublica article published earlier in 2016,",
                        tags$a(
                            href = "https://www.propublica.org/article/ tsa-releases-data-on-air-marshal-misconduct-7-years-after-we-asked",
                            "The TSA Releases Data on Airmarshal Misconduct, ",
                            "7 Years After We Asked"
                        ),
                        "Michael Grabell released a dataset on the number of ",
                        "cases of US federal air marshal misconduct. The ",
                        "dataset was  obtained by a Freedom of Information ",
                        "Request and made  available in ProPublica's  data ",
                        "store contained records of federal air marshal ",
                        "misconduct from 2002 to 2012."
                    ),
                    tags$p(
                        "Among all violations, some of the more interesting ",
                        "allegations include Criminal Arrest (148 cases), ",
                        "Criminal Conduct (58 cases), Discharge of Firearm,",
                        "(Intentional + Unintentional; 35 cases), Death ",
                        "(4 cases), Loss of Equipment (1226 cases), and ",
                        "Missed  Mission (953 cases).  The most common ",
                        "resolution was  Letter of Counsel (1833 cases) ",
                        "to the air marshal,  whereas a suspensions ranging ",
                        "from 1 to 60 days was second (933 cases)."
                    ),
                    tags$p(
                        "In the next section, use the map to view more ",
                        "information about a field office. Click the ",
                        "'View Report' button for a closer look at the ",
                        "allegations at the selected field office."
                    )
                )
            ),
            tags$section(
                id = "map",
                class = "block map-block",
                tags$div(
                    id = "map-wrapper",
                    class = "block-content",
                    tags$h2("Select a field office"),
                    tags$p(
                        "Click on point on the map, and then click ",
                        "'View Report'  for more information."
                    ),
                    mod_leaflet_ui(id = "airport_map"),
                    tags$button(
                        id = "moreInfo",
                        class = "shiny-bound-input action-button bt bt-primary",
                        "View Report"
                    )
                )
            ),
            tags$div(
                id = "report",
                class = "visually-hidden",
                tags$section(
                    id = "report-office",
                    class = "block",
                    tags$div(
                        class = "block-content",
                        report_office_title(id = "fo-title"),
                        report_office_summary(id = "fo-meta"),
                        report_office_table(id = "fo-table")
                    )
                ),
                tags$section(
                    id = "report-office-ranking",
                    class = "block",
                    tags$div(
                        class = "block-content",
                        tags$h2(
                            "How does this office rank among others in",
                            "terms of allegations?"
                        ),
                        ranking_viz(id = "fo-ranking")
                    )
                ),
                tags$section(
                    id = "report-office-allegations",
                    class = "block",
                    tags$div(
                        class = "block-content flex-2x2",
                        tags$div(
                            class = "flex-child",
                            tags$h2(
                                "What were the most frequent allegations ",
                                "and how were they resolved?"
                            )
                        ),
                        tags$div(
                            class = "flex-child col col-left",
                            tags$h3("What are the common allegations?"),
                            hc_bar(id = "fo_allegations")
                        ),
                        tags$div(
                            class = "flex-child col col-right",
                            tags$h3("What are the common resolutions?"),
                            hc_bar(id = "fo_resolutions")
                        )
                    )
                ),
                tags$section(
                    id = "report-office-allegations-ts",
                    class = "block",
                    tags$div(
                        class = "block-content",
                        tags$h2("How do allegations change over time?"),
                        hc_timeseries(id = "fo-allegations-time")
                    )
                ),
                tags$section(
                    id = "report-office-resolutions",
                    class = "block",
                    tags$div(
                        class = "block-content",
                        tags$h2("How where allegations resoved?"),
                        mod_sankey(id = "fo-sankey"),
                        tags$button(
                            id = "reset",
                            class = "shiny-bound-input action-button bt bt-secondary",
                            "Reset"
                        )
                    )
                )
            )
        ),
        tags$footer(
            class = "footer",
            tags$ul(
                class = "menu",
                tags$li(
                    class = "menu-item",
                    tags$a(
                        class = "menu-link",
                        href = "https://davidruvolo51.github.io/portfolio/",
                        "website"
                    )
                ),
                tags$li(
                    class = "menu-item",
                    tags$a(
                        class = "menu-link",
                        href = "https://github.com/davidruvolo51",
                        "github"
                    )
                ),
                tags$li(
                    class = "menu-item",
                    tags$a(
                        class = "menu-link",
                        href = "https://www.twitter.com/@dcruvolo",
                        "twitter"
                    )
                )
            )
        )
    )
}