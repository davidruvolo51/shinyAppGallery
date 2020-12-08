#'//////////////////////////////////////////////////////////////////////////////
#' FILE: server.R
#' AUTHOR: David Ruvolo
#' CREATED: 2018-04-07
#' MODIFIED: 2020-12-06
#' PURPOSE: server side
#' PACKAGES: see `app.R`
#' STATUS: in progress
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////

app_server <- function(input, output, session) {
    tsa <- golem::get_golem_options("data")
    tsa_sum_df <- golem::get_golem_options("summary_df")

    # init vals
    map_click <- reactiveVal()
    map_click(mod_leaflet_server(data = tsa)$id)

    selection_df <- reactive({
        if (is.null(map_click())) {
            subset(tsa, Field.Office == "DEN") # return default opt
        } else {
            tsa[tsa$Field.Office == map_click$id, ]
        }
    })

    #'/////////////////////////////////////////////////////////////////////////
    #' ObserveEvent for Button Click
    observeEvent(input$moreInfo, {

        # get summary data
        info <- tsa_sum_df[
            tsa_sum_df$codes == unique(selection_df()$Field.Office),
        ]
        report_office_title_server(id = "", title = info$names)
        report_office_summary(
            id = "fo-title",
            city = info$city,
            state = info$state,
            code = info$codes,
            lat = info$lat,
            lng = info$lng
        )
        report_office_table_server(id = "fo-table", data = info)

        #'////////////////////////////////////////
        # create a summary of violations the selected object
        selection_df_sum <- reactive({
            selection_df() %>%
                group_by(Field.Office, Allegation) %>%
                summarize(count = n()) %>%
                ungroup() %>%
                mutate(
                    rate = sapply(count, function(x) {
                        round(x / sum(count), 5) * 100
                    })
                )

        })

        #'////////////////////////////////////////
        # create a summary of dispositions based on the selected object
        dispositions_df <- reactive({
            selection_df() %>%
                group_by(Field.Office, Final.Disposition) %>%
                summarize(count = n()) %>%
                ungroup() %>%
                mutate(
                    rate = sapply(count, function(x) {
                        round(x / sum(count), 5) * 100
                    })
                )
        })

        #'////////////////////////////////////////
        # Ranking of Selected FO
        output$rankingPlot <- renderPlot({
            tsaSUM %>%
                arrange(tot.cases) %>%
                mutate(
                    codes = factor(codes, codes),
                    color = ifelse(codes == info$codes, "target", "default")
                ) %>%
                ggplot(aes(x = codes, y = tot.cases, fill = color)) +
                geom_bar(stat = "identity") +
                scale_fill_manual(
                    values = c(
                        target = "#700548",
                        default = "#857a74"
                    )
                ) +
                scale_y_continuous(
                    breaks = seq(0, max(tsaSUM$tot.cases), by = 50),
                    expand = c(0.01, 0)
                ) +
                xlab(NULL) + ylab("Count") +
                theme(
                    legend.position = "none",
                    panel.background = element_blank(),
                    axis.line.x = element_line(
                        color = "#525252",
                        size = .5
                    ),
                    axis.line.y = element_line(
                        color = "#525252",
                        size = .5
                    ),
                    panel.grid.major = element_line(
                        color = "#bdbdbd",
                        size = 0.15
                    ),
                    panel.grid.minor = element_blank(),
                    axis.ticks = element_line(
                        color = "#bdbdbd",
                        size = 0.15
                    ),
                    axis.title = element_text(
                        color = "#525252",
                        size = 14,
                        margin = margin(r = 10, unit = "pt")
                    ),
                    axis.text = element_text(
                        size = 11,
                        color = "#525252"
                    )
                )
        })

        #'////////////////////////////////////////
        # Top 10 Allegations Chart
        selection_top_allegations <- reactive({
            selection_df_sum() %>%
                top_n(10) %>%
                arrange(-count)
        })

        hc_column_server(
            id = "allegations-column",
            data = selection_top_allegations,
            x = Allegation,
            y = count,
            name = "Allegations",
            color = "#700548"
        )

        #'////////////////////////////////////////
        # Top 10 Resolutions Chart
        selection_top_resolutions <- reactive({
            selection_df_sum() %>%
                arrange(-count) %>%
                top_n(10)
        })
        hc_column_server(
            id = "resolutions-column-chart",
            data = selection_top_resolutions,
            x = Final.Disposition,
            y = count,
            name = "Resolutions",
            color = "#449DD1"
        )

        #'////////////////////////////////////////
        # Allegations over time compared with all Field Offices
        output$allegationsTimeHC <- renderHighchart({

            # summary by POSIXct year
            select_year_sum <- selection_df() %>%
                group_by(date = paste0(Year.Cased.Opened, "-01", "-01")) %>%
                summarize(count = n())

            # filter tsaYRS df for years that match selected data
            # not all field offices have records for all years
            tsaSubset <- tsaYRS %>%
                filter(
                    date >= min(select_year_sum$date),
                    date <= max(select_year_sum$date)
                )

            highchart() %>%
                hc_chart(zoomType = "xy") %>%
                hc_xAxis(
                    type = "dateTime",
                    categories = format(as.POSIXct(select_year_sum$date), "%Y")
                ) %>%
                hc_yAxis(title = list(text = "Count")) %>%

                # group avg
                hc_add_series(
                    type = "spline",
                    data = round(tsaSubset$avg, 2),
                    marker=list(
                        symbol = "circle",
                        lineWidth = "1px",
                        fillColor = "rgba(131,122,117,0.3)",
                        lineColor = "#837A75"
                    ),
                    backgroundColor = "white",
                    color = "#837A75",
                    name = "All FOs Combined"
                ) %>%

                # selection
                hc_add_series(
                    type = "spline",
                    data = select_year_sum$count,
                    marker = list(
                        symbol = "circle",
                        lineWidth = "1px",
                        fillColor = "rgba(112,5,72,0.3)",
                        lineColor = "#700548"
                    ),
                    backgroundColor = "white",
                    color = "#700548",
                    name = "Field Office"
                ) %>%

                # tooltips
                hc_tooltip(
                    crosshairs = TRUE,
                    shared = FALSE,
                    headerFormat = "Year: {point.x}<br>",
                    pointFormat = "Count: {point.y}",
                    shadow = TRUE,
                    backgroundColor = "white",
                    padding = 12,
                    borderWidth = 1.5,
                    borderRadius = 10
                )

        }) # end highcart timeseries

        #'////////////////////////////////////////
        # Resolutions of Allegations For Selected Field Office
        output$fieldOfficeSankey <- renderSankeyNetwork({

            # grab selected data and summarize by allegation and disposition
            sumDF <- selection_df() %>%
                group_by(Allegation, Final.Disposition) %>%
                count()

            # prepare nodes data
            nodes <- data.frame(
                name = unique(c(sumDF$Allegation, sumDF$Final.Disposition))
            )
            nodes$cat <- ifelse(
                is.na(match(nodes$name,sumDF$Allegation)),
                "target",
                "source"
            )

            # prepare sum df by adding source and target vars
            sumDF$source <- match(sumDF$Allegation, nodes$name) - 1
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
                fontSize = 10
            )

            # add render
            sankeyOut <- onRender(
                sankey,
                'function(el, x) {
                    // style labels and create an object
                    labels = d3.selectAll(".node text")
                        .style("cursor", "default")
                        .style("font-family","monospace")
                        .style("font-size","8pt")
                        .attr("x", function(d) {
                            // set label position based on group
                            if(d.group == "source") {
                                return "-6 - x.options.nodeWidth";
                            } else {
                                return "6 + x.options.nodeWidth";
                            }
                        })
                        .attr("text-anchor", function(d) {
                            // set label anchor based on group
                            if(d.group == "source") {
                                return "end";
                            } else {
                                return "start";
                            }
                        })

                    // modify path colors
                    paths = d3.selectAll("path.link")
                        .style("stroke","rgb(112,5,72)")
                        .style("stroke-opacity","0.1")
                }'
            )
            sankeyOut
        })
    })
}
