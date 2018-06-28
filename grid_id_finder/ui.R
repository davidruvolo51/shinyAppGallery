#'//////////////////////////////////////////////////////////////////////////////
#' FILE: ui.R
#' AUTHOR: David RUvolo
#' CREATED: 24 May 2018
#' MODIFIED: 22 June 2018
#' PURPOSE: front end
#' PACKAGES: see global.R
#' STATUS: in.progress
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)

# ui
ui <- tagList(
  
  shinyjs::useShinyjs(),
  
  #'////////////////////////////////////////
  # head
  tags$head(
    
    # set meta
    tags$meta("charset" ="utf-8"),
    tags$meta("http-equiv" ="X-UA-Compatible", "content" ="IE=edge"),
    tags$meta("name" ="viewport", "content"="width=device-width, initial-scale=1"),
    
    # link
    tags$link("href"="css/styles.css", "rel"="stylesheet")#,
    # tags$link("href"="css/readme.css", "rel"="stylesheet")
    
  ), # END HEAD
  
  #'////////////////////////////////////////
  # body
  tags$body(
    
    # quit modal
    shinyjs::hidden(
      tags$div(class="modal", id="quitMsg",
               tags$div(class="modal-content",
                        tags$p("Are you sure you want to quit?"),
                        actionButton(inputId = "no",
                                     label = "No",
                                     icon = icon("ban"),
                                     class="quit-btn no-btn"),
                        actionButton(inputId = "yes",
                                     label = "Yes",
                                     icon = icon("sign-out"),
                                     class="quit-btn yes-btn")
               )
      )
    ),
    
    #'////////////////////////////////////////
    # set ui container
    tags$div(class="container",
             
             # overlay - info
             shinyjs::hidden(
               tags$div(class="block-overlay", id="overlay",
                        tags$div(class="block-overlay-content",
                                 tags$div(id="help",
                                          uiOutput("infoDoc")
                                 )
                        )
               )
             ),
             
             #'////////////////////////////////////////
             # header
             tags$div(class="block-header-bar",
                      tags$div(class="block-header-bar-content",
                               
                               # title
                               tags$div(class="header-bar-box",
                                        tags$h1("GRID_ID Finder")
                               ),
                               
                               # button: info
                               actionButton(inputId="info", 
                                            label=NULL,
                                            icon = icon("info-circle"),
                                            "title" = "Show More Info (alt + i)",
                                            "accesskey" = "i",
                                            class="header-bar-box box-btn"),
                               
                               # button: refresh
                               actionButton(inputId = "refresh",
                                            label=NULL,
                                            icon=icon("refresh"),
                                            "title" = "Refresh App (alt + r)",
                                            "accesskey" = "r",
                                            class="header-bar-box box-btn"),
                               
                               # button: quit
                               actionButton(inputId="quit",
                                            label=NULL,
                                            icon =icon("power-off"),
                                            "title" = "Quit (alt + x)",
                                            "accesskey"="x",
                                            class="header-bar-box box-btn")
                      )
             ),
             
             #'////////////////////////////////////////
             # input block
             tags$div(class="block",
                      tags$div(class="block-grid",
                               
                               #'////////////////////////////////////////
                               # column: 1 
                               tags$div(class="block-item",
                                        # content
                                        tags$div(class="block-item-content",
                                                 tags$h3("Search"),
                                                 
                                                 #'////////////////////////////////////////
                                                 # filters: country
                                                 tags$p("Filter for a Country (Optional)"),
                                                 selectInput(inputId = "country",label=NULL,
                                                             choices = c("",choices),
                                                             selected = "",
                                                             multiple = FALSE,
                                                             width = "100%"),
                                                 
                                                 #'////////////////////////////////////////
                                                 # filter: city
                                                 tags$p("Filter for a City (Optional)"),
                                                 uiOutput("filterCityUI"),
                                                 
                                                 #'////////////////////////////////////////
                                                 # search: phrase
                                                 tags$p("Enter a name or phrase:"),
                                                 HTML("<input type='text' id='query' accesskey='q'>"),
                                                 tags$div(class="button-container",
                                                          actionButton(inputId="clear",
                                                                       label = "Clear",
                                                                       icon=icon("times-circle"),
                                                                       "title"="Clear filters",
                                                                       "accesskey" ="z",
                                                                       class="button reset"),
                                                          actionButton(inputId = "submit",
                                                                       label = "Submit",
                                                                       icon=icon("search"),
                                                                       "title" ="Submit Query",
                                                                       class="button submit")
                                                 )
                                        )
                               ),
                               
                               #'////////////////////////////////////////
                               #' column: 2
                               tags$div(class="block-item item-spanned",
                                        tags$div(class="block-item-content",
                                                 tags$h3("Results"),
                                                 tags$style("table.dataTable.hover tbody tr:hover, 
                                                            table.dataTable.display tbody tr:hover{
                                                            background-color: #FBD1A2;color: black;}"),
                                                 DT::dataTableOutput("table")
                                        )
                               ),
                               
                               #'////////////////////////////////////////
                               # column: 2
                               tags$div(class="block-item",
                                        # contente
                                        tags$div(class="block-item-content",
                                                 tags$h3("Selected ID"),
                                                 tags$div(class="code-output",
                                                          id="codeOutput",
                                                          textOutput("selection")
                                                 ),
                                                 actionButton(inputId = "copy",
                                                              label = "Copy",
                                                              icon=icon("clone"),
                                                              "title"="Copy id",
                                                              class="button copy",
                                                              "accesskey"="c",
                                                              "data-clipboard-text" = "")
                                        )
                               )
                      )
             )
    ), # END CONTAINER
    #'////////////////////////////////////////
    # clipboardjs
    tags$script("src"="assets/clipboard.js-master/dist/clipboard.min.js"),
    tags$script(type="text/javascript","new ClipboardJS('.button');")
    
  ) # END BODY
) # END
