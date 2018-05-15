# ================
# Shiny: server.R     
# ================

shinyServer(function(input,output, session){
    
    # load UI panels
    source("external/tab_main.R", local = TRUE)
    source("external/tab_about.R", local = TRUE)
    # load server outputs
    source("external/football_map.R", local = TRUE)
    
    # create mainDF
    footballMapDF <- reactive({
        subset(football, year == input$years & Team != "Total")
    })
    
}) # END SERVER
