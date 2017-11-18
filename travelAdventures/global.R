#'//////////////////////////////////////
#' FILE: global.R
#' AUTHOR: David Ruvolo
#' CREATED: April 24, 2017
#' PURPOSE: global R script for shiny app
#' PACKAGES:
#' NOTES:
#'//////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)

#' LOAD PACKAGES
library(shiny, quietly = T)
library(leaflet, quietly = T)
library(shinyjs, quietly = T)
library(tidyverse, quietly = T)

#' LOAD DATA
# mapDF <- read.csv("data/mapdata_master.csv")
mapDF <- read.csv("https://raw.githubusercontent.com/davidruvolo51/data/master/mapdata_master.csv")