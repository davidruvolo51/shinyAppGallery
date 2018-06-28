#'//////////////////////////////////////////////////////////////////////////////
#' FILE: global.R
#' AUTHOR: David Ruvolo
#' CREATED: 24 May 2018
#' MODIFIED: 24 May 2018
#' PURPOSE: control script
#' PACKAGES: see below
#' STATUS: in.progress
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)

# install pkgs/addins - initial only
# devtools::install_github('mwip/beautifyR')
# install.packages(c("shiny","tidyverse", "shinyjs","knitr","DT","lubridate"),dependencies = TRUE)

# pkgs
suppressPackageStartupMessages(library(shiny,quietly = T))
suppressPackageStartupMessages(library(shinyjs,quietly = T))
suppressPackageStartupMessages(library(tidyverse,quietly = T))
suppressPackageStartupMessages(library(DT,quietly = T))
suppressPackageStartupMessages(library(lubridate,quietly = T))

# utils
source("utils/function_1_gridQuery.R")

# data
gridDF <- readRDS("data/grid_merged.RDS")

# gather choices
choices <- unique(gridDF$country)
choices <- choices[order(choices)]