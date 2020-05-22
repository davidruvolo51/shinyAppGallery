#'//////////////////////////////////////////////////////////////////////////////
#' FILE: global.R
#' AUTHOR: David Ruvolo
#' CREATED: 2018-05-24
#' MODIFIED: 2020-05-22
#' PURPOSE: global
#' PACKAGES: see below
#' STATUS: working
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)

# pkgs
suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(DT))
suppressPackageStartupMessages(library(browsertools))

# utils
source("utils/function_1_gridQuery.R")

# data
gridDF <- readRDS("data/grid_merged.RDS")
choices <- unique(gridDF$country)
choices <- c("", choices[order(choices)])