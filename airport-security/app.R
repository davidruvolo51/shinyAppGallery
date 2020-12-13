#'//////////////////////////////////////////////////////////////////////////////
#' FILE: app.R
#' AUTHOR: David Ruvolo
#' CREATED: 2018-04-07
#' MODIFIED: 2020-12-13
#' PURPOSE: example application
#' PACKAGES: see below
#' STATUS: in.progress
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////

#' install pkgs
#' install.packages("shiny")
#' install.packages("golem")
#' install.packages("dplyr")
#' install.packages("ggplot2")
#' install.packages("leaflet")
#' install.packages("networkD3")
#' install.packages("htmlwidgets")
#' install.packages("highcharter")
#' install.packages("browsertools")

#' pkgs
suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(highcharter))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(leaflet))

#' start app
run_app()