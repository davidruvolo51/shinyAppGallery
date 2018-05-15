#'//////////////////////////////////////////////////////////////////////////////
#' FILE: ui.R
#' AUTHOR: David Ruvolo
#' CREATED: 15 March 2016
#' MODIFIED: 07 April 2018
#' PURPOSE: shiny UI 
#' PACKAGES: see global.R
#' STATUS: in.progress
#' COMMENTS: major updates in 2018
#'//////////////////////////////////////////////////////////////////////////////

# ui
ui <- tagList(
    # optional
    shinyjs::useShinyjs(),
    # head
    tags$head(
        # set meta
        tags$meta("charset" ="utf-8"),
        tags$meta("http-equiv" ="X-UA-Compatible", "content" ="IE=edge"),
        tags$meta("name" ="viewport", "content"="width=device-width, initial-scale=1"),
        tags$meta("name" ="description", "content"=""),
        tags$meta("name" ="keywords", "content" =""),
        tags$meta("name" ="author", "content" =""),
        # load external
        tags$link("href"="css/app.css", "rel"="stylesheet")
        # tags$link("href"="css/app.min.css", "rel"="stylesheet")
    ), # END HEAD
    # body
    tags$body(
        # set ui container
        tags$div(class="container",
                 
                 #'////////////////////////////////////////
                 # TITLE
                 tags$div(class="block",
                          tags$div(class="content-wrapper title",
                                   tags$h1("TSA Allegations of Misconduct Data Visualization"),
                                   tags$h2("Allegations of Federal Air Marshall Misconduct Data from 2002 - 2012"),
                                   tags$div(class="button-container",
                                            tags$a("href"="\\#introduction","Start",
                                                   class="btn-style start"))
                          )
                 ),
                 #'////////////////////////////////////////
                 # INTRODUCTION
                 tags$div(class="block",id="introduction",
                          tags$div(class="content-wrapper intro",
                                   tags$h3("Introduction"),
                                   tags$p("In a ProPublica article published earlier in 2016,",
                                          tags$a(href="https://www.propublica.org/article/tsa-releases-data-on-air-marshal-misconduct-7-years-after-we-asked",
                                                 "The TSA Releases Data on Airmarshal Misconduct,
                                        7 Years After We Asked"),"Michael Grabell 
                                        includes a dataset on the number of cases 
                                        of US federal air marshal misconduct. The 
                                        dataset was obtained by a Freedom of Information
                                        Request and made available in ProPublica's 
                                        data store contained records of federal air 
                                        marshal misconduct from 2002 to 2012."),
                                   tags$p("Among all violations, some of the more interesting
                                 allegations include Criminal Arrest (148 cases), 
                                 Criminal Conduct (58 cases), Discharge of Firearm
                                 (Intentional + Unintentional; 35 cases), Death 
                                 (4 cases), Loss of Equipment (1226 cases), and 
                                 Missed Mission (953 cases).  The most common 
                                 resolution was Letter of Counsel (1833 cases) to
                                 the air marshal, whereas a suspension ranging 
                                 from 1 to 60 days was second (933 cases)."),
                                   tags$div(class="button-container",
                                            tags$a("href"="\\#instructions",
                                                   "\u2b07",
                                                   class="btn-style-next"))
                          )
                 ), # end introduction / instructions
                 
                 #'////////////////////////////////////////
                 # INSTRUCTIONS
                 tags$div(class="block",id="instructions",
                          tags$div(class="content-wrapper instruct",
                                   tags$h3("How to use this tool"),
                                   tags$p("In the next section, use the map to
                                          view more information about a field office.
                                          Click the 'View Report' button for a closer 
                                          look at the allegations at the selected
                                          field office."),
                                   tags$div(class="button-container",
                                            tags$a("href"="\\#map",
                                                   "\u2b07",
                                                   class="btn-style-next"))
                          )
                 ), # end block
                 
                 #'////////////////////////////////////////
                 # LEAFLET MAP
                 tags$div(class="block map-block",id="map",
                          tags$div(class="content-wrapper",id="map-wrapper",
                                   tags$p("Click on point on the map, and then click 
                                          'View Report' for more information", class="map-instructions"),
                                   leafletOutput("airportMap",width = "100%"),
                                   tags$div(class="button-container",
                                            actionButton(inputId = "moreInfo",
                                                         label="View Report",
                                                         class="btn btn-style infoBtn"))
                          )
                 ) ,# end map
                 
                 
                 #'////////////////////////////////////////
                 # REPORT
                 tags$div(class="block", id="report",
                          tags$div(class="content-wrapper report-wrapper",  
                                   
                                   #'////////////////////////////////////////
                                   # Title   
                                   tags$div(class="text-block title-block",
                                            tags$div(class="title-block-content",
                                                     tags$h1("Summary of",
                                                             tags$span(id="selected-fo-title"),
                                                             "Field Office"),
                                                     tags$h4("Location: ", 
                                                             tags$span(id="selected-fo-location")),
                                                     tags$h4("Code:",tags$span(id="selected-fo-code-1")),
                                                     tags$h4("Lat:",tags$span(id="selected-fo-lat")),
                                                     tags$h4("Lng:",tags$span(id="selected-fo-lng")),
                                                     tags$p(class="selected-fo-table-caption",
                                                            tags$span("Table 1."),
                                                            tags$span(id="selected-fo-code-2"),
                                                            tags$span("Field Office at a Glance")),
                                                     tags$table(class="selected-fo-table",
                                                                tags$tr(
                                                                    tags$td("Total allegations" ),
                                                                    tags$td(tags$span(id="selected-fo-count"))),
                                                                
                                                                tags$tr(
                                                                    tags$td("Year range" ),
                                                                    tags$td(tags$span(id="selected-fo-year-range"))),
                                                                
                                                                tags$tr(
                                                                    tags$td("Average allegations per year"),
                                                                    tags$td(
                                                                        tags$span(id="selected-fo-year-avg"))),
                                                                
                                                                tags$tr(
                                                                    tags$td("Year(s) with the fewest allegations"),
                                                                    tags$td(
                                                                        tags$span(id="selected-fo-year-min-yr"),
                                                                        " (",
                                                                        tags$span(id="selected-fo-year-min"),
                                                                        ")")),
                                                                
                                                                tags$tr(
                                                                    tags$td("Year(s) with the most allegations"),
                                                                    tags$td(
                                                                        tags$span(id="selected-fo-year-max-yr"),
                                                                        " (",
                                                                        tags$span(id="selected-fo-year-max"),
                                                                        ")"))
                                                     ),
                                                     tags$div(class="button-container",
                                                              tags$a("href"="\\#report-ranking",
                                                                     "\u2b07",
                                                                     class="btn-style-next"))
                                            )
                                   ),
                                   
                                   #'////////////////////////////////////////
                                   # Where does the FO lie within the pack?
                                   tags$div(class="text-block ranking-block",id="report-ranking",
                                            tags$div(class="content-wrapper",
                                                     tags$h2("How does the", 
                                                             tags$span(id="selected-fo-code-3"),
                                                             "field office rank among other offices in terms of allegations?"),
                                                     plotOutput("rankingPlot"),
                                                     tags$div(class="button-container",
                                                              tags$a("href"="\\#report-common-cases",
                                                                     "\u2b07",
                                                                     class="btn-style-next"))
                                            )
                                   ),
                                   
                                   #'////////////////////////////////////////
                                   # Grid layout for top 10 allegations and resolutions
                                   tags$div(class="text-block topten-block",id="report-common-cases",
                                            tags$div(class="content-wrapper",
                                                     tags$div(class="output-grid",
                                                              # allegations
                                                              tags$div(class="output-grid-item item-left",
                                                                       tags$h2("What are the common allegations?"),
                                                                       highchartOutput("allegationsHC")
                                                              ),
                                                              # resolution
                                                              tags$div(class="output-grid-item item-right",
                                                                       tags$h2("What are the common resolutions?"),
                                                                       highchartOutput("resolutionsHC"))
                                                     ),
                                                     tags$div(class="button-container",
                                                              tags$a("href"="\\#report-time",
                                                                     "\u2b07",
                                                                     class="btn-style-next"))
                                            )
                                   ), # end side-by-side bar
                                   
                                   #'////////////////////////////////////////
                                   # allegations over time
                                   tags$div(class="text-block",id="report-time",
                                            tags$div(class="content-wrapper",
                                                     tags$h2("How do allegations change over time?"),
                                                     tags$div(class="server-outpts",
                                                              highchartOutput("allegationsTimeHC")),
                                                     tags$div(class="button-container",
                                                              tags$a("href"="\\#report-resolutions",
                                                                     "\u2b07",
                                                                     class="btn-style-next"))
                                            )
                                   ), # end time series
                                   
                                   #'////////////////////////////////////////
                                   # flow of allegations to resolutions
                                   tags$div(class="text-block",id="report-resolutions",
                                            tags$div(class="content-wrapper",
                                                     tags$h2("How where allegations resoved?"),
                                                     tags$div(class="server-outputs",
                                                              sankeyNetworkOutput("fieldOfficeSankey")),
                                                     tags$div(class="button-container",
                                                              tags$a("href"="\\#map",
                                                                     "Restart",
                                                                     class="btn-style restart"))
                                            ) # end sankey
                                   )
                          ) # END REPORT
                 ), # END CONTENT WRAPPER
                 # Add UI Footer
                 tags$div(class="footer",
                          tags$div(class="footer-content",
                                   tags$p("Designed + Developed"),
                                   tags$p("by"),
                                   tags$span("David Ruvolo"),
                                   
                                   tags$div(class="external-links",
                                            tags$ul(
                                                tags$li(tags$a(href="https://davidruvolo51.github.io/","website")),
                                                tags$li(tags$a(href="https://github.com/davidruvolo51","github")),
                                                tags$li(tags$a(href="https://www.twitter.com/@dcruvolo","twitter"))
                                            )
                                   )
                          )
                 )
        ), # END CONTAINER
        # js
        tags$script(src="js/app.js")
        # tags$script(src="js/app.min.js")
    ) # END BODY
) # END TAGS LIST
