#' app_ui
#'
#' @param request Internal parameter for `{shiny}`
#'
#' @noRd
app_ui <- function(request, countries) {

    countries <- golem::get_golem_options("countries")

    tagList(
        browsertools::use_browsertools(),
        tags$head(
            tags$meta(charset = "utf-8"),
            tags$meta(`http-quiv` = "x-ua-compatible", content = "ie=edge"),
            tags$meta(
                name = "viewport",
                content = "width=device-width, initial-scale=1"
            ),
            #' tags$link("href" = "css/styles.css", "rel" = "stylesheet")
            tags$link(rel = "stylesheet", href = "css/styles.min.css"),
            tags$style(
                HTML(
                    "table.dataTable.hover tbody tr:hover,
                    table.dataTable.display tbody tr:hover{
                        background-color: #FBD1A2;
                        color: black;
                        cursor: pointer;
                    }"
                )
            ),
            tags$title("Grid ID Finder")
        ),
        tags$a(
            href = "main",
            class = "screen-reader-text",
            "Skip to main content"
        ),
        tags$header(class = "header",
            tags$h1(class = "header-title", "Grid ID Finder"),
            tags$ul(
                class = "menu",
                `aria-label` = "page options",
                tags$li(
                    class = "menu-item",
                    tags$button(
                        id = "refresh",
                        type = "button",
                        class = "action-button shiny-bound-input btn btn-secondary",
                        accesskey = "r",
                        "Refresh"
                    )
                )
            )
        ),
        tags$main(
            class = "main",
            id = "main",
            `aria-label` = "main content",
            tags$aside(
                class = "sidebar sidebar-search",
                `aria-label` = "search",
                tags$section(class = "panel panel-search",
                    tags$div(Class = "inner-content",
                        tags$h2("Search for Id"),
                        tags$form(class = "form",
                            tags$label(
                                class = "label",
                                `for` = "country",
                                "Filter by Country"
                            ),
                            selectInput(
                                inputId = "country",
                                label = NULL,
                                choices = countries,
                                selected = "",
                                width = "100%"
                            ),
                            tags$label(
                                class = "label",
                                `for` = "city",
                                "Filter by City"
                            ),
                            uiOutput("input_city"),
                            tags$label(
                                class = "label",
                                `for` = "query",
                                "Search by name or phrase"
                            ),
                            tags$input(
                                type = "search",
                                id = "query",
                                class = "input",
                                accesskey = "q"
                            ),
                            tags$button(
                                id = "submit",
                                type = "button",
                                class = "action-button shiny-bound-input btn btn-primary btn-copy",
                                "Submit"
                            )
                        )
                    )
                ),
                tags$section(class = "panel panel-results",
                    tags$div(class = "inner-content",
                        tags$h2("Copy Result ID"),
                        tags$p(
                            "Select an entry in the results table to send the",
                            "output id below. Copy the result to your",
                            "clipboard for later use."
                        ),
                        tags$output(
                            class = "output",
                            id = "gridID",
                            "select an id"
                        ),
                        tags$button(
                            type = "button",
                            id = "copy",
                            accesskey = "c",
                            class = "action-button shiny-bound-input btn btn-primary",
                            `data-clipboard-text` = "",
                            "Copy ID"
                        )
                    )
                )
            ),
            tags$div(class = "results", `aria-label` = "search results",
                tags$div(class = "inner-content",
                    tags$h2("Results"),
                    DT::dataTableOutput("table")
                )
            )
        ),
        tags$footer(class = "footer",
            tags$ul(class = "menu",
                tags$li(
                    class = "menu-item",
                    tags$a(
                        class = "menu-link",
                        href = "https://grid.ac/",
                        "grid.ac"
                    )
                ),
                tags$li(class = "menu-item",
                    tags$a(
                        class = "menu-link",
                        href = "https://github.com/davidruvolo51/shinyAppGallery",
                        "github"
                    )
                )
            )
        ),
        tags$script(src = "assets/clipboard.js-master/dist/clipboard.min.js"),
        tags$script(type = "text/javascript", HTML("new ClipboardJS('#copy');"))
    )
}