#'//////////////////////////////////////
#' FILE: server.R
#' AUTHOR: David Ruvolo
#' CREATED: April 24, 2017
#' PURPOSE: server for my travel map
#' PACKAGES: leaflet
#' NOTES:
#'//////////////////////////////////////
shinyServer(function(input, output, session){
    
    #' gather stats
    shinyjs::html(id="totalConts", html = paste0(mapDF %>% distinct(.,region) %>% count(), " Continents "))
    shinyjs::html(id="totalCountries", 
                  html = paste0(mapDF %>% distinct(., country_name) %>% count(), " Countries "))
    shinyjs::html(id="totalPlaces", html = paste0(mapDF %>% NROW(), " Places "))
    
    #' leaflet output
    output$myAdventures <- renderLeaflet({
        leaflet(data = mapDF) %>%
    setView(lng = -32.4831721,
            lat = 37.2583959, zoom=1) %>%
    addTiles() %>%
    # addMiniMap(toggleDisplay = T) %>%
    addMarkers(lng = ~long,
               lat = ~lat,
               popup = paste0("<div class='popup-box'>",
                              "<h3>",mapDF$titles,"</h3>",
                              "<hr/>",
                              "<i class='fa fa-",mapDF$icons," popupIcons'></i>","<br>",
                              "<h5>Address</h5>",
                              "<p>",mapDF$address,"</p>",
                              "<a href='",mapDF$google_urls,"'>",
                              "<i class='fa fa-map-o'></i>",
                              "&nbsp;&nbsp;","Add to your google maps",
                              "</a>","<br>",
                              "<a href='https://www.google.com/search?q=",
                              paste(mapDF$titles, mapDF$city, mapDF$country_name, sep="+"),"'>",
                              "<i class='fa fa-google'></i>",
                              "&nbsp;&nbsp;","Search for more information",
                              "</a>",
                              "</div>"),
               clusterOptions = markerClusterOptions())
        
    })
    
    #' observeEvent for reset button
    observeEvent(input$mapReset,{
        
        #' reset map view to defaults
        leafletProxy("myAdventures") %>%
        setView(lng = -32.4831721,
                lat = 37.2583959, 
                zoom=1)
        
    })
    
    #' show app
    hide(id = "loadingScreen", anim = TRUE, animType = "fade") 
    show(id = "travelApp")
    
})