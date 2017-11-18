# pkgs
library(shiny)
library(shinyjs)
library(dplyr)
library(highcharter)
library(googlesheets)

# initalize OAuth and gather data from google sheets
gs_auth(token = "googlesheets_token.rds")

saveData <- function(data) {
    # Grab the Google Sheet
    sheet <- gs_title("runningData")
    # Add the data as a new row
    gs_add_row(sheet, input = data)
}

loadData <- function() {
    # Grab the Google Sheet
    sheet <- gs_title("runningData")
    # Read the data
    responses <<- gs_read_csv(sheet)
}

loadingCSSa <- "
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
loadingCSSb <- "
#loadingContents{
display: flex;
justify-contents: center;
align-items: center;
}"

# ui
ui <- tagList(
    shinyjs::useShinyjs(),
    shinyjs::inlineCSS(loadingCSSa),
    shinyjs::inlineCSS(loadingCSSb),
    # head
    tags$head(
        tags$meta(charset="UTF-8"),
        tags$meta(name="viewport", content="width=device-width, initial-scale=1"),
        tags$link(rel="stylesheet", type="text/css", href="css/app.css")
    ),
    # Loading message
    div(
        id = "loadingScreen",
        div(id="loadingContents",
            HTML('<i class="fa fa-cog fa-spin fa-5x fa-fw" style="color:#0B0500;"></i>'))
    ),
    # body
    shinyjs::hidden(
        tags$div(id="app",
            class="wrapper",
            tags$div(
                class="header",
                tags$div(
                    class="grid-box",
                    actionButton(inputId = "menuBtnOpen",label="+"),
                    actionButton(inputId = "menuBtnClose",label="-")
                ),
                tags$div(class="grid-box",h4("My Running Progress"))
            ),
            shinyjs::hidden(
                tags$div(
                    id="overlay-content-wrapper",
                    tags$div(
                        class="overlay-content",
                        h2("Monitor my progress"),
                        tags$div(id="plot-chooser-container",
                                 tags$div(class="p-box",tags$p("Days")),
                                 tags$label(class="switch",
                                            tags$input(type="checkbox",id="chartToggle",
                                                       tags$span(class="slider round")
                                            )
                                 ),
                                 tags$div(class="p-box",tags$p("Distance"))
                        ),
                        tags$div(
                            id="plot-container",
                            p(id="plot-context"),
                            highchartOutput("chart")
                        )
                    )
                )
            ),
            tags$div(
                class="container",
                tags$div(
                    class="content",
                    tags$div(
                        id="input-fields",
                        # input
                        h1("Did you run today?", id="question"),
                        tags$div(
                            class="btn-container",
                            actionButton(inputId = "btnNo",
                                         class="button",label = "No"),
                            actionButton(inputId = "btnYes",
                                         class="button",label = "Yes")
                        )
                    ),
                    # reply
                    tags$div(
                        id="inner-content",
                        tags$div(
                            id="container-yes",
                            h1("How far did you run today?"),
                            p("(In kms, please)"),
                            tags$div(
                                class="input-container",
                                numericInput(inputId = "dist", 
                                             label=NULL, 
                                             value=0,
                                             step=0.1,
                                             min=0, 
                                             max=50),
                                actionButton(inputId = "btnSubmit",
                                             label="Submit",
                                             class="button")
                            )
                        ),
                        tags$div(
                            id="container-complete",
                            tags$h3(id="reply-message"),
                            tags$div(
                                class="btn-container",
                                actionButton(inputId = "btnQuit",class="button",
                                             label = "See you later!")
                            )
                        )
                    )
                )
            )
        )
    )
)

