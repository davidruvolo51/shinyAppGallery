#'//////////////////////////////////////////////////////////////////////////////
#' FILE: global.R
#' AUTHOR: David Ruvolo
#' CREATED: 27 January 2019
#' MODIFIED: 27 January 2019
#' PURPOSE: central script for shiny app
#' PACKAGES: tbd
#' STATUS: in.progress
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)

# pkgs
suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(highcharter))

# data
responses <- readRDS("data/running_data.RDS")

# utils
source("utils/funcs.R")
