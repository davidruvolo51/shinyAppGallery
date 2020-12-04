#'//////////////////////////////////////////////////////////////////////////////
#' FILE: server.R
#' AUTHOR: David Ruvolo
#' CREATED: 07 April 2018
#' MODIFIED: 07 April 2018
#' PURPOSE: server side
#' PACKAGES: see global.R
#' STATUS: in progress
#' COMMENTS: major update in 2018
#'//////////////////////////////////////////////////////////////////////////////

app_server <- function(input, output, session) {

    #'////////////////////////////////////////
    # Leaflet Map
    output$airportMap <- renderLeaflet({
        
        # set color palette according to total.cases
        pal <- colorNumeric("Blues", tsaSUM$tot.cases, reverse = F)
        
        # new map
        leaflet(data = tsaSUM, options=leafletOptions(attributionControl=FALSE)) %>%
            # set view
            setView(lat = 38.858965, lng = -92.362071, zoom = 4) %>%
            
            # set theme
            addProviderTiles("CartoDB.DarkMatterNoLabels",
                             options=providerTileOptions(opacity = 1)) %>%
            
            # add markers
            addCircleMarkers(
                lng = ~lng, 
                lat = ~lat,
                radius = ~sqrt(tot.cases * 2),
                stroke = FALSE,
                layerId = ~codes,
                fillOpacity =1,
                fillColor = ~pal(tot.cases),
                popup = (paste0(
                    "<div class='bubble'>",
                    "<h2>", tsaSUM$names,"</h2>",
                    "<p class='location'>", 
                    tsaSUM$city, ", ",tsaSUM$state,"</p>",
                    "<p><span>",tsaSUM$tot.cases,"</span>",
                    " allegations of misconduct.</p>",
                    "</div>"
                )
                )) %>%
            # add legend
            addLegend(position = "bottomright",pal=pal, values = ~tot.cases,
                      title="Misconducts",opacity = 1)
    })
    
    
    #'//////////////////////////////////////////////////////////////////////////////
    #' ObserveEvent for Button Click
    observeEvent(input$moreInfo,{
        
        # move to report
        shinyjs::runjs("document.getElementById('report').scrollIntoView();")
        
        # observe map clicks + create dataframe (default = DENVER)
        
        mapClick <<- input$airportMap_marker_click
        
        
        # gather selected data
        selectionDF <- reactive({
            
            # make a default selection
            if(is.null(mapClick)){
                
                df <- subset(tsaALL, Field.Office == "DEN")
                
            } else{
                df <- tsaALL[tsaALL$Field.Office == mapClick$id,]
            } 
            
            
            # return
            df
        })
        
        #'////////////////////////////////////////
        # Send Stats to UI
        
        # get summary data
        info <- tsaSUM[tsaSUM$codes == unique(selectionDF()$Field.Office),]
        
        # title
        title = info$names 
        shinyjs::html(id="selected-fo-title",html = title)
        
        # send location
        shinyjs::html(id="selected-fo-location", paste0(info$city, ", ", info$state))
        shinyjs::html(id="selected-fo-lat",info$lat)
        shinyjs::html(id="selected-fo-lng",info$lng)
        
        # send code
        shinyjs::html(id="selected-fo-code-1", info$codes)
        shinyjs::html(id="selected-fo-code-2", info$codes)
        shinyjs::html(id="selected-fo-code-3", info$codes)
        
        
        # count of entries
        count = NROW(selectionDF())
        shinyjs::html(id="selected-fo-count",count)
        
        
        # summary by year
        years <- selectionDF() %>% group_by(Year.Cased.Opened) %>% summarize(count = n())
        
        # avg
        years_mean <- round(mean(years$count),2)
        years_mean_out <- ifelse(years_mean == 0, "no cases", 
                                 ifelse(years_mean == 1,"1 case",
                                        paste0(years_mean, " cases")))
        # min
        years_min <- years %>% top_n(-1)
        years_min_out <- ifelse(info$code == "DFT",
                                "Each year had 1 case",
                                ifelse(years_min$count == 0, "no cases",
                                       ifelse(years_min$count == 1,"1 case",
                                              paste0(years_min$count, " cases"))))
        years_min_yr_out <- ifelse(info$codes == "DFT","",
                                   ifelse(NROW(years_min) == 1,
                                          years_min$Year.Cased.Opened,
                                          ifelse(NROW(years_min) == 2,
                                                 paste0(unique(years_min$Year.Cased.Opened),collapse = " and "),
                                                 paste0(unique(years_min$Year.Cased.Opened),collapse = ", "))))
        years_date_earliest <- min(years$Year.Cased.Opened)
        years_date_recent <- max(years$Year.Cased.Opened)
        years_range_out <- paste0(years_date_earliest, " - ", years_date_recent)
        
        # max
        years_max <- years %>% top_n(1)
        years_max_out <- ifelse(info$codes == "DFT","Each year had 1 case",
                                ifelse(years_max$count == 0, "no cases",
                                       ifelse(years_max$count == 1,"1 case",
                                              paste0(years_max$count, " cases"))))
        years_max_yr_out <- ifelse(info$codes == "DFT","",ifelse(NROW(years_max) == 1,
                                                                 years_max$Year.Cased.Opened,
                                                                 ifelse(NROW(years_max) == 2,
                                                                        paste0(unique(years_max$Year.Cased.Opened),collapse = " and "),
                                                                        paste0(unique(years_max$Year.Cased.Opened),collapse = ", "))))
        
        
        # send year data to ui
        shinyjs::html(id="selected-fo-year-range",html= years_range_out)
        shinyjs::html(id="selected-fo-year-avg", html = years_mean_out)
        shinyjs::html(id="selected-fo-year-min", html = years_min_out)
        shinyjs::html(id="selected-fo-year-max", html = years_max_out)
        shinyjs::html(id="selected-fo-year-min-yr", html = years_min_yr_out)
        shinyjs::html(id="selected-fo-year-max-yr", html = years_max_yr_out)
        
        
        #'////////////////////////////////////////
        # create a summary of violations the selected object
        selectionDF_sum <- reactive({
            
            # summarize
            tmp <- selectionDF() %>%
                group_by(Field.Office, Allegation) %>%
                summarize(count = n()) %>%
                ungroup()
            
            # add rate
            tmp$rate <- sapply(tmp$count, function(x){round(x/sum(tmp$count),5)*100})
            
            # return
            tmp   
        })
        
        #'////////////////////////////////////////
        # create a summary of dispositions based on the selected object
        dispositionsDF <- reactive({
            
            # summarize
            tmp2 <- selectionDF() %>%
                group_by(Field.Office, Final.Disposition) %>%
                summarize(count = n()) %>%
                ungroup()
            
            # add rate
            tmp2$rate <- sapply(tmp2$count, function(x){round(x/sum(tmp2$count),5)*100})
            
            # return
            tmp2
            
        })
        
        #'////////////////////////////////////////
        # Ranking of Selected FO 
        output$rankingPlot <- renderPlot({
            
            tsaSUM %>%
                arrange(tot.cases) %>%
                mutate(codes = factor(codes,codes),
                       color = ifelse(codes == info$codes,"target","default")) %>%
                ggplot(aes(x=codes, y=tot.cases, fill=color)) + 
                geom_bar(stat="identity") +
                scale_fill_manual(values = c("target"= "#700548","default"="#857a74")) +
                scale_y_continuous(breaks = seq(0,max(tsaSUM$tot.cases),by = 50),expand = c(0.01,0)) +
                
                # theme + labs
                xlab(NULL) + ylab("Count") +
                theme(
                    legend.position = "none",
                    panel.background = element_blank(),
                    axis.line.x = element_line(color="#525252",size=.5),
                    axis.line.y = element_line(color="#525252",size=.5),
                    panel.grid.major = element_line(color="#bdbdbd",size=0.15),
                    panel.grid.minor = element_blank(),
                    axis.ticks = element_line(color="#bdbdbd",size=0.15),
                    axis.title = element_text(color="#525252",
                                              size=14,
                                              margin = margin(r=10,unit="pt")),
                    axis.text = element_text(size=11, color="#525252")
                )
        })
        
        
        #'////////////////////////////////////////
        # Top 10 Allegations Chart
        output$allegationsHC <- renderHighchart({
            
            # grab top 10
            topAllegations <- selectionDF_sum() %>% 
                top_n(10) %>%
                arrange(-count)
            
            # plot
            highchart() %>%
                hc_xAxis(categories=topAllegations$Allegation) %>%
                hc_yAxis(tickInterval = 5) %>%
                hc_add_series(topAllegations, hcaes(x=Allegation, y=count),
                              type="bar", name="Allegations",
                              color="#700548") %>%
                hc_tooltip(crosshairs = TRUE,
                           shared = FALSE,
                           headerFormat = "{point.x}<br>",
                           pointFormat="Count: {point.y}",
                           shadow=T,
                           backgroundColor="white",
                           padding=12,
                           borderWidth=1.5,
                           borderRadius=10)
            
        })
        
        #'////////////////////////////////////////
        # Top 10 Resolutions Chart
        output$resolutionsHC <- renderHighchart({
            
            # grab top 10
            topResolutions <- dispositionsDF() %>%
                arrange(-count) %>%
                top_n(10)
            
            # plot
            highchart() %>%
                hc_xAxis(categories=topResolutions$Final.Disposition) %>%
                hc_yAxis(tickInterval = 5) %>%
                hc_add_series(topResolutions, hcaes(x=Final.Disposition, y=count),
                              type="bar", name="Resolution",
                              color="#449DD1") %>%
                hc_tooltip(crosshairs = TRUE,
                           shared = FALSE,
                           headerFormat = "{point.x}<br>",
                           pointFormat="Count: {point.y}",
                           shadow=T,
                           backgroundColor="white",
                           padding=12,
                           borderWidth=1.5,
                           borderRadius=10)
            
        })
        
        #'////////////////////////////////////////
        # Allegations over time compared with all Field Offices
        output$allegationsTimeHC <- renderHighchart({
            
            # summary by POSIXct year
            select_year_sum <- selectionDF() %>%
                group_by("date" = paste0(Year.Cased.Opened,"-01","-01")) %>%
                summarize(count = n())
            
            # filter tsaYRS df for years that match selected data
            # not all field offices have records for all years
            tsaSubset <- tsaYRS %>%
                filter(date >= min(select_year_sum$date), date <= max(select_year_sum$date))
            
            highchart() %>%
                hc_chart(zoomType = "xy") %>%
                hc_xAxis(type="dateTime",
                         categories = format(as.POSIXct(select_year_sum$date),
                                             "%Y")) %>%
                hc_yAxis(title=list(text="Count")) %>%
                
                # group avg
                hc_add_series(type="spline", 
                              data =round(tsaSubset$avg,2),
                              marker=list(symbol="circle",
                                          lineWidth="1px",
                                          fillColor="rgba(131,122,117,0.3)",
                                          lineColor="#837A75"),
                              backgroundColor="white",
                              color="#837A75",
                              name="All FOs Combined") %>%
                
                # selection
                hc_add_series(type="spline", 
                              data =select_year_sum$count,
                              marker=list(symbol="circle",
                                          lineWidth="1px",
                                          fillColor="rgba(112,5,72,0.3)",
                                          lineColor="#700548"),
                              backgroundColor="white",
                              color="#700548",
                              name="Field Office") %>%
                
                # tooltips
                hc_tooltip(crosshairs = TRUE,
                           shared = FALSE,
                           headerFormat = "Year: {point.x}<br>",
                           pointFormat="Count: {point.y}",
                           shadow=T,
                           backgroundColor="white",
                           padding=12,
                           borderWidth=1.5,
                           borderRadius=10)
            
        }) # end highcart timeseries
        
        #'////////////////////////////////////////
        # Resolutions of Allegations For Selected Field Office
        output$fieldOfficeSankey <- renderSankeyNetwork({
            
            # grab selected data and summarize by allegation and disposition
            sumDF <- selectionDF() %>%
                group_by(Allegation,Final.Disposition) %>%
                count()
            
            # prepare nodes data
            nodes <- data.frame(name = unique(c(sumDF$Allegation,sumDF$Final.Disposition)))
            nodes$cat <- ifelse(is.na(match(nodes$name,sumDF$Allegation)), "target","source")
            
            
            # prepare sum df by adding source and target vars
            sumDF$source <- match(sumDF$Allegation,nodes$name) - 1
            sumDF$target <- match(sumDF$Final.Disposition, nodes$name) - 1
            
            
            # force as data.frame
            sumDF <- data.frame(sumDF, stringsAsFactors = F)
            
            
            # make sankey diagram
            sankey <- sankeyNetwork(
                Links = sumDF, Source = "source", Target = "target", 
                Value = "n", Nodes = nodes, nodeWidth = 0,
                NodeGroup = "cat",
                margin = list("right" = 175),
                sinksRight = F,
                fontSize = 10)
            
            # add render 
            sankeyOut <- onRender(sankey,
                                  '
                    function(el, x){
                              
                        // style labels and create an object
                        labels = d3.selectAll(".node text")
                            .style("cursor", "default")
                            .style("font-family","monospace")
                            .style("font-size","8pt")
                            
                            // set label position based on group
                            .attr("x", function(d){
                                if(d.group == "source"){
                                    return "-6 - x.options.nodeWidth";
                                } else {
                                    return "6 + x.options.nodeWidth";
                                }
                            })
                    
                            // set label anchor based on group
                            .attr("text-anchor", function(d){
                                if(d.group == "source"){
                                    return "end";
                                } else {
                                    return "start";
                                }
                            })
                              
                            // modify path colors
                            paths = d3.selectAll("path.link")
                              .style("stroke","rgb(112,5,72)")
                              .style("stroke-opacity","0.1")
                              
                              }')
            
            sankeyOut
            
        })  
    })
}
