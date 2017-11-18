#'////////////////////////////////////////////////
#' FILE: global.R
#' AUTHOR: David Ruvolo
#' CREATED: April 18, 2017
#' PURPOSE: controller for shinyapp
#' NOTES: NULL
#'////////////////////////////////////////////////
# load packages
library(shiny)
library(leaflet)

#///////////////
# load data
euroCoffee <- read.csv("data/europeancoffeetrip_cafes_MASTER.csv", stringsAsFactors = F)
