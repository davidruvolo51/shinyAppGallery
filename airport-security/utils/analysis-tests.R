#'//////////////////////////////////////////////////////////////////////////////
#' FILE: analysis-tests.R
#' AUTHOR: David Ruvolo
#' CREATED: 08 April 2018
#' MODIFIED: 08 April 2018
#' PURPOSE: testing for summary stats
#' PACKAGES: dplyr
#' STATUS: in.progress
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)

# subset for a specific FO
df <- subset(tsaALL,Field.Office == "NYC")

# summarize by year
years <- df %>% group_by(Year.Cased.Opened) %>% summarize(count = n())
years_mean <- mean(years$count)
years_min <- years %>% top_n(-1)
years_max <- years %>% top_n(1)
years_sd <- sd(years$count)