# server
server <- shinyServer(function(input,output,session){
    
    # app defaults
    shinyjs::hide(id="overlay-content-wrapper")
    shinyjs::hide(id="inner-content")
    shinyjs::hide(id="menuBtnClose")
    
    # load data
    loadData()
    
    # logic if Sys.Date() == max date in responses, don't display choices
    if(exists("responses")){
        if(max(responses$date) == format(Sys.Date(),"%Y-%m-%d")){
            shinyjs::hide(id="input-fields")
            shinyjs::show(id="inner-content")
            shinyjs::hide(id="container-yes")
            shinyjs::html(id="reply-message",
                          html="Looks like you've already logged for the day. Enjoy the rest of the day.")
        }
    }
    
    observeEvent(input$btnNo,{
        # display message
        shinyjs::hide(id="input-fields")
        shinyjs::hide(id="container-yes")
        shinyjs::hide(id="btnQuit")
        shinyjs::show(id="container-complete")
        shinyjs::show(id="inner-content", anim = T, animType = "fade", time = 1)
        
        # make df
        inputDF <- data.frame(
            "date" = format(Sys.Date(),"%Y-%m-%d"),
            "status" = "no",
            "distance" = 0,
            stringsAsFactors = F
        )
        # save
        # Grab the Google Sheet
        shinyjs::html(id="reply-message",html = "Locating database (in robot voice).")
        sheet <- gs_title("runningData")
        # Add the data as a new row
        Sys.sleep(1)
        shinyjs::html(id="reply-message",html = "Status success (in robot voice).")
        gs_add_row(sheet, input = inputDF)
        Sys.sleep(2)
        shinyjs::show(id="btnQuit")
        shinyjs::html(id="reply-message",
                      html = "Excellent! Keep up the good work. Remember to stretch!")
    })
    
    observeEvent(input$btnYes,{
        # hide divs
        shinyjs::hide(id="input-fields")
        shinyjs::hide(id="container-complete")
        shinyjs::hide(id="btnQuit")
        shinyjs::show(id="inner-content", anim = T, animType = "fade", time = 1)
        shinyjs::show(id="container-yes", anim = T, animType = "fade", time = 1)
        
        # show second question div
        observeEvent(input$btnSubmit,{
            
            # show/hide
            shinyjs::hide(id="container-yes")
            shinyjs::show(id="container-complete", anim = T, animType = "fade", time = 1)
            
            # make df
            inputDF <- data.frame(
                "date" = format(Sys.Date(),"%Y-%m-%d"),
                "status" = "yes",
                "distance" = as.numeric(input$dist),
                stringsAsFactors = F
            )
            # save
            # Grab the Google Sheet
            shinyjs::html(id="reply-message",html = "Locating database (in robot voice).")
            sheet <- gs_title("runningData")
            # Add the data as a new row
            Sys.sleep(1)
            shinyjs::html(id="reply-message",html="Appending database (in robot voice).")
            gs_add_row(sheet, input = inputDF)
            shinyjs::html(id="reply-message",html = "Status success (in robot voice).")
            Sys.sleep(2)
            shinyjs::show(id="btnQuit")
            shinyjs::html(id="reply-message",
                          html = "Excellent! Keep up the good work. Remember to stretch!")
        })
    })
    
    observeEvent(input$menuBtnOpen,{
        
        # overlay defaults
        shinyjs::hide(id="menuBtnOpen")
        shinyjs::show(id="menuBtnClose")
        shinyjs::show(id="overlay-content-wrapper",anim=T,animType="slide",time=1)
        
        # summarise data for days plot: days run and off days
        daysRun <- responses %>% 
            group_by("yyyy_mm" = format(as.Date(date), "%Y-%m-01")) %>% 
            filter(status == "yes") %>%
            count()
        
        daysRunNo <- responses %>% 
            group_by("yyyy_mm" = format(as.Date(date), "%Y-%m-01")) %>% 
            filter(status == "no") %>% 
            count()
        
        # plot:days
        daysPlot <- highchart() %>%
            hc_chart(type = "line", zoomType = "xy") %>%
            hc_xAxis(categories = format(as.POSIXct(daysRun$yyyy_mm), "%b %Y")) %>%
            hc_yAxis(title=list(text="number of days")) %>%
            hc_add_series(daysRun$n, name="Running Days", color="#2D7DD2") %>%
            hc_add_series(daysRunNo$n, name="Rest days", color="#F45D01") %>%
            hc_tooltip(crosshairs = TRUE,headerFormat = "", shared = FALSE)
        
        # plot: distance
        runDF <- responses %>% filter(status == "yes")
        
        distPlot <- highchart() %>%
            hc_chart(zoomType = "xy") %>%
            hc_xAxis(type="dateTime",
                     categories = format(as.POSIXct(runDF$date), "%b %d")) %>%
            hc_yAxis(title=list(text="kms")) %>%
            hc_add_series(type="scatter", 
                          data =runDF$distance,
                          marker=list(symbol="circle",
                                      lineWidth="1px",
                                      fillColor="rgba(45,125,210,0.3)",
                                      lineColor="#2D7DD2"),
                          backgroundColor="white",
                          color="#2D7DD2",
                          name="Distance") %>%
            hc_add_series(type="line",round(lowess(runDF$distance)$y,2),
                          marker=F,
                          shadow=T,
                          lineWidth="1px",
                          color="#636363",
                          name="Trend") %>%
            hc_tooltip(crosshairs = TRUE,
                       shared = FALSE,
                       headerFormat = "{point.x}<br>",
                       pointFormat="{point.y} kms",
                       shadow=T,
                       backgroundColor="white",
                       padding=12,
                       borderWidth=1.5,
                       borderRadius=10)
        
        # watch toggle: default is days; bx will modify txt and plot output
        observe({
            # default = days
            if(input$chartToggle == F){
                shinyjs::html(id="plot-context",
                              "Here's a monthly summary of how many days you've ran vs how many off days")
                output$chart <- renderHighchart({daysPlot})
            }
            # 'on' = distance
            if(input$chartToggle == T){
                shinyjs:: html(
                    id="plot-context",
                    "Here's a day-by-day look at how far you've run")
                output$chart <- renderHighchart({distPlot}) 
            }
        })
    })
    
    # menu btn actions
    observeEvent(input$menuBtnClose,{
        shinyjs::hide(id="menuBtnClose")
        shinyjs::show(id="menuBtnOpen")
        shinyjs::hide(id="overlay-content-wrapper",
                      anim = TRUE,
                      animType ="slide",
                      time = 0.8)
    })
    
    # on btn quit
    observeEvent(input$btnQuit,{stopApp()})
    
    #' show app
    hide(id = "loadingScreen", anim = TRUE, animType = "fade",time = 1) 
    Sys.sleep(1)
    show(id = "app", anim = T, animType = "fade",time=1)
    
})

# deploy
shinyApp(ui,server)