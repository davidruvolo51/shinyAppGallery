#'////////////////////////////////////////////////////////////////////////////
#' FILE: mod_leaflet.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-12-06
#' MODIFIED: 2020-12-06
#' PURPOSE: generate leaflet map and return map click
#' STATUS: in.progress
#' PACKAGES: leaflet
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' leaflet ui
#'
#' @param id unique Id
#'
#' @noRd
mod_leaflet_ui <- function(id) {
    ns <- NS(id)
    leafletOutput(ns("map"), width = "100%")
}

#' leaflet server
#'
#' @param data input dataset
#'
#' @noRd
mod_leaflet_server <- function(data) {
    ns <- session$ns
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
                radius = ~sqrt(tot.cases * 2),
                stroke = FALSE,
                layerId = ~codes,
                fillOpacity = 1,
                fillColor = ~pal(tot.cases),
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
    return(input$map_marker_click)
}