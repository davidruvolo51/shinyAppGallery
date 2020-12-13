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
                    ),
                    action_link(to = "#start")
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
                    action_link(to = "#instructions")
                )
            ),
            tags$section(
                id = "instructions",
                class = "block",
                tags$div(
                    class = "block-content",
                    tags$h3("How to use this tool"),
                    tags$p(
                        "In the next section, use the map to view more ",
                        "information about a field office. Click the ",
                        "'View Report' button for a closer look at the ",
                        "allegations at the selected field office."
                    ),
                    action_link(to = "#map")
                )
            ),
            tags$section(
                id = "map",
                class = "block map-block",
                tags$div(
                    id = "map-wrapper",
                    class = "content-wrapper",
                    tags$p(
                        "Click on point on the map, and then click ",
                        "'View Report'  for more information."
                    ),
                    mod_leaflet_ui(id = "airport_map"),
                    tags$button(
                        id = "moreInfo",
                        class = "shiny-bound-input action-button",
                        "View Report"
                    )
                )
            ),
            browsertools::hidden(
                tags$div(
                    id = "report",
                    # summary of field office
                    tags$section(
                        id = "report-office",
                        class = "block",
                        tags$div(
                            class = "block-content",
                            report_office_title(id = "fo-title"),
                            report_office_summary(id = "fo-meta"),
                            # table: summary of allegations
                            # total allegations,
                            # year range (from - to)
                            # avg. allegations per year
                            # year with fewest allegations: year and count
                            # year with highest allegations: year and count
                            report_office_table(id = "fo-table"),
                            action_link(to = "#report-office-ranking")
                        )
                    ),
                    # rank among other offices
                    tags$section(
                        id = "report-office-ranking",
                        class = "block",
                        tags$div(
                            class = "block-content",
                            tags$h2(
                                "How does this office rank among others in",
                                "terms of allegations"
                            ),
                            ranking_viz(id = "fo-ranking"),
                            action_link(to = "#report-allegations")
                        )
                    ),
                    # Grid layout for top 10 allegations and resolutions
                    tags$section(
                        id = "report-office-allegations",
                        class = "block",
                        tags$div(
                            class = "block-content flex flex-50x50 flex-header-row",
                            tags$div(
                                tags$h2(
                                    "What were the most frequent allegations ",
                                    "and how were they resolved?"
                                )
                            ),
                            tags$div(
                                class = "flex-child",
                                tags$h3("What are the common allegations?"),
                                hc_column(id = "fo-allegations-column")
                            ),
                            tags$div(
                                class = "flex-child",
                                tags$h3("What are the common resolutions?"),
                                hc_column(id = "fo-resolutions-column")
                            ),
                            action_link(to = "#report-allegations-ts")
                        )
                    ),
                    # allegations over time
                    tags$section(
                        id = "report-office-allegations-ts",
                        class = "section",
                        tags$div(
                            class = "section-content",
                            tags$h2("How do allegations change over time?"),
                            hc_column(id = "fo-allegations-time"),
                            action_link(to = "#report-resolutions")
                        )
                    ),
                    # flow of allegations to resolutions
                    tags$section(
                        id = "report-office-resolutions",
                        class = "block",
                        tags$div(
                            class = "block-content",
                            tags$h2("How where allegations resoved?"),
                            mod_sankey(id = "fo-sankey"),
                            action_link(
                                label = "Restart",
                                to = "#map",
                                classnames = "link_restart"
                            )
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