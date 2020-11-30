# GRID_ID Finder

The purpose of the `GRID_ID` Finder shiny app is to quickly and efficiently interact with the GRID database. The entire database is 87k+ unique institutions. Using other programs to search the entire datase was painfully slow. I wanted to have a web app where I could build queries, apply filters, and search/ filter the results in order to extract a specific id. I also wanted a way to copy the results into another file. The `GRID_ID Finder` shiny app accomplishes this task.

GRID website: [grid.ac](https://grid.ac/)

To run this app, open up R and run the following code:

```r
install.packages("shiny")

shiny::runGitHub(
    repo = "shinyAppGallery",
    username = "davidruvolo51",
    subdir = "grid_id_finder"
)
```

## Purpose

The purpose of the `GRID_ID Finder` shiny app is to quickly and efficiently interact with the `GRID` database. The entire database is 87k+ unique institutions. Using other programs to search the entire datase was painfully slow. I wanted to have a web app where I could build queries, apply filters, and search/filter the results in order to extract a specific id. I also wanted a way to copy the results into another file. The `GRID_ID Finder` is the result of those wants.

GRID website: [grid.ac](https://grid.ac/)

**NOTE**

In this release, I included a sample of the full `grid_merged.RDS` data file (100 rows) due to the size of the grid.ac database. To access the full dataset, you will need to download, unpack, and merge files on your local machine. See `data/scripts/data_0_unpack.R` and `data/scripts/data_1_merge.R` for more information.

## The Search Function

The function `gridQuery` takes text input (i.e., keyword, phrase) and searches for matching strings in the grid database. The returned result is the row where matching string exists. Additional filters for country and city are optional. These filters may be useful for finding institutions in London, UK versus London, Canada. Here's the function:

```r
grid_query(country = NULL, city = NULL, query = NULL)
```

Essentially, this is a wrapper around the `str_detect` function from the `dplyr` family.

Running the function with the defaults will return the entire grid dataset. All the arguments are optional. If you are using function in the command line, you can enter a city filter without selecting a country.  

By default, the search function `grid_query()` returns the following columns from the grid.ac dataset:

| variable     | description                                                        |
| :----------- | :----------------------------------------------------------------- |
| grid_id      | grid.ac id                                                         |
| name         | name of the institution                                            |
| city         | name of the city where the institution is located                  |
| state        | name of the state where the institution is located (if applicable) |
| state_code   | the state code (if applicable)                                     |
| country      | country where the institution is located                           |
| country_code | country code                                                       |
| acronym      | institution's abbreviations                                        |
| alias        | alternative names                                                  |

The search function is located here: `R/grid_query.R`. You can add or remove additional variables at line 100 in the R script.

## Alternative Methods

You can also run the query in the R console. This might be useful if you want to view additional variables in the grid dataset and do not want to modify the gridQuery function. This can be done by following this example:

1 Search for organizations with `technology` in the name that are located in `Atlanta, Georgia, USA`.

```r
# manually call the function
grid_query(country = "United States", city="Atlanta", query = "technology")


# output
        grid_id                                         name    city   state state_code       country country_code acronym        alias
1 grid.213917.f              georgia institute of technology atlanta georgia      us-ga united states           us      gt georgia tech
2 grid.455531.3 global technology connection (united states) atlanta georgia      us-ga united states           us     gtc         <NA>
3 grid.492574.9           genetag technology (united states) atlanta georgia      us-ga united states           us    <NA>         <NA>
```

2 Take the `grid_id` associated with the Georgia Institute of Technology and run it against the grid dataset.

```{r}

# view the entire row
gridDF[gridDF$grid_id == "grid.213917.f",]

```

The additional information might be useful for determining if the input data matches the grid dataset. 

## Shortcuts

In the latest version, I added a menu bar (show more information, refresh app, and quit app) and keyboard shortcuts for accessing these features. These shortcuts are defined below.


| Element      |   Command   | Description                                               |
| :----------- | :---------: | :-------------------------------------------------------- |
| Copy         | `alt` + `c` | copy selected id to clipboard                             |
| Filters      | `alt` + `z` | reset filters and clear search field                      |
| Refresh      | `alt` + `r` | refresh the application                                   |
| Search Field | `alt` + `q` | activate the search field (i.e., move cursor to text box) |
| Search Table | `alt` + `t` | activate the search field attached to the results table   |

**NOTE**: These shortcuts work for chrome on windows. Depending on your operating system and preferred browser, you may need to add an additional key. For example: if you are using Firefox on a windows machine, you will also need to add `shift` (copy becomes: `alt` + `shift` + `c`).

For more information, visit [mozilla.org/../accesskey](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/accesskey)

## Disclaimer

This shiny app is not affiliated with grid.ac in any way. This app is designed to interact with a downloaded copy of the grid.ac database in a way that's efficient and user-friendly.
