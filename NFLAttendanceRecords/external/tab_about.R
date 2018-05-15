# .R - About panel
output$About <- renderUI({
    tabPanel("",
             # HEAD------------------------------------------------------------------
             # include external
             tags$head(includeScript('google-analytics.js')), # include GA tracker
             tags$link(rel='stylesheet', type='text/css', href='style.css'), # css file
             tags$link(rel="stylesheet", type="text/css", 
                       href="https://fonts.googleapis.com/css?family=Work+Sans:100,200,300,400,500"),
             
             # INSTRUCTIONS----------------------------------------------------------
             fluidRow(
                 # blank col
                 column(1),
                 # text
                 column(10, HTML("
                            <div class='text-instructions'>
                                The NFL Attendance Records visualiation was developed
                                by <a href='https://davidruvolo51.github.io'
                                target='_blank'>David Ruvolo</a>. This is the
                                second iteration.
                            </div>
                            <h3>How to use this app. </h3><br>
                            <div class='text-instructions'>
                            <ol>
                                <li>Navigate the map using '+' and '-' to zoom in
                                    and out, or use the scroll wheel on the 
                                    mouse/trackpad. Refresh the page to reset 
                                    the map.</li><br>
                                <li>To the right of the map, is the <i>options</i>
                                    column. Use the 'Variable' dropdown menu to 
                                    map an attendance variable. Mapping variable 
                                    choices include attendance for: home games,
                                    road games, or all games. All games is all
                                    road and home games combined. The default
                                    choice is all games.</li><br> 
                                <li>Next, select a year to view. The default is 2009 
                                    with a range from 2009 to 2015. Use the
                                    increment buttons to update the map by year.
                                    </li><br>
                                <li>The legend indicates the level of attendance
                                    incomparison with the national average (i.e.,
                                    all teams combined). A 
                                    <i>warmer</i> color (i.e., redder) indicates
                                    more fans attended the games for that team in
                                    that year when compared to the national average.
                                    </li><br>
                                <li> Back to the map: click on an marker to view 
                                    a team. The popup displays attendance records
                                    for the year selected. If you want to see how
                                    all game types varied over time, click the 
                                    <p style='display:inline;color:#fc4e2a;'>'Go!'</p>
                                    button. A mini profile will display below the map.
                                    </li><br>
                                <li> Briefly, the mini profile consists of three 
                                    charts: 1) all games over time, 
                                    2) home games over time, and 3) away games 
                                    over time. All charts display the national
                                    average (i.e., all teams combined). The
                                    team that you selected to build the report will
                                    always be displayed in 
                                    <p style='display:inline;color:#238443;'>green</p>,
                                    whereas the national average will always be 
                                    <p style='display:inline;color:#737373;'>gray</p>.</li>
                            </ol><br>
                            <h3>A few notes</h3><br>
                            <ol>
                                <li><b>Data Source</b>: All data comes from EPSN's
                                    <a href='http://espn.go.com/nfl/attendance/_/year/'
                                    target='_blank'>NFL Attendance Records Database</a>
                                    using the <i>rvest</i> package (v0.3.1). The
                                    complete dataset contains attendance records 
                                    from 2001 - 2015. However, data pre-2009 is not
                                    available or complete for all teams. The years
                                    2009 - 2015 were selected for all teams as
                                    attendance records were available for all teams
                                    across all years.</li><br> 
                            </div><br>"))
             )#,
             
             #br(), # break
    )
})