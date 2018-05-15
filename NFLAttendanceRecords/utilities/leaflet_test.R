library(leaflet)

fb_mapDF <- read.csv("data/football_2008-2015.csv")

totalMapDF <- subset(fb_mapDF, Team == "Total")

footballMapDF <- subset(fb_mapDF, year == 2011 & Team != "Total")

library(ggplot2)
normalDistPlot <- ggplot(data = data.frame(x = c(-4,4)), aes(x = x)) +
    scale_x_discrete(limits=c(-4:4)) +
    stat_function(fun = dnorm)
normalDistPlot #+ geom_point(data = footballMapDF, aes(x = (TOT_TOT_z)))

ggsave("plot.png")

# new map
leaflet() %>%
    # set default view: US
    setView(
        lat = 38.858965, 
        lng = -92.362071, 
        zoom = 4) %>% 
    # add theme
    addProviderTiles("Stamen.Watercolor") %>%
    addTiles(options = providerTileOptions(opacity = 0.65)) %>%
    # add markers
    addCircleMarkers(
        # set positions
        lng = footballMapDF$Lon,
        lat = footballMapDF$Lat,
        # set markers
        radius = 10,
        color = footballMapDF$TOT_TOT_zcolor,
        fillOpacity = 0.8,
        layerId = footballMapDF$Team,
        # set popup
        popup = (paste0("<h3 align='center'>- ",footballMapDF$Team," -</h3>",
                        "<b>","Year: </b>",footballMapDF$year,"<br>",
                        "<b>Total Games: </b>", footballMapDF$TOT_Games,"<br>",
                        "<b>Home Games: </b>", footballMapDF$HomeGames,"<br>",
                        "<b>Road Games: </b>", footballMapDF$RoadGames, "<br>",
                        "<br>",
                        "<h5>Avg. Attendance</h5>",
                        "<b>All Games: </b>", footballMapDF$TOT_AVG,"<br>",
                        "<b>Home Games: </b>", footballMapDF$Home_AVG,"<br>",
                        "<b>Road Games: </b>", footballMapDF$Road_AVG,"<br>",
                        "<hr style='border-bottom: 1px solid'/>",
                        "<img src = '/users/davidcruvolo/Dropbox/Programming/R/R_Shiny/NFLAttendanceRecords/plot.png' height='50px' width='50px'/>"
        ))
    )

ui <- shinyUI(fluidPage(mainPanel(leafletOutput("map"))))

server <- shinyServer(function(input, output, session){
    # new map
    output$map <- renderLeaflet({
        # new map
        leaflet() %>%
            # set default view: US
            setView(
                lat = 38.858965, 
                lng = -92.362071, 
                zoom = 4) %>% 
            # add theme
            addProviderTiles("Stamen.Watercolor") %>%
            addTiles(options = providerTileOptions(opacity = 0.65)) %>%
            # add markers
            addCircleMarkers(
                # set positions
                lng = footballMapDF$Lon,
                lat = footballMapDF$Lat,
                # set markers
                color = footballMapDF$TOT_TOT_zcolor,
                fillOpacity = 0.8,
                layerId = footballMapDF$Team,
                # set popup
                popup = (paste0("<h3 align='center'>- ",footballMapDF$Team," -</h3>",
                                "<b>","Year: </b>",footballMapDF$year,"<br>",
                                "<b>Total Games: </b>", footballMapDF$TOT_Games,"<br>",
                                "<b>Home Games: </b>", footballMapDF$HomeGames,"<br>",
                                "<b>Road Games: </b>", footballMapDF$RoadGames, "<br>",
                                "<br>",
                                "<h5>Avg. Attendance</h5>",
                                "<b>All Games: </b>", footballMapDF$TOT_AVG,"<br>",
                                "<b>Home Games: </b>", footballMapDF$Home_AVG,"<br>",
                                "<b>Road Games: </b>", footballMapDF$Road_AVG,"<br>",
                                "<hr style='border-bottom: 1px solid'/>"
                ))
            )
    })
})

shinyApp(ui, server)
