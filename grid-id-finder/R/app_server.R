#' app_server
#'
#' @param input required shiny object
#' @param output required shiny object
#'
#' @noRd
app_server <- function(input, output, server) {

    data <- golem::get_golem_options("data")

    # init inputs and DT
    session <- shiny::getDefaultReactiveDomain()
    updateSelectInput(session, inputId = "country", selected = "")
    updateSelectInput(session, inputId = "city", selected = "")
    updateTextInput(session, inputId = "query", value = "")
    dtProxy <- DT::dataTableProxy("table", session = session)

    #'////////////////////////////////////////
    # render input based on country selection
    # print input
    output$input_city <- renderUI({

        # return cities based on selected input
        if(input$country == "") {
          cities <- c("")
        } else {
          cities <- sort(unique(data$city[data$country == input$country]))
        }

        # render
        selectInput(
            "city",
            label = NULL,
            choices = c("", cities),
            selected = "",
            width = "100%"
        )
    })

    #'////////////////////////////////////////
    # submit
    observeEvent(input$submit, {

        # log selections
        browsertools::console_log(
            message = list(country = input$country, city = input$city)
        )

        # define vars for query
        q <- tolower(input$query)
        if (input$country == "" || is.null(input$country)) {
            country <- NA
        } else {
            country <- input$country
        }

        # process city
        if (input$city == "" || is.null(input$city)) {
            city <- NA
        } else {
            city <- input$city
        }

        # run query
        result <- reactive({
            grid_query(data = data, country = country, city = city, query = q)
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
                columnDefs = list(
                    list(
                        width = "25%",
                        targets = list("3", "10")
                    )
                ),
                initComplete = DT::JS(
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
            rowNum <- reactiveValues(id = input$table_rows_selected)

            # find id + log value
            selectedId <- reactive({
                result()[as.numeric(rowNum$id), 1]
            })
            browsertools::console_log(list(id = selectedId()))

            # update <output> and <button> attributes
            browsertools::inner_html(
                elem = "#gridID",
                content = selectedId()
            )
            browsertools::set_element_attribute(
                elem = "#copy",
                attr = "data-clipboard-text",
                value = as.character(selectedId())
            )
        })
    })

    #'////////////////////////////////////////
    # on button copy, reset DT
    observeEvent(input$copy, {
        DT::selectRows(dtProxy, NULL)
        DT::selectCells(dtProxy, NULL)
    })

    #'////////////////////////////////////////
    # on button reset, clear inputs, table, output
    observeEvent(input$refresh, {
        browsertools::refresh_page()
    })
}
