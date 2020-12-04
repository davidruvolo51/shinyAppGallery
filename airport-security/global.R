#'//////////////////////////////////////////////////////////////////////////////
#' FILE: global.R
#' AUTHOR: David Ruvolo
#' CREATED: 07 April 2018
#' MODIFIED: 07 April 2018
#' PURPOSE: central script for loading data, pkgs, funcs
#' PACKAGES: see below
#' STATUS: in progress
#' COMMENTS: major update in 2018
#'//////////////////////////////////////////////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)

# pkgs
suppressPackageStartupMessages(library(shiny,quietly = T))
suppressPackageStartupMessages(library(shinyjs,quietly = T))
suppressPackageStartupMessages(library(dplyr,quietly = T))
suppressPackageStartupMessages(library(leaflet,quietly = T))
suppressPackageStartupMessages(library(highcharter,quietly = T))
suppressPackageStartupMessages(library(networkD3,quietly = T))
suppressPackageStartupMessages(library(htmlwidgets,quietly = T))
suppressPackageStartupMessages(library(ggplot2,quietly = T))

# data
tsaALL <- readRDS("data/tsa_cleaned.RDS")
tsaSUM <- readRDS("data/tsa_summary.RDS")
tsaYRS <- readRDS("data/tsa_summary_year.RDS")



# steps for creating yearly sum datase#
# year_sum_office <- tsaALL %>%
#     group_by(Field.Office, Year.Cased.Opened) %>%
#     summarize(count = n())
# 
# year_sum_total <- year_sum_office %>%
#     group_by("date" = paste0(Year.Cased.Opened,"-01","-01")) %>%
#     summarize(total = sum(count), avg = mean(count),min = min(count),
#               max = max(count), sd = sd(count)) %>%
#     as.data.frame()
# saveRDS(year_sum_total,"data/tsa_summary_year.RDS")
