#'//////////////////////////////////////////////////////////////////////////////
#' FILE: ui.R
#' AUTHOR: David Ruvolo
#' CREATED: 2016-03-15
#' MODIFIED: 2020-12-04
#' PURPOSE: application UI
#' PACKAGES: see `app.R`
#' STATUS: in.progress
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////

# ui
ui <- tagList(
    tags$head(
        tags$meta(charset = "utf-8"),
        tags$meta(`http-equiv` = "X-UA-Compatible", content = "IE=edge"),
        tags$meta(
            name = "viewport",
            content = "width=device-width, initial-scale=1"
        ),
        tags$link(href = "css/app.css", rel = "stylesheet")
    ),
    tags$nav(
    ),
    tags$main(
        id = "main",
        class = "main",
        tags$header(
            id = "title",
            class = "block",
            tags$div(
                class = "block-content",
                tags$h1("TSA Allegations of Misconduct Data Visualization"),
                tags$h2(
                    "Allegations of Federal Air Marshall Misconduct from 2002 - 2012"
                ),
                tags$a(
                    href = "#introduction",
                    class = "btn-style start",
                    "Start",
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
                        href = "https://www.propublica.org/article/tsa-releases-data-on-air-marshal-misconduct-7-years-after-we-asked",
                        "The TSA Releases Data on Airmarshal Misconduct, ",
                        "7 Years After We Asked"
                    ),
                    "Michael Grabell released a dataset on the number of cases",
                    "of US federal air marshal misconduct. The dataset was ",
                    "obtained by a Freedom of Information Request and made ",
                    "available in ProPublica's  data store contained records ",
                    "of federal air marshal misconduct from 2002 to 2012."
                ),
                tags$p(
                    "Among all violations, some of the more interesting ",
                    "allegations include Criminal Arrest (148 cases), ",
                    "Criminal Conduct (58 cases), Discharge of Firearm,",
                    "(Intentional + Unintentional; 35 cases), Death ",
                    "(4 cases), Loss of Equipment (1226 cases), and  Missed ",
                    "Mission (953 cases).  The most common resolution was ",
                    "Letter of Counsel (1833 cases) to the air marshal, ",
                    "whereas a suspensions ranging from 1 to 60 days was",
                    "second (933 cases)."
                ),
                tags$a(
                    href = "#instructions",
                    class = "btn-style-next",
                    "Next"
                )
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
                tags$a(href = "#map", "Next", class = "btn-style-next")
            )
        ),
        tags$section(
            id = "map",
            class = "block map-block",
            tags$div(
                id = "map-wrapper",
                class = "content-wrapper",
                tags$p(
                    "Click on point on the map, and then click 'View Report' ",
                    "for more information."
                ),
                leafletOutput("airportMap", width = "100%"),
                tags$button(
                    id = "moreInfo",
                    class = "shiny-bound-input action-button",
                    "View Report"
                )
            )
        ),
        tags$section(
            id = "report-ranking",
            class = "block",
            tags$div(
                class = "block-content",
                tags$h2(
                    "How does the",
                    tags$span(id = "selected-fo-code-3"),
                    "field office rank among other offices in terms of ",
                    "allegations?"
                ),
                plotOutput("rankingPlot"),
                tags$a(
                    href = "#report-common-cases",
                    class = "btn-style-next",
                    "Next"
                )
            )
        ),
        browsertools::hidden(
            tags$div(
                id = "report",
                # summary of field office
                tags$section(
                    class = "block",
                    tags$div(
                        class = "block-content",
                        # Summary of ___ Field Office
                        tags$h2(id = "report-title"),
                        # location, code, lat, lng
                        tags$p(id = "report-office-meta"),
                        # table: summary of allegations
                        # total allegations,
                        # year range (from - to)
                        # avg. allegations per year
                        # year with fewest allegations: year and count
                        # year with highest allegations: year and count
                        tags$div(id = "report-office-summary-table"),
                        tags$a(
                            class = "",
                            href = "",
                            "Next"
                        )
                    )
                ),
                # rank among other offices
                tags$section(
                    class = "block",
                    tags$div(
                        class = "block-content",
                        # how does __ rank among other offices?
                        tags$h2(id = "report-ranking-title"),
                        plotOutput("rankingPlot"),
                        tags$a(
                            href = "",
                            class = "btn-style-next",
                            "Next"
                        )
                    )
                ),
                # Grid layout for top 10 allegations and resolutions
                tags$section(
                    class = "block",
                    tags$div(
                        class = "block-content flex flex-50x50 flex-header-row",
                        tags$div(
                            tags$h2(
                                "What were the most frequent allegations and how were they resolved?"
                            )
                        ),
                        # allegations
                        tags$div(
                            class = "flex-child",
                            tags$h3("What are the common allegations?"),
                            highchartOutput("allegationsHC")
                        ),
                        # resolution
                        tags$div(
                            class = "flex-child",
                            tags$h3("What are the common resolutions?"),
                            highchartOutput("resolutionsHC")
                        ),
                        tags$a(
                            class = "btn-style-next",
                            href = "",
                            "Next"
                        )
                    )
                ),
                # allegations over time
                tags$section(
                    class = "section",
                    tags$div(
                        class = "section-content",
                        tags$h2("How do allegations change over time?"),
                        highchartOutput("allegationsTimeHC"),
                        tags$a(
                            class = "btn-style-next",
                            href = "#report-resolutions",
                            "Next"
                        )
                    )
                ),

                # flow of allegations to resolutions
                tags$section(
                    class = "block",
                    tags$div(
                        class = "block-content",
                        tags$h2("How where allegations resoved?"),
                        sankeyNetworkOutput("fieldOfficeSankey"),
                        tags$a(
                            class = "btn-style restart",
                            href = "#map",
                            "Restart"
                        )
                    )
                )
            )
        )
    ),
    tags$footer(
        class = "footer",
        tags$ul(
            tags$li(
                tags$a(
                    href = "https://davidruvolo51.github.io/",
                    "website"
                )
            ),
            tags$li(
                tags$a(
                    href = "https://github.com/davidruvolo51",
                    "github"
                )
            ),
            tags$li(
                tags$a(
                    href = "https://www.twitter.com/@dcruvolo",
                    "twitter"
                )
            )
        )
    ),
    tags$script(src = "js/app.js")
)
