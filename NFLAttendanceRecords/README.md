# Football Attendance Records - Shiny App 
Shiny App .R files

This is the second iteration of the app. 

### Overview

Use this visualization tool for exploring NFL attendance data from 2009 - 2015. Currently, I only have attendance records. I would like to include information on finances (i.e., team profits, ticket prices, etc.), track records (i.e., games won, lost, etc.), and other useful information. Reach out to me if you have any ideas.

### Data Source

All data comes from EPSN NFL attendance records <a href="http://espn.go.com/nfl/attendance/_/year/">ESPN NFL attendance Records</a> using the <i>rvest</i> package (v0.3.1). Further transformation and restructuring of the dataset was completed using the <i>base</i> functions and <i>car</i> package for recoding. The complete dataset contains attendance records from 2001 - 2015. However, data pre-2009 is not available or complete for all teams. The years 2009 - 2015 were selected for all teams as attendance records were available for all teams across all years. Future builds of this visualization tool is likely to include additional datasets (i.e., team revenue, team performance, etc.).


### Description

shiny app .R files for Football Attendance Records found at [davidruvolo/Football Attendance App](https://livedataoxford.shinyapps.io/NFLAttendanceRecords/)

Files included: 
- global.R
- server.R
- ui.R
- Data/
    - football_2008-2015.csv
    - football_2008-2015.xlsx
- external/
    - builder.R
    - football_map.R
    - tab_about.R
    - tab_main.R
- utilites/
    - dataFetch.R
    - dataRecode.R
    - leaflet_test.R
- www/
    - style.css
- NFLAttendanceRecords.Rproj
- google-analytics.js
