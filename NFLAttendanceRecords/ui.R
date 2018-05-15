# ================
# Shiny: ui.R     
# ================


shinyUI(navbarPage(
	# MAIN PARAMETERS-----------------------------------
	theme = shinytheme('journal'), # set theme
	title = 'NFL Attendance Records', # set title

	# UI-------------------------------------------------
	# main
    tabPanel("Main", uiOutput("Main")),
        
    # about
	tabPanel("About", uiOutput("About"))
    

)) # END UI
