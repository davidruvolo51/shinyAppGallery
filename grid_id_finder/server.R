#'//////////////////////////////////////////////////////////////////////////////
#' FILE: server.R
#' AUTHOR: David Ruvolo
#' CREATED: 24 May 2018
#' MODIFIED: 22 June 2018
#' PURPOSE: "back end"
#' PACKAGES: see global.R file
#' STATUS: in.progress
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)

# server
server <- function(input, output, session) {
  
  # defaults
  output$selection <- renderText({ return("Search and select an institution") })
  dtProxy <- DT::dataTableProxy("table",session = session)
  
  
  #'////////////////////////////////////////
  # REACTIVE UI FOR CITY
  output$filterCityUI <- renderUI({
    
    cities <- reactive({
      if(input$country == ""){
        c("")
      } else {
        c("",sort(unique(gridDF$city[gridDF$country == input$country])))
      }
    })
    
    selectInput(inputId = "city",label=NULL, choices = cities(), width = "100%")
    
  })
  
  #'////////////////////////////////////////
  # on submit
  observeEvent(input$submit,{
    
    # get query and lower
    q <- tolower(input$query)
    
    # build country filter
    if(input$country == ""){
      country <- NULL
    } else{
      country <- input$country
    }
    
    # build city filter
    if(input$city == ""){
      city <- NULL
    } else {
      city <- input$city
    }
    
    # run q through function
    result <- reactive({
      gridQuery(filter_country = country, filter_city=city, query = q)
    })
    
    #'////////////////////////////////////////
    # Build Results table
    output$table <- DT::renderDataTable(
      result() %>% select(-country_code), 
      selection = "single", 
      server = TRUE,
      class = "row-border hover",
      options = list(
        autoWidth = TRUE,
        columnDefs = list(list(width = '25%',targets = list("3","10"))),
        initComplete = JS(
          "function(settings, json) {",
          "$(this.api().table().header()).css({'font-family': 'Helvetica','font-weight':'bold'});",
          "$(this.api().table().body()).css({'font-family': 'Helvetica', 'font-size':'11pt'});",
          "var tbl = document.querySelector('#table input');",
          "tbl.setAttribute('accesskey','t');",
          "}")
      )
    )
    
    #'////////////////////////////////////////
    
    # send output selection
    observeEvent(input$table_rows_selected,{
      
      shinyjs::toggleClass(id="selection",class = "addFlash")
      
      rowNum <- reactiveValues(id=input$table_rows_selected)
      
      #'////////////////////////////////////////
      # Find result
      out <- reactive({
        
        dat <- result()
        tmp <- dat[as.numeric(rowNum$id),]
        data.frame(tmp,stringsAsFactors = FALSE)
        
      })
      #'////////////////////////////////////////
      # send selected ID to UI
      output$selection <- renderText({
        tmp <- out()
        return(tmp$grid_id)
      })
      
      # modify element attributes for copy/paste
      js <- paste0(
        "var el = document.getElementById('copy');",
        "el.setAttribute('data-clipboard-text', '",
        as.character(out()[,1]),"');"
      )
      
      shinyjs::runjs(js)
      
    }) # end observe
  }) # end observe event
  
  #'////////////////////////////////////////
  #' Observe event for copy: reset DT
  observeEvent(input$copy,{
    DT::selectRows(dtProxy, NULL)
    DT::selectCells(dtProxy, NULL)
  })
  
  #'////////////////////////////////////////
  # Observe event for reset button click
  observeEvent(input$clear,{
    
    # reset UI
    updateSelectInput(session, inputId = "country",selected="")
    updateSelectInput(session, inputId = "city",selected = "")
    updateTextInput(session, inputId = "query",value = "")
    # output$table <- NULL
    output$selection <- renderText({ return("Search and select an institution") })
    
  })
  
  #'////////////////////////////////////////
  # Observe event info for info button click
  observeEvent(input$info,{ 
    
    shinyjs::toggle(id="overlay",anim = T,animType = "fade",time = .5) 
    
    output$infoDoc <- renderUI({
      
      # render document markdown
      includeMarkdown(
        rmarkdown::render(
          input="www/docs/README.Rmd",
          output_format = "html_document",
          quiet = T
        )
      )
    })
  })
  
  #'////////////////////////////////////////
  # ObserveEvent for refresh button click
  observeEvent(input$refresh, { 
    
    shinyjs::runjs("history.go(0);") 
    
  })
  
  #'////////////////////////////////////////
  # Observe event for quit button click
  observeEvent(input$quit,{
    
    # show msg
    shinyjs::toggle(id="quitMsg",anim = T,animType = "fade",time = .3)
    
    # if yes
    observeEvent(input$yes,{
      # quit and close
      shinyjs::runjs("window.close();")
      shiny::stopApp()
    })
    
    # if no
    observeEvent(input$no, { 
      shinyjs::toggle(id="quitMsg",anim = T,animType = "fade",time = .3)
    },ignoreInit = T)
  })
  
} # end server
