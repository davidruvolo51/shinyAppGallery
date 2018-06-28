## GRID_ID Finder

The purpose of the `GRID_ID` Finder shiny app is to quickly and efficiently interact with the GRID database. The entire database is 87k+ unique institutions. Using other programs to search the entire datase was painfully slow. I wanted to have a web app where I could build queries, apply filters, and search/ filter the results in order to extract a specific id. I also wanted a way to copy the results into another file. The `GRID_ID Finder` shiny app accomplishes this task.

GRID website: [grid.ac](https://grid.ac/)

For more information, lauch the shiny app and click the info button.

To run this app, open up R and run the following code:

```r
install.packages("shiny")

shiny::runGitHub(
    repo = "shinyAppGallery",
    username = "davidruvolo51", 
    subdir = "grid_id_finder"
)
```

