#'////////////////////////////////////////////////
#' FILE: ui.R
#' AUTHOR: David Ruvolo
#' CREATED: April 18, 2017
#' PURPOSE: user interface
#' NOTES: needs app.css file
#'////////////////////////////////////////////////
shinyUI(
    tagList(
        # call header
        tags$link("href"="css/app.css", "rel"="stylesheet"),
        # ui
        fluidPage(title = "Coffee Guide",
                  # jumbotron
                  div(class="jumbotron",
                      div(
                      h1("European Coffee Trip Planner"),
                      p("468 Cafes across Europe"))
                  ),
                  # map
                  leafletOutput(outputId = "coffeeMap",height = "60em", width="85%"),
                  div(class="bottom",
                      actionButton(inputId = "defaultMapView", "Zoom Default"),
                      h4("Made by David Ruvolo"),
                      p("All information comes from ",
                        a("href"="https://europeancoffeetrip.com/", "European Coffee Trip"),
                        " and was built in Rstudio using shiny."
                      )
                  )
        )
    )
)