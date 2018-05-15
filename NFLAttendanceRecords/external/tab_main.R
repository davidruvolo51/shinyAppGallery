# .R file for Main TabPanel
output$Main <- renderUI({
    tabPanel("",
        # HEAD------------------------------------------------------------------
        # include external
        tags$head(includeScript('google-analytics.js')), # include GA tracker
        tags$link(rel='stylesheet', type='text/css', href='style.css'), # css file
        tags$link(rel="stylesheet", type="text/css", 
                  href="https://fonts.googleapis.com/css?family=Work+Sans:100,200,300,400,500"),
        shinyjs::useShinyjs(),
        
        # TITLE-----------------------------------------------------------------
        fluidRow(
            # blank column
            column(1),
            # main column
            column(10, uiOutput("mapTitle")),
            # blank column
            column(1)
        ),
        
        # LEAFLET MAP-----------------------------------------------------------
        fluidRow(
            # BLANK COLUMN--------------
            column(1),
            # MAP--------------
            column(9, HTML("<div id='map-container'>"),
                        leafletOutput("map", height = "570px"),
                    HTML("</div>")),
            
            # BEGIN RIDICULOUS LEGEND--------------
            column(1, 
                   # border-top
                   # label: plotting variable
                   fluidRow(HTML("<div class='legend-header'>Variable:</div>")),
                   br(),
                   # input: variable selector
                   fluidRow(selectInput(inputId = "plotvar",
                                        label= NULL,
                                        width = "90px",
                                        choices=c("All","Home","Away"))
                   ),
                   # label: year
                   fluidRow(HTML("<div class='legend-header'>Year:</div>")),
                   br(),
                   # input: year
                   fluidRow(numericInput(inputId = "years", 
                                        label = NULL,
                                        width = "90px",
                                        min = 2009,
                                        max = 2015,
                                        value = 2009,
                                        step = 1
                                        )),
                   # label: legend
                   fluidRow(HTML("<div class='legend-header'>Legend:</div>")),
                   # output: legend
                   fluidRow(uiOutput("legend")),
                   # label: build report
                   fluidRow(HTML("<div class='legend-header'>More?</div>")),
                   # button: go!
                   HTML("<div style='height:10px;'/>"), # just a little bit of space :-)
                   actionButton(inputId = 'submit', label = "Go!", width="65px")
                   
            ), # END
            
            # BLANK COLUMN--------------
            column(1)
        ),
        
        br(), # a little breaky
        
        # add border
        fluidRow(
            # blank col
            column(1),
            # main col
            column(10,HTML("<hr style='border-bottom: 1.5px solid #bdbdbd;'")),
            # blank col
            column(1)
        ),
        
        br(), # a little breaky
        br(), # a little breaky
        
        # PROFILE---------------------------------------------------------------
        
        # make title
        fluidRow(
            # title
            column(12, uiOutput("selectionTitle"))
        ),
        
        br(), # a little breaky
        
        # output plotly
        fluidRow(
            # blank col
            column(1),
            # TOTAL ATTENDANCE OVER ALL YEARS
            column(3, plotlyOutput("NFL_team_TOT", width = "350px")),
            # HOME GAME ATTENDANCE OVER ALL YEARS
            column(3, plotlyOutput("NFL_team_HOME", width = "350px")),
            # ROAD GAME ATTENDANCE OVER ALL YEARS
            column(3, plotlyOutput("NFL_team_ROAD", width = "350px")),
            # blank col
            column(1,
                   #br(),br(),
                   # output: legend - custom plotly legend (plty pos sucks!)
                   fluidRow(uiOutput("chartLegend"))
            )
        ),
        
        br(), # a little breaky
        br(), # a little breaky
        
        # border-------------
        fluidRow(
            # blank col
            column(1),
            # line
            column(10, uiOutput("sectionBorder")),
            # blank col
            column(1)
        )
    )
})