#'//////////////////////////////////////////////////////////////////////////////
#' FILE: ui.R
#' AUTHOR: David Ruvolo
#' CREATED: 2018-05-24
#' MODIFIED: 2019-11-11
#' PURPOSE: shiny ui
#' PACKAGES: see global.R
#' STATUS: working
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)
ui <- tagList(
  
  	# <head>
  	tags$head(
    	tags$meta("charset" ="utf-8"),
    	tags$meta("http-equiv" ="X-UA-Compatible", "content" ="IE=edge"),
    	tags$meta("name" ="viewport", "content"="width=device-width, initial-scale=1"),
    
    	# link
    	# tags$link("href"="css/styles.css", "rel"="stylesheet")
    	tags$link("href"="css/styles.min.css", "rel"="stylesheet")
    
  	),
  
  	#'////////////////////////////////////////
	# <body>
	tags$body(

		# screen reader content
		tags$a(href="main", class="screen-reader-text", "Skip to main content"),

		# <header>
		tags$header(class="header",
			tags$h1(class="header-title", "Grid ID Finder"),
			tags$ul(class="menu", `aria-label`="page options",
				tags$li(class="menu-item",
					tags$button(id="refresh", type="button", class="action-button shiny-bound-input btn btn-secondary", "Refresh", accesskey="r")
				)
			)
		),

		# <main>
		tags$main(class="main", id="main", `aria-label`="main content",

			# <aside> - sidebar
			tags$aside(class="sidebar sidebar-search", `aria-label`="search",

				# <aside> panel for "search"
				tags$section(class="panel panel-search",
					tags$div(Class="inner-content",
						tags$h2("Search for Id"),

						# <form>
						tags$form(class="form",

							# <input> for country
							tags$label(class="label", `for`="country", "Filter by Country"),
							selectInput(
							    inputId="country", 
							    label = NULL, 
							    choices = choices,
								selected = "",
							    width = "100%"
							),

							# <input> for city
							tags$label(class="label", `for`="city", "Filter by City"),
							uiOutput("input_city"),

							# <input> for text
							tags$label(class="label", `for`="query", "Search by name or phrase"),
							tags$input(type="search", id="query", class="input", accesskey="q"),

							# submit button
							tags$button(id="submit", type="button", class="action-button shiny-bound-input btn btn-primary btn-copy", "Submit")
						)
					)
				),

				# <aside> panel for results
				tags$section(class="panel panel-results",
					tags$div(class="inner-content",
						tags$h2("Copy Result ID"),
						tags$p("Select an entry in the results table to send the output id below. Copy the result to your clipboard for later use."),
						tags$output(class="output", id="gridID", "select an id"),
						tags$button(type="button", id="copy", accesskey="c", class="action-button shiny-bound-input btn btn-primary", `data-clipboard-text`="", "Copy ID")
					)
				)
			),

			# <div> - table output
			tags$div(class="results", `aria-label`="search results",
				tags$div(class="inner-content",
					tags$h2("Results"),
					tags$style("table.dataTable.hover tbody tr:hover, table.dataTable.display tbody tr:hover{ background-color: #FBD1A2;color: black; cursor: pointer;}"),
					DT::dataTableOutput("table")
				)
			)
		),

		# <footer>
		tags$footer(class="footer",
			tags$h2("More Information"),
			tags$ul(class="menu",
				tags$li(class="menu-item",
					tags$a(class="menu-link", href="https://grid.ac/", "grid.ac")
				),
				tags$li(class="menu-item",
					tags$a(class="menu-link", href="https://github.com/davidruvolo51/shinyAppGallery", "github")
				)
			)
		),

		# load js
		tags$script(type="text/javascript", src="assets/clipboard.js-master/dist/clipboard.min.js"),
		# tags$script(type="text/javascript", src="js/index.js")
		tags$script(type="text/javascript", src="js/index.min.js")
	)
)