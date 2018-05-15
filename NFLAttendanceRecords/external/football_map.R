# create map for leaflet

    # MAIN TITLE----------------------------------------------------------------
    output$mapTitle <- renderUI({
        HTML(paste0("<h2>Average ",
                    input$plotvar, 
                    " Game Attendance for all NFL teams in ", 
                    input$years,
                    "</h2>"))
    })
    # LEAFLET-------------------------------------------------------------------
    output$map <- renderLeaflet({
        # plotting variable
        plotvar <- switch(input$plotvar,
                          "All" = footballMapDF()$TOT_AVG_zcolor,
                          "Home" = footballMapDF()$Home_AVG_zcolor,
                          "Away" = footballMapDF()$Road_AVG_zcolor)
        radiusvar <- switch(
            input$plotvar,
            "All" = footballMapDF()$TOT_AVG_sdInt,
            "Home" = footballMapDF()$Home_AVG_sdInt,
            "Away" = footballMapDF()$Road_AVG_sdInt
        )
        # color
        pal <- colorQuantile("RdYlBu",NULL, n = 8)
        
        # --------
        # MAKE MAP
        leaflet() %>%
            # set default view: US
            setView(
                lat = 38.858965, 
                lng = -92.362071, 
                zoom = 4) %>% 
            # add theme
            addProviderTiles("Stamen.Watercolor") %>%
            addTiles(options = providerTileOptions(opacity = 0.45)) %>%
            # add markers
            addCircleMarkers(
                # set positions
                lng = footballMapDF()$Lon,
                lat = footballMapDF()$Lat,
                #set strokes
                color = "#636363",
                weight = 2,
                # set markers
                fillColor = plotvar,
                fillOpacity = 0.9,
                radius = (abs(radiusvar * 10)),
                layerId = footballMapDF()$Team,
                # set popup
                popup = (paste0("<div class='popup-container'><h3 align='center'>- ",
                                footballMapDF()$Team," -</h3>",
                                "<b>","Year: </b>",footballMapDF()$year,"<br>",
                                "<b>Total Games: </b>", footballMapDF()$TOT_Games,"<br>",
                                "<b>Home Games: </b>", footballMapDF()$HomeGames,"<br>",
                                "<b>Road Games: </b>", footballMapDF()$RoadGames, "<br>",
                                "<br>",
                                "<h5>Avg. Attendance</h5>",
                                "<b>All Games: </b>", footballMapDF()$TOT_AVG,"<br>",
                                "<b>Home Games: </b>", footballMapDF()$Home_AVG,"<br>",
                                "<b>Road Games: </b>", footballMapDF()$Road_AVG,
                                "<div style='padding: 8px 0 5px 0; border-bottom: 1px solid #bdbdbd;'></div>",
                                "Click <p style='display:inline;color:#fc4e2a;'>'Go!'</p> to view more.",
                                "</div>"
                ))
            )
    })
    
    # LEGENDS--------------------------------------------------------------------
    output$legend <- renderUI({
        # custom gradient legend in descending order from high to low (7 boxes)
        HTML('<div id="legend-container">
                <div class="legend-blocks">
                    <svg width="40" height="40">
                      <rect width="400" height="35" style="fill:#f46d43;stroke-width:0;">
                    </svg>
                    <div class="legend-labs-top">High</div>
                </div>
                    
                <div class="legend-blocks">
                    <svg width="40" height="40">
                      <rect width="40" height="35" style="fill:#fdae61;stroke-width:0;">
                    </svg>
                </div>
                    
                <div class="legend-blocks">
                    <svg width="40" height="40">
                      <rect width="40" height="35" style="fill:#fee090;stroke-width:0">
                    </svg>
                </div>
                
                 <div class="legend-blocks">
                    <svg width="40" height="40">
                        <rect width="40" height="35" style="fill:#ffffbf;stroke-width:0">
                    </svg>
                </div>

                <div class="legend-blocks">
                    <svg width="40" height="40">
                        <rect width="40" height="35" style="fill:#e0f3f8;stroke-width:0">
                    </svg>
                </div>
             
                <div class="legend-blocks">
                    <svg width="40" height="40">
                        <rect width="40" height="35" style="fill:#abd9e9;stroke-width:0">
                    </svg>
                 </div>
                
                <div class="legend-blocks">
                    <svg width="40" height="30">
                        <rect width="40" height="35" style="fill:#74add1;stroke-width:0">
                    </svg>
                    <div class="legend-labs">Low</div>
                </div>
             </div>'
        )
    })
    
    # {-3,-2,-1,0,1,2,3},{"#74add1","#abd9e9","#e0f3f8","#ffffbf","#fee090","#fdae61","#f46d43"})
    
    # OBSERVE EVENT-------------------------------------------------------------
    # observe button click
    observeEvent(input$submit, {
        # get click
        click <- input$map_marker_click
        
        # logical for missing click
        if(is.null(click)){
            shinyjs::info("Sorry, I can't find anything. Please make a selection.")
        } else{
            
            # section borders
            output$sectionBorder <- renderUI({
                HTML("<hr style='border-bottom: 1px solid #bdbdbd'/>")
            })
            
            # selection Text - make title
            output$selectionTitle <- renderUI({
                HTML(paste0("<h2 style='text-align: center;'>",
                            "Attendance Records for the ", 
                            unique(selectedDF()$Team), " ", 
                            unique(selectedDF()$Team_Name),
                            "</h2>"))
            })
            
            # output chart legend
            output$chartLegend <- renderUI({
                HTML(paste0("<div class='legend-header'>Key:</div>
                    <br>
                    <div id='legend-container'>
                        <p class='legend-labels'>",
                            unique(selectedDF()$Team)," ",unique(selectedDF()$Team_Name),
                        "</p>
                        <svg height='10' width='90'>
                            <circle cx='45' cy='5' r='5' stroke='black' stroke-width='0' fill='#238443' />
                            <line x1='0' x2='90' y1='5' y2='5' style='stroke:#238443;stroke-width:1' />
                        </svg>
                        <br><br>
                        <p class='legend-labels'>National Avg.</p>
                        <svg height='10' width='90'>
                            <circle cx='45' cy='5' r='5' stroke='#737373' stroke-width='0' fill='#737373' />
                            <line x1='0' x2='90' y1='5' y2='5' style='stroke:#737373;stroke-width:1' />
                        </svg>
                    </div>"))
            })
            
            # make DF
            selectedDF <- reactive({
                football[football$Team %in% c(click$id),]
            })
        
        # PLOTLY----------------------------------------------------------------
    
        # SET MARGINS
        m = list(
            l = 60,
            r = 15,
            b = 50,
            t = 50,
            pad = 6
        )
            
        # SET AXIS
        xaxis_sty = list(
            title = "",
            tickangle = 90,
            dtick = 1, 
            range = c(2008, 2016)
        )
            
        output$NFL_team_TOT <- renderPlotly({

            #------------------
            # MAKE PLOT
            plot_ly(
                data = selectedDF(),
                x = year, 
                y = TOT_AVG,
                type = "scatter",
                mode = "markers+lines",
                group = Team,
                marker = list(color ="#238443"),
                name = unique(selectedDF()$Team),
                hoverinfo = "text",
                text = TOT_AVG
            ) %>% 
                #------------------
                # ADD TRACE
                add_trace(data = totals ,
                          x = year,
                          y = TOT_AVG,
                          type = "scatter",
                          mode = "markers+lines",
                          group = Team,
                          marker = list(color = "#737373"),
                          name = "",
                          hoverinfo="text",
                          text = TOT_AVG
                ) %>%
                
                #------------------
                # SET LAYOUT
                layout(hovermode = "closest", margins = m, 
                       title = "All Games",
                       showlegend = FALSE,
                       xaxis = xaxis_sty,
                       yaxis = list(title = "Avg. Attendance per Game")) %>% 
                #------------------
                # SET CONFIG
                config(displayModeBar = F)
        })
        
        # PLOTLY----------------------------------------------------------------
        # make plotly for HOME
        output$NFL_team_HOME <- renderPlotly({
            
            #------------------
            # MAKE PLOT
            plot_ly(
                data = selectedDF(),
                x = year, 
                y = Home_AVG,
                type = "scatter",
                mode = "markers+lines",
                group = Team,
                marker = list(color ="#238443"),
                name = unique(selectedDF()$Team),
                hoverinfo = "text",
                text = Home_AVG
            ) %>% 
                #------------------
                # ADD TRACE
                add_trace(data = totals ,
                          x = year,
                          y = Home_AVG,
                          type = "scatter",
                          mode = "markers+lines",
                          group = Team,
                          marker = list(color = "#737373"),
                          name = "Total",
                          hoverinfo="text",
                          text = Home_AVG
                ) %>%
                
                #------------------
                # SET LAYOUT
                layout(hovermode = "closest", margins = m, 
                       title = "Home Games",
                       showlegend = FALSE,
                       xaxis = xaxis_sty,
                       yaxis = list(title = "")) %>% 
                
                #------------------
                # SET CONFIG
                config(displayModeBar = F)
        })
        
        # PLOTLY----------------------------------------------------------------
        # PLOTLY FOR ROAD AVG
        output$NFL_team_ROAD <- renderPlotly({
            
            #------------------
            # MAKE PLOT
            plot_ly(
                data = selectedDF(),
                x = year, 
                y = Road_AVG,
                type = "scatter",
                mode = "markers+lines",
                group = Team,
                marker = list(color ="#238443"),
                name = unique(selectedDF()$Team),
                hoverinfo = "text",
                text = Road_AVG
            ) %>% 
                #------------------
                # ADD TRACE
                add_trace(data = totals ,
                          x = year,
                          y = Road_AVG,
                          type = "scatter",
                          mode = "markers+lines",
                          group = Team,
                          marker = list(color = "#737373"),
                          name = "Total",
                          hoverinfo="text",
                          text = Road_AVG
                ) %>%
                
                #------------------
                # SET LAYOUT
                layout(hovermode = "closest", margins = m, 
                       title = "Road Games",
                       showlegend = FALSE,
                       xaxis = xaxis_sty,
                       yaxis = list(title = "")) %>% 
                
                #------------------
                # SET CONFIG
                config(displayModeBar = F)
        })
    } # end else
})
