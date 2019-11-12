#'//////////////////////////////////////////////////////////////////////////////
#' FILE: ui.R
#' AUTHOR: David Ruvolo
#' CREATED: 27 January 2019
#' MODIFIED: 27 January 2019
#' PURPOSE: UI
#' PACKAGES: tbd
#' STATUS: in.progress
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)

# components
source("profile.R", local = TRUE)
source("components/elements/radio.R", local = TRUE)
source("components/elements/select.R", local = TRUE)

# ui
ui <- tagList(
    
    # <head>
    tags$head(
        tags$meta("charset" ="utf-8"),
        tags$meta("http-equiv" ="X-UA-Compatible", "content" ="IE=edge"),
        tags$meta("name" ="viewport", "content"="width=device-width, initial-scale=1"),
        # tags$link("href"="css/styles.css", "rel"="stylesheet")
        tags$link("href"="css/styles.min.css", "rel"="stylesheet")
    ),
    
    #'////////////////////////////////////////
    # body
    tags$body(

        # screen reader text
        tags$a(href="#main", class="screen-reader-text", "skip to main content"),

        # <header>
        tags$header(class="header", role="",
                 tags$a(class="header-item", href="/", "runneR"),
                 
                 # buttons
                 tags$div(class="header-item",
                    tags$button(type="button", id="newEntry", class="b b-primary", "New Entry")
                 )
        ),

        #'////////////////////////////////////////
        # modals

        # modal - already logged
        # tags$div(role="dialog", id="dialog_logged_done", class="dialog", `aria-labelledBy`="loged_already_title", `aria-modal`="true",
        #     tags$section(class="form",
        #         tags$h2(id="loged_already_title", "You've already logged for today!"),
        #         tags$button(type="button", id="btn-back", class="action-button shiny-bound-input b b-primary", "Back")
        #     )
        # ),

        # # modal - did you run today?
        # tags$div(role="dialog", id="dialog_run_intial", class="dialog", `aria-labelledBy`="form-run-question", `aria-modal`="true",
        #     tags$form(class="form", id="form-run-initial",
        #         tags$legend("Did you run today?", id="form-run-question"),
        #         tags$button(type="button", id="no", class="action-button shiny-bound-input b b-circle b-no", "No"),
        #         tags$button(type="button", id="yes", class="action-button shiny-bound-input b b-circle b-yes", "Yes")
        #     )
        # ),

        # # modal - run = yes
        # tags$div(role="dialog", id="dialog_run_", class="dialog", `aria-labelledBy`="", `aria-modal`="true",
        #     tags$form(class="form", id="form-run-yes",
        #         tags$h2("Excellent work!"),
        #         tags$p("Let's get your run logged"),
        #         tags$fieldset(class="grid grid-50x2-layout", `aria-labelledby`="route_information_title",
        #             tags$div(class="grid-child form-grid-child",
        #                 tags$h3(id="route_information_title", "Route Information"),
        #                 tags$p("Enter information about your run. This includes the route name, time you started your run, distance and time. Use your favorite running app or watch to extract this information. If you do not know or were unable to capture this data, give an estimate. If your route isn't listed, you will need to update your running profile.")
        #             ),
        #             tags$div(class="grid-child form-grid-child",
        #                 tags$label("Select a route", `for`="run-route"),
        #                 selectOptions(inputId="run-route", value = routes, string = routes),
        #                 tags$label("Enter the total distance run (kms)"),
        #                 tags$input(type="number", id="run-dist", name="run-dist", min=0, max=100, value=0),
        #                 tags$label(`for`="run-time", "Enter the time you started your run (HH:MM)"),
        #                 tags$input(type="time", id="run-time", name="run-time", step="60"),
        #                 tags$label(`for`="run-dur", "Enter the duration of your run (HH:MM)"),
        #                 tags$input(type="time", id="run-dur", name="run-dur", step="60")
        #             )
        #         ),
        #         tags$button(type="button", id="form-yes-cancel", class="action-button shiny-bound-input b b-secondary", "Cancel"), 
        #         tags$button(type="button", id="form-yes-submit", class="action-button shiny-bound-input b b-primary", "Submit")
        #     )
        # ),

        # # modal - run = no
        # tags$div(role="dialog", id="dialog_run_", class="dialog", `aria-labelledBy`="", `aria-modal`="true",
        #     tags$form(class="form", id="form-run-no",
        #         tags$h2("Enjoy your rest day!"),
        #         tags$fieldset(class="grid grid-50x2-layout",
        #             tags$div(class="grid-child form-grid-child",
        #                 tags$h3("Keep track of your rest day"),
        #                 tags$p("Everyone needs a rest day. Remember to stretch often and drink plenty of fluids. Let's log this as a rest day.")
        #             ),
        #             tags$div(class="grid-child form-grid-child",
        #                 tags$label(`for`="no-run-reason", "Select a reason for the rest day"),
        #                 selectOptions(inputId="no-run-reason", value=reasons, string=reasons)
        #             )
        #         ),
        #         tags$button(type="button", id="form-no-cancel", class="action-button shiny-bound-input b b-secondary", "Cancel"),  
        #         tags$button(type="button", id="form-no-submit", class="action-button shiny-bound-input b b-primary", "Submit")  
        #     )
        # ),       

        # <main>
        tags$main(class = "main", id="main",
            tags$header(class="hero", id="title",
                tags$div(class="hero-content",
                    HTML('<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve" width="50" height="50" viewBox="0 0 50 60" preserveAspectRatio="xMinYMax" class="hero-icon"><path stroke="#3f454b" stroke-width="2px" fill="#a6bbda" fill-opacity="0.8" d="M50,47 L 5,44 Q2,40 5,39 L 48,43 Q50,45 48,47 M6,25 L 5,21"/><path stroke="#3f454b" stroke-width="2px" fill="#E64636" fill-opacity="0.38" d="M5,39 Q4,25 6,25 Q10,22 12,26 Q18,37 28,28 L 40,32 Q50,36 48,43 Z"/><path stroke="#3f454b" stroke-width="2px" fill="#ffffff" d="M5,32 Q10,32 15,40 L 5,39 Q3,40 5,32"/><path stroke="#3f454b" stroke-width="2px" fill="none" d="M35,31 L 33,34 M38,32 L 36,35 M41,33 L 39,36"/></svg>'),
                    tags$h1("runner"),
                    tags$h2("Track and monitor your running habits"),
                    tags$p("Introducing runner. A shiny app for logging, managing and visualising your running data. Log a new run or view your running history.")#,
                    # tags$button(type="button", id="viewData", class="action-button shiny-bound-input b b-secondary", "View"),
                    # tags$button(type="button", id="newData", class="action-button shiny-bound-input b b-primary", "New Entry")
                )
            ),
            
            # viz for: total distance + avg. distance
            tags$section(class="main-section",  `aria-labelledBy`="current-progress",
                tags$h2("Your progress to date", id="current-progress"),
                tags$div(class="grid grid-50x2-layout",
                    tags$figure(class="grid-child viz-box",
                        tags$figcaption("Distance to date (miles)"),
                        tags$output(id="distance-tot")
                    ),
                    tags$figure(class="grid-child viz-box",
                        tags$figcaption("Average distance per run (miles)"),
                        tags$output(id="distance-avg")
                    )
                ),
                tags$div(class="grid grid-25x4-layout",
                    tags$figure(class="grid-child viz-box",
                        tags$figcaption("Days in training"),
                        tags$output(id="days-total")
                    ),
                    tags$figure(class="grid-child viz-box",
                        tags$figcaption("Total running days"),
                        tags$output(id="days-run-total")
                    ),
                    tags$figure(class="grid-child viz-box",
                        tags$figcaption("Avg. runs per week"),
                        tags$output(id="days-run-week")
                    ),
                    tags$figure(class="grid-child viz-box",
                        tags$figcaption("Avg. runs per month"),
                        tags$output(id="days-run-month")
                    )
                )
            ),

            # section: running days vs off days + runs by day of the week
            tags$section(class="main-section", `aria-labelledBy`="overview-of-runs",
                tags$h2("Overview of your runs", id="overview-of-runs"),
                tags$div(class="grid grid-50x2-layout", 
                    tags$figure(class="grid-child viz-box",
                        tags$figcaption("Running days vs. off days"),
                        highcharter::highchartOutput("daysPlot")
                    ),
                    tags$figure(class="grid-child viz-box",
                        tags$figcaption("Runs by day of the week"),
                        highcharter::highchartOutput("weekDist")
                    )
                )
            ),

            # section: distance
            tags$section(class="main-section", `aria-labelledBy`="summary-of-distance",
                tags$h2("Summary on Distance", id="summary-of-distance"),
                tags$div(class="grid grid-50x2-layout",
                    tags$figure(class="grid-child viz-box",
                        tags$figcaption("Distance by time"),
                        tags$form(class="viz-form",
                            radioInputGroup(
                                inputId ="distanceToggle", label=c("Days", "Months"), value=c("days", "months"), selected=c(TRUE, FALSE)
                            )
                        ),
                        highcharter::highchartOutput("distBy")
                    ),
                    tags$figure(class="grid-child viz-box",
                        tags$figcaption("Duration by distance"),
                        highcharter::highchartOutput("runDuration")
                    )
                )
            ),

            # section: running behaviors
            tags$section(class="main-section", `aria-labelledBy`="running-behaviors-title",
                tags$h2("Overview of running behaviors", id="running-behaviors-title"),
                tags$div(class="grid grid-50x2-layout",
                    tags$figure(class="grid-child viz-box",
                        tags$figcaption("Route preferences"),
                        highcharter::highchartOutput("runsByRoute")
                    ),
                    tags$figure(class="grid-child viz-box",
                        tags$figcaption("Reasons for off days"),
                        highcharter::highchartOutput("reasonsNotRun")
                    ),
                    tags$figure(class="grid-child viz-box",
                        tags$figcaption("Time of day runs started"),
                        highcharter::highchartOutput("timeStartRun")
                    )
                )
            )
        ),
        # footer
        tags$footer(class="footer",
            tags$h2("runneR"),
            tags$ul(class="menu",
                tags$li(class="menu-item",
                    tags$a(class="menu-link", href="https://github.com/davidruvolo51/shinyAppGallery", "Github")
                ),
                tags$li(class="menu-item",
                    tags$a(class="menu-link", href="https://davidruvolo51.github.io/shinytutorials/gallery", "shinyGallery")
                ),
                tags$li(class="menu-item",
                    tags$a(class="menu-link", href="https://davidruvolo51.github.io/shinytutorials/", "shinyTutorials")
                ),
            )
        ),
        # <script>
        # tags$script(src="js/index.js")
        tags$script(src="js/index.min.js")
    )
)
