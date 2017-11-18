#'////////////////////////////////////////////////
#' FILE: server.R
#' AUTHOR: David Ruvolo
#' CREATED: April 18, 2017
#' PURPOSE: "backend" for shinyapp
#' NOTES: needs euroCoffee.csv
#'////////////////////////////////////////////////
shinyServer(function(input, output, session){
    # make map
    output$coffeeMap <- renderLeaflet({
        leaflet(data = euroCoffee) %>%
            # set default view
            setView(lng = 4.2346672,lat = 55.396824, zoom=3) %>%
            # add theme
            # addTiles(providers$Thunderforest.Transport) %>%
            # addProviderTiles(provider = "Esri.WorldStreetMap") %>%
            addTiles() %>%
            # add markers
            addMarkers(lng = ~long,
                       lat = ~lat,
                       popup = paste0("<div class='map-popup text-center'>",
                                      "<h3>",euroCoffee$cafe,"</h3>",
                                      "<hr>",
                                      "<p>", euroCoffee$address,"</p>",
                                      "<a href=","'", 
                                      euroCoffee$href,"'",
                                      "><span class='glyphicon glyphicon-link'></span></a>",
                                      "</div>"),
                       clusterOptions = markerClusterOptions(
                           spiderfyOnMaxZoom = FALSE
                       ))
    })
    
    #' for resetting the zoom level to default
    observeEvent(input$defaultMapView,{
        leafletProxy("coffeeMap") %>%
            setView(lng = 4.2346672,lat = 55.396824, zoom=3)
    })
    
    })