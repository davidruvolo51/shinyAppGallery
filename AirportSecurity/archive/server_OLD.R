#===========
# SERVER.R
#===========
shinyServer(function(input, output, session) {
    #======================================
    # Test leaflet
    output$AirportMap <- renderLeaflet({
        leaflet() %>%
            setView(
                lat = 38.858965, 
                lng = -92.362071, 
                zoom = 4) %>% 
            addProviderTiles("CartoDB.Positron") %>%
            addCircleMarkers(lng = airports2$lon, 
                            lat = airports2$lat, 
                            color = airports2$z_color,
                            layerId = airports2$codes,
                            popup = paste0("Name: ", airports2$names,"<br>",
                                           "Location: ", airports2$city, ", ", airports2$state, "<br>",
                                           "Cases: ",airports2$tot.cases))
    })
    #======================================
    # observe map clicks + create dataframe
    originalDF <- reactive({
        click <- input$AirportMap_marker_click
        if(is.null(click)){
            df <- subset(tsa, Field.Office == "DEN") # will put national totals here
        } else{
            df <- tsa[grep(click$id,tsa$Field.Office),]
        } 
        return(df)
        #text <- paste("Lattitude: ", click$lat, "Longitude: ", click$lng)
        #text2 <- paste("You've selected point: ", click$id)
        AirportMap$clearPopups()
    })
    #======================================
    # MAKE PLOTLY MAP
    output$AirPortMAP <- renderPlotly({
        g <- list(
            scope = 'usa',
            projection = list(type = 'albers usa'),
            showland = TRUE,
            countrywidth = 1,
            landcolor = toRGB("gray85"),
            showlakes = T,
            lakecolor = toRGB('white'),
            subunitcolor = toRGB("white"),
            countrycolor = toRGB("white")
        )
        # =========================================
        # MAKE MAP
        plot_ly(airports2, lon = lon, lat = lat, type = "scattergeo", 
                locationmode = "USA-states", hoverinfo = "text",
                marker = list(colorbar = list(title = "No. Records",
                                              nticks = 8, len = 0.75), 
                              size = size,
                              colorscale = "Portland",
                              opacity = 0.8, symbol = 'circle'),
                text = paste("Cases: ", tot.cases,"<br>",
                            "Name: ",names, "<br>",
                            "Location: ",city, ", ",state),
                color = tot.cases) %>% layout(title = "",geo = g) %>% config(displayModeBar = F)
    })
    #======================================
    # MASTER SELECTED DATAFRAME
    #originalDF <- reactive({
    #    events <- event_data("plotly_click")
    #    if(is.null(events)){
    #        df <- subset(tsa, Field.Office == "DEN") # will put national totals here
    #    } else{
    #        clicked.pos.num <- as.numeric(event_data("plotly_click")$pointNumber)
    #        selected.airport <- subset(airports2, occurrence == clicked.pos.num)
    #        df <- tsa[grep(selected.airport$codes,tsa$Field.Office),]
    #    } 
    #    return(df)
    #})
    #======================================
    # SUM OF SELECTED DATAFRAME 
    summedDF <- reactive({
        # get sum of selection + MAKE DF
        df <- data.frame(originalDF() %>% 
                             group_by(Allegation) %>% 
                             summarise(records = length(Field.Office)))
        # create rate variable
        df$rate <- sapply(df$records,function(x){round(x/sum(df$records),4)})
        # LOOP: for creating tooltip info + parsed labels for Y axis
        for(i in 1:NROW(df)){
            df$hover.text.tooltip[i] <- paste0(df$records[i], " cases (or ",
                                                df$rate[i]*100,"%) of '",
                                                df$Allegation[i],"'")
            df$Allegation.Parsed[i] <- paste(substr(df$Allegation[i], 1,5),"...")
        }
        # apply unique Field.Office code
        df$codes = unique(originalDF()$Field.Office)
        # rename columns
        colnames(df) <- c("Allegation","cases","rate","tooltip.text","parsed.labs","group")
        return(df)
    })
    #======================================
    # SUM OF FINAL.DISPOSITIONS
    dispositionDF <- reactive({
        # get sum of selection + MAKE DF
        df <- data.frame(originalDF() %>% 
                             group_by(Final.Disposition) %>% 
                             summarise(records = length(Field.Office)))
        # create rate variable
        df$rate <- sapply(df$records,function(x){round(x/sum(df$records),4)})
        # LOOP: for creating tooltip info + parsed labels for Y axis
        for(i in 1:NROW(df)){
            df$hover.text.tooltip[i] <- paste0(df$records[i], " cases (or ",
                                               df$rate[i]*100,"%) of '",
                                               df$Final.Disposition[i],"'")
            df$Disposition.Parsed[i] <- paste(substr(df$Final.Disposition[i], 1,5),"...")
        }
        # apply unique Field.Office code
        df$codes = unique(originalDF()$Field.Office)
        # rename columns
        colnames(df) <- c("Final.Disposition","cases","rate","tooltip.text","parsed.labs","group")
        return(df) 
    })
    #======================================
    # RENDER HORIZONTAL BAR CHART
    output$airportPlot <- renderPlotly({
        # MAKE PLOT
        #-------------
        # Trace 1: Airport Selected DF
        plot_ly(
            data = summedDF(),
            y = parsed.labs,
            x = cases,
            type = "bar",
            orientation = "h",
            hoverinfo = "text",
            #marker = list(color = toRGB("#377EB8")),
            text = paste(unique(group),"<br>",
                         "Allegation: ",Allegation,"<br>", 
                         "Cases: ", cases, " (",rate*100,"%)")
        ) %>% 
            #------------------
            # Layout Options
            layout(hovermode = "closest" , 
                    xaxis = list(title = "No. of Allegations"),
                    yaxis = list(title = ""))
    })
    #======================================
    # RENDER SUSPENSION DONUT CHART
    output$suspensionPlot <- renderChart2({
        # subset data according to map selection
        # subset suspensions only
        suspensions <- originalDF()[grep("Suspension",originalDF()$Final.Disposition),]
        
        # find the count of each unique suspension 
        # this would be done using dplyr 
        # number of entries per unique string
        sus <- data.frame(suspensions %>% group_by(Final.Disposition) %>% 
                              summarise(value = length(Final.Disposition)))
        sus$rate <- sapply(sus$value,function(x)round(x/sum(sus$value),4))
        
        # create a new category for number of suspensed days
        sus$label = sus$Final.Disposition
        sus$label <- gsub(pattern = "Suspension",replacement = " ",
                          x = sus$label) # del sus.. 
        sus$label <- gsub(pattern = " +$", replacement = "",
                          x = sus$label) # trailing
        sus$label <- gsub(pattern = "[[:space:]]", replacement = "", 
                          x = sus$label) # others
        sus$label <- gsub(pattern = "Day",replacement = " Days",
                          x = sus$label)   # del day..
        sus$day_cat <- gsub(pattern = " Days", replacement = " ", 
                            x = sus$label)
        sus$day_cat <- gsub(pattern = " +$", replacement = "",
                            x = sus$day_cat) # trailing
        sus$day_cat <- gsub(pattern = "[[:space:]]", replacement = "", 
                            x = sus$day_cat) # others
        sus$day_cat <- as.numeric(sus$day_cat)
        sus <- sus[order(sus$day_cat),]
        
        # make donut chart
        # donut charts only work with variable names where x = label 
        sus.plot <-mPlot(x = "label", y = "rate" , data = sus, type = "Donut")
        sus.plot$addParams(title = "Breakdown of Suspension Cases",
                           dom = "suspensionPlot")
        return(sus.plot)
    })
    #======================================
    # RENDER TEXT: TITLE
    output$title <- renderUI({
        HTML(paste0(h1("Transportation Security Administration"),"\n" ,
                    h3("Allegations of Conduct Data from 2002 - 2012")))
    })
    #======================================
    # RENDER TEXT: INSTRUCTIONS
    output$instructions <- renderText({
        HTML(paste0(
        h4("Instructions:"),"\n",
        "Use the map to view number of allegations by airport. Hover over a 
        point to view a quick summary of the data.Click on the airport 
        (i.e., on a bubble) to generate a summary of allegations. Zoom in on an
        area using the mouse. Double click anywhere on the map to reset the map."
        ))
    })
    #======================================
    # RENDER TEXT: PROFILE
    output$profile <- renderUI({
        includeHTML(knitr::knit("profile.Rmd"))
    })
    #======================================
})
# END SERVER
#===========