#'////////////////////////////////////////////////////////////////////////////
#' FILE: data-source.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-12-12
#' MODIFIED: 2020-12-12
#' PURPOSE: data source
#' STATUS: working; ongoing
#' PACKAGES: NA
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' ~ 1 ~
#' Clean dataset
#' tbd

#'//////////////////////////////////////

#' ~ 2 ~
#' Creating Summary
#' tbd

#'//////////////////////////////////////

#' ~ 3 ~
#' steps for creating yearly sum datase#
tsa_yr_sum <- tsaALL %>%
    group_by(Field.Office, Year.Cased.Opened) %>%
    summarize(count = n()) %>%
    ungroup() %>%
    group_by(date = paste0(Year.Cased.Opened, "-01", "01")) %>%
    summarize(
        total = sum(count),
        avg = mean(count),
        min = min(count),
        max = max(count),
        sd = sd(count)
    ) %>%
    as.data.frame()

saveRDS(tsa_yr_sum, "data/tsa_summary_year.RDS")