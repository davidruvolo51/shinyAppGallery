#'//////////////////////////////////////////////////////////////////////////////
#' FILE: ui.R
#' AUTHOR: David Ruvolo
#' CREATED: April 24, 2017
#' PURPOSE: UI for travel map
#' PACKAGES: shiny, shinyjs, leaflet, tidyverse
#' NOTES:
#'//////////////////////////////////////////////////////////////////////////////
#' LOADING SCREEN CSS
#' APP CSS
loadingCSS <- "
#loadingScreen{
        display: flex;
        justify-content: center;
        align-items: center;
        text-align: center;
        background: rgba(255,255,255, 0.7);
        z-index: 100;
        height: 100vh;
}
"

#' UI
shinyUI(tagList(
    shinyjs::useShinyjs(),
    shinyjs::inlineCSS(loadingCSS),
    #'/////////
    # Loading message
    div(
        id = "loadingScreen",
        div(id="loadingContents",
            HTML('<i class="fa fa-cog fa-spin fa-5x fa-fw"></i>'))
    ),
    #'
    # head
    hidden(
        div(id="travelApp",
            tags$head(
                tags$link("href"="css/app.css",type="text/css",rel="stylesheet")
            ),
            #'/////////
            #' main UI
            #' title
            div(class="jumbotron", id="top",
                div(class="inner-container",
                    tags$i(class="fa fa-globe title-icon"),
                    h1("My Traveling Adventures",hr()),
                    div(id="subtitle",
                        h2(id="totalConts", class="dataInput"),
                        h2(" // ", class="dataBreakers"),
                        h2(id="totalCountries" , class="dataInput"),
                        h2(" // ", class="dataBreakers"),
                        h2(id="totalPlaces", class="dataInput")),
                    div(class="mini-spacer"),
                    a("Explore", href="#myAdventures",class="btn btn-default btn-lg", id="jumboTronBtn")
                )
            ), # end jumbotron
            fluidPage(
                #' map output
                div(class="map-container",
                    div(class="micro-spacer"),
                    h1("My Travel Map"),
                    wellPanel(
                        a("Back to Top", href="#top", class="btn btn-primary"),
                        actionButton(inputId = "mapReset",label = "Reset Zoom",icon = icon("fa-binoculars"))
                    ),
                    div(class="mini-spacer"),
                    leafletOutput(outputId = "myAdventures"),
                    div(class="mini-spacer")
                )
            ) # end fluid page
        ) # end travel app div
    ) # end hidden
)) # end tags list + shiny UI