#'//////////////////////////////////////////////////////////////////////////////
#' FILE: server.R
#' AUTHOR: David Ruvolo
#' CREATED: 2018-05-24
#' MODIFIED: 2019-11-10
#' PURPOSE: shiny server
#' PACKAGES: see global.R file
#' STATUS: working
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)
server <- function(input, output, session) {
  
    # init
	updateSelectInput(session, inputId = "country",selected="")
	updateSelectInput(session, inputId = "city",selected = "")
	updateTextInput(session, inputId = "query",value = "")
    dtProxy <- DT::dataTableProxy("table",session = session)
    source("utils/function_02_handlers.R", local = TRUE)
    
	#'////////////////////////////////////////
	# render input based on country selection
    # print input
    output$input_city <- renderUI({
        if(input$country == ""){
          cities <- c("")
        } else {
          cities <- sort(unique(gridDF$city[gridDF$country == input$country]))
        }
        selectInput("city", label = NULL, choices = c("", cities), selected = "", width = "100%")
    })

	#'////////////////////////////////////////
	# submit
	observeEvent(input$submit, {

		js$consoleLog(value=list(input$country, input$city), session = session)

		# define vars for query
    	q <- tolower(input$query)
		
		if(input$country == "" || is.null(input$country)){
			country <- NA
		} else {
			country <- input$country
		}

		# process city
		if(input$city == "" || is.null(input$city)){
			city <- NA
		} else {
			city <- input$city
		}
    
    	# run query
		result <- reactive({
			gridQuery(filter_country = country, filter_city=city, query = q)
		})

		#'////////////////////////////////////////
		# Build Results table
		output$table <- DT::renderDataTable(
			result() %>% select(-country_code, -country, -alias, -acronym), 
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
					"}"
				)
			)
		)

		#'////////////////////////////////////////
		# watch for row selected
		observeEvent(input$table_rows_selected, {

			# find selected row number
			rowNum <- reactiveValues(id=input$table_rows_selected)

			# find id
			selectedId <- reactive({
				result()[as.numeric(rowNum$id),1]
			})
			js$consoleLog(selectedId(), session = session)

			# update <output> and <button> attributes
			js$innerHTML(elem = "#gridID", string = selectedId(), session = session)
			js$setElementAttribute(elem ="#copy", attr="data-clipboard-text", value= as.character(selectedId()), session = session)

		}) # end rows selected

	}) # end submit

	#'////////////////////////////////////////
	# on button copy, reset DT
	observeEvent(input$copy,{
		DT::selectRows(dtProxy, NULL)
		DT::selectCells(dtProxy, NULL)
	})
  
	#'////////////////////////////////////////
	# on button reset, clear inputs, table, output
	observeEvent(input$refresh, {
		js$refreshPage(session = session)
	})
  
} # end server
