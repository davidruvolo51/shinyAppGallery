#' ////////////////////////////////////////////////////////////////////////////
#' FILE: data_0_prep.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-03-15
#' MODIFIED: 2020-03-15
#' PURPOSE: prep data for example applicatino
#' STATUS: in.progress
#' PACKAGES: dplyr
#' COMMENTS: data comes from birdata explorer:
#' https://birdata.birdlife.org.au/explore. Download the species list
#' ////////////////////////////////////////////////////////////////////////////
options(stringsAsFactors = FALSE)

# pkgs
suppressPackageStartupMessages(library(tidyverse))
library(rvest)
library(httr)

# load data
raw <- read.csv("data/species.csv")

#' //////////////////////////////////////

#' ~ 0 ~
#' Select the Top 50 Most Reported Birds
#' order and sort data, create urls for webpages
# order and sort data
birds <- raw %>%
    arrange(-Count) %>%
    slice(1:25) %>%
    mutate(
        filename = paste0(
            gsub(
                pattern = "[[:space:]]|-",
                replacement = "_",
                x = tolower(Common.Name)
            ),
            ".jpg"
        ),
        profile = paste0(
            "https://birdlife.org.au/bird-profile/",
            gsub(
                pattern = "[[:space:]]",
                replacement = "-",
                x = tolower(Common.Name)
            )
        ),
        wiki = paste0(
            "https://en.wikipedia.org/wiki/",
            gsub(
                pattern = "[[:space:]]|-",
                replacement = "_",
                x = tools::toTitleCase(Common.Name)
            )
        ),
        status = NA
    )

# fix wiki links as needed
birds$wiki[birds$Common.Name == "Grey Shrike-thrush"] <- "https://en.wikipedia.org/wiki/Grey_shrikethrush"
birds$wiki[birds$Common.Name == "White-faced Heron"] <- "https://en.wikipedia.org/wiki/White-faced_heron"
birds$wiki[birds$Common.Name == "Black-faced Cuckoo-shrike"] <- "https://en.wikipedia.org/wiki/Black-faced_cuckooshrike"

#' //////////////////////////////////////

#' ~ 1 ~
#' Get Images

# set params
index <- 17
reps <- 17 #' NROW(birds)
while (index <= reps) {

    cat("Starting", index, " of ", reps, "...")

    # send request
    response <- read_html(birds$wiki[index])

    # extract image src
    src <- response %>%
        html_node("table.biota a.image img") %>%
        html_attr("src") %>%
        paste0("https:", .)

    # send request for images
    if (isFALSE(http_error(src))) {

        # build output filepath
        path <- paste0("www/images/", birds$filename[index])

        # download file
        GET(src, write_disk(path))

        # update status
        birds$status[index] <- TRUE

    } else {
        bird$status[index] <- FALSE
    }

    # complet iteration
    cat("Complete!\n")
    index <- index + 1
    # Sys.sleep(runif(1, 2, 4))

}

#'//////////////////////////////////////

#' ~ 2 ~
#' final transformations and save birds dataset
final <- birds %>%
    mutate(
        image = paste0(
            "<img src='images/", filename, "' ",
            "class='bird-profile' ",
            "loading='lazy' ",
            "alt='a ", Common.Name, "'/>"
        ),
        Common.Name = paste0(
            "<p class='bird-name-group'>",
            "<a class='bird-name-common' href='", profile, "'>",
            Common.Name,
            "</a>",
            "<span class='bird-name-sci'>",
            Scientific.Name,
            "</span>",
            "</p>"
        ),
        Count = format(Count, big.mark = ",")
    ) %>%
    select(Profile = image, "Species" = Common.Name, Count, Reporting.Rate)

saveRDS(final, "data/birds.RDS")