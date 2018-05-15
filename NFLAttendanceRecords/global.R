# ================
# Shiny: global.R     
# ================

# LOAD PACKAGES
# default
library(shiny, quietly = T)
library(shinythemes,quietly = T)
library(shinyjs,quietly = T)
library(shinyBS,quietly = T)

# graphing
library(leaflet, quietly = T)
library(plotly, quietly = T)

# LOAD FUNCTIONS



# LOAD DATA
football <- read.csv("data/football_2008-2015.csv") # main DF
totals <- subset(football , Team == "Total") # isolate totals
