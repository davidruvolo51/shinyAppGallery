#' query variables
#'
#' Control the structure of the returned dataset
#'
#' @noRd
.grid_query_results <- c(
    "grid_id",
    "name",
    "city",
    "state",
    "state_code",
    "country",
    "country_code",
    "acronym",
    "alias"
)


#' grid_query
#'
#' Run queries on the grid.ac database
#'
#' @param data object containing the Grid.ac database
#' @param country the country name used to limit the data
#' @param city the city name used to limit the data
#' @param query the search query
#' @param columns an array containing variables to select
#'
#' @examples
#' grid_query(data = grid_ac, country = "japan")
#' grid_query(data= grid_ac, city = "new york")
#' grid_query(data = grid_ac, query = "medical")
#'
#' @import dplyr
#' @import stringr
#'
#' @noRd
grid_query <- function(
    data,
    country = NULL,
    city = NULL,
    query = NULL,
    columns = .grid_query_results
) {

    if (is.null(country)) {
        f_country <- NA
    } else {
        f_country <- tolower(country)
    }

    if (is.null(city)) {
        f_city <- NA
    } else {
        f_city <- tolower(city)
    }

    if (is.null(query)) {
        f_query <- NA
    } else {
        f_query <- tolower(query)
    }

    # 1. if all arguments are not NA
    if (!is.na(f_country) && !is.na(f_city) && !is.na(f_query)) {

        result <- data %>%
            filter(country == f_country, city == f_city) %>%
            mutate(
                flag = stringr::str_detect(
                    string = name,
                    pattern = f_query
                )
            )  %>%
            filter(flag == TRUE)

    } else if (!is.na(f_country) && !is.na(f_city) && is.na(f_query)) {

        # 2. `f_country` and `f_city` exists, but `f_query` is empty
        result <- data %>%
            filter(country == f_country, city == f_city)

    } else if (!is.na(f_country) & is.na(f_city) & !is.na(f_query)) {

        # 3. `f_country` exists, `f_city` is empty, `f_query` exists
        result <- data %>%
            filter(country == f_country) %>%
            mutate(
                flag = stringr::str_detect(
                    string = name,
                    pattern = f_query
                )
            )  %>%
            filter(flag == TRUE)

    } else if (!is.na(f_country) && is.na(f_city) && is.na(f_query)) {

        # 4. `f_country` exists, `f_city` is empty, `f_query` is empty
        result <- data %>%
            filter(country == f_country)

    } else if (is.na(f_country) && !is.na(f_city) && is.na(f_query)) {

        # 5. f_country:empty  +  f_city:exists  +  phrase:empty
        result <- data %>%
            filter(city == f_city)

    } else if (is.na(f_country) && !is.na(f_city) && !is.na(f_query)) {

        # 6. `f_country` is empty, `f_city` exists, `f_query` exists
        result <- data %>%
            filter(city == f_city) %>%
            mutate(
                flag = stringr::str_detect(
                    string = name,
                    pattern = f_query
                )
            )  %>%
            filter(flag == TRUE)

    } else if (is.na(f_country) && is.na(f_city) && !is.na(f_query)) {

    # 7. `f_country` is empty, `f_city` is empty, `f_query` exists
    result <- data %>%
        mutate(
            flag = stringr::str_detect(
                string = name,
                pattern = f_query
            )
        ) %>%
        filter(flag == TRUE)

    } else {

        # 8. `county`, `f_city`, and `f_query` are empty
        result <- data
    }

  # finalize output by selecting columns
  result %>%
    select(all_of(columns))
}
