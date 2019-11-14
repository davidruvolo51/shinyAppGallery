#'//////////////////////////////////////////////////////////////////////////////
#' FILE: global.R
#' AUTHOR: David Ruvolo
#' CREATED: 2019-01-27
#' MODIFIED: 2019-11-12
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
suppressPackageStartupMessages(library(lubridate))

# load data
responses <- readRDS("data/running_data.RDS")

# source functions and components
source("profile.R")
source("components/radio.R")
source("components/select.R")
source("utils/function_01_data.R")
source("utils/function_02_handlers.R")
source("utils/function_03_database.R")