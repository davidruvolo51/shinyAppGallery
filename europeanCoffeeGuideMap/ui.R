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
                  br(),
                  # jumbotron
                  div(class="jumbotron",
                      h1("European Coffee Trip Planner"),
                      p("468 Cafes across Europe")
                  ),
                  # map
                  leafletOutput(outputId = "coffeeMap",height = "40em", width="85%"),
                  br(),
                  actionButton(inputId = "defaultMapView", "Zoom Default"),
                  # footer
                  br(),
                  div(class="bottom",
                      h4("Made by David Ruvolo"),
                      p("All information comes from ",
                        a("href"="https://europeancoffeetrip.com/", "European Coffee Trip"),
                        " and was built in Rstudio using shiny."
                      )
                  )
        )
    )
)