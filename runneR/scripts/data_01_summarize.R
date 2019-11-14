#'//////////////////////////////////////////////////////////////////////////////
#' FILE: data_01_summarize.R
#' AUTHOR: David Ruvolo
#' CREATED: 2019-11-12
#' MODIFIED: 2019-11-14
#' PURPOSE: summarizes all data needed for shiny app
#' STATUS: working
#' PACKAGES: see global
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////

# uncommen the following for debbuging
# suppressPackageStartupMessages(library(dplyr))
# source("utils/function_01_data.R")
# responses <- readRDS("data/running_data.RDS")

# ~ 0 ~
# let's create a single data object, which we will write all of our metrics
# and filtered data objects into. This object will be called runData()
runData <- list()

#'////////////////////////////////////////

# ~ 1 ~
# BUILDING PRIMARY DATASETS
# create a nested object that will receive the filted objects for running days
# and rest days. This object will be called runData$data().

# create nested object
runData$data <- list()

# ~ a ~
# filter data for running days
runData$data$runDF <- responses %>% filter(status == "yes")

# ~ b ~
# filter data for rest days
runData$data$restDF <- responses %>% filter(status == "no")

#'////////////////////////////////////////

# ~ 2 ~
# SUMMARIZE DATA ACROSS ALL MONTHS
# create a nested object that will receive the summary data for run days and
# rest days by month. This will call runData$data$... to create the summaries
# this data will be used to create the highlights and other objects. The object
# will be called `summaries`

# create nested object
runData$summaries <- list()


# ~ c ~
# calculate the total number of running days by month
runData$summaries$runDaysByMonth <- runData$data$runDF %>%
    group_by("yyyy_mm" = format(as.Date(date), "%Y-%m-01")) %>%
    count()

# ~ c ~
# pull the data for all rest days and save to runData$data$restDays
runData$summaries$restDaysByMonth <- runData$data$restDF %>%
    group_by("yyyy_mm" = format(as.Date(date), "%Y-%m-01")) %>%
    count()

#'////////////////////////////////////////

# ~ 3 ~
# create another nested object that will receive the metrics for the
# "your progress section". This object will be called "highlights"

# create nested object
runData$highlights <- list()

# ~ a ~
# what is the total number of days?
runData$highlights$days <- NROW(runData$data$runDF) + NROW(runData$data$restDF)

# ~ b ~
# what is the total number of running days?
runData$highlights$runningDays <- NROW(runData$data$runDF)

# ~ c ~
# what is the weekly average?
runData$highlights$week_avg <- round(runData$highlights$runningDays/(runData$highlights$days/7), 1)

# ~ d ~
# what is the monthly average?
runData$highlights$month_avg <- round( runData$highlights$runningDays / NROW(runData$summaries$runDaysByMonth), 1)


# ~ e ~
# what is the average distance run?
runData$highlights$dist_avg <- round(sum(runData$data$runDF$distance) / runData$highlights$runningDays,1)


# ~ f ~
# what is the total distance run?
runData$highlights$dist_tot <- round(sum(runData$data$runDF$distance), 2)



#'////////////////////////////////////////

# ~ 4 ~
# SUMMARIZE ROUTES + REASONS + RUNS BY DAY
# back to the summaries nested list, create a few summaries that will be used 
# in the visualisations. This includes: the number of runs by route, the reasons
# for not running ranked, distribution of runs by day of the week, and the average
# distance by month


# ~ a ~
# routes sum
runData$summaries$runsByRoute <- runData$data$runDF %>% 
    group_by(route) %>% 
    summarize(count = n()) %>% 
    arrange(desc(count)) 

# ~ b ~
# reasons not run
runData$summaries$restDaysByReason <- runData$data$restDF %>%
    group_by(reason_not_run) %>%
    summarize(count = n()) %>%
    arrange(desc(count))

# ~ c ~
# days run by the day of the week
runData$summaries$runsByWeekday <- runData$data$runDF %>%
    select(date, status) %>%
    mutate( 
        date = format(date, "%A"),
        date = factor(date, c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday","Sunday")),
        status = ifelse(status == "yes", 1, 0)
    ) %>%
    group_by(date) %>%
    summarize(count = sum(status))


# ~ d ~
# average distance by month
runData$summaries$avgDistByMonth <- runData$data$runDF %>%
    group_by(date = format(date, "%Y-%m-01")) %>%
    summarize("avg" = round(mean(distance), 2))

# ~ e ~
# run count by time of day
runData$summaries$runsByHour <- runData$data$runDF %>%
    filter(!is.na(time_run_start)) %>%
    mutate(start_time = format(lubridate::mdy_hm(time_run_start), "2099-12-31 %H:00")) %>%
    group_by(start_time) %>%
    summarize(count = n())


# time by distance refactored
runData$summaries$timeAndRunsByDistBin <- runData$data$runDF %>%
    filter(!is.na(time_run_start)) %>%
    select(date, distance, dur_est) %>%
    mutate(distance_bin = sapply(distance, binDistance)) %>%
    group_by(distance_bin) %>%
    summarize(runs = n(), time = round(mean(dur_est),2))


