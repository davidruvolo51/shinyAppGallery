#' ////////////////////////////////////////////////////////////////////////////
#' FILE: mod_leaflet.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-12-06
#' MODIFIED: 2020-12-06
#' PURPOSE: generate leaflet map and return map click
#' STATUS: in.progress
#' PACKAGES: leaflet
#' COMMENTS: NA
#' ////////////////////////////////////////////////////////////////////////////

#' leaflet ui
#'
#' @param id unique Id
#'
#' @noRd
mod_leaflet_ui <- function(id) {
    leafletOutput(NS(id, "map"), width = "100%")
}

#' leaflet server
#'
#' @param id unique identifer
#' @param data input dataset
# ' @param click reactive value for capturing map click
#'
#' @noRd
mod_leaflet_server <- function(id, data) {
    moduleServer(
        id,
        function(input, output, session) {
            output$map <- renderLeaflet({
                pal <- colorNumeric("Blues", data$tot.cases, reverse = FALSE)
                leaflet(
                    data = data,
                    options = leafletOptions(
                        attributionControl = FALSE
                    )
                ) %>%
                    setView(
                        lat = 38.858965,
                        lng = -92.362071,
                        zoom = 4
                    ) %>%
                    addProviderTiles(
                        "CartoDB.DarkMatterNoLabels",
                        options = providerTileOptions(opacity = 1)
                    ) %>%
                    addCircleMarkers(
                        lng = ~lng,
                        lat = ~lat,
                        radius = ~ sqrt(tot.cases * 2),
                        stroke = FALSE,
                        layerId = ~codes,
                        fillOpacity = 1,
                        fillColor = ~ pal(tot.cases),
                        popup = paste0(
                            "<div class='bubble'>",
                            "<h2>", data$names, "</h2>",
                            "<p class='location'>",
                            data$city, ", ", data$state, "</p>",
                            "<p><span>", data$tot.cases, "</span>",
                            " allegations of misconduct.</p>",
                            "</div>"
                        )
                    ) %>%
                    addLegend(
                        position = "bottomright",
                        pal = pal,
                        values = ~tot.cases,
                        title = "Misconducts",
                        opacity = 1
                    )
            })

            # return map click
            click <- reactive({
                input$map_marker_click
            })

            return(click)
        }
    )
}