#'////////////////////////////////////////////////////////////////////////////
#' FILE: mod_ranking_viz.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-12-09
#' MODIFIED: 2020-12-09
#' PURPOSE: Ggplot2 ranked viz
#' STATUS: in.progress
#' PACKAGES: ggplot2
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' ranking_viz
#'
#' @param id a unique identifier
#'
#' @noRd
ranking_viz <- function(id) {
    ns <- NS(id)
    plotOutput(ns("ranking_plot"))
}

#' ranking_viz_server
#'
#' @param id a unique identifier
#' @param data input dataset
#' @param fo_id field office Id
#'
#' @noRd
ranking_viz_server <- function(id, data, fo_id) {
    ns <- session$ns

    output$ranking_plot <- renderPlot({
        d <- data %>%
            arrange(tot.cases) %>%
            mutate(
                codes = factor(codes, codes),
                color = case_when(
                    codes == fo_id ~ "target",
                    TRUE ~ "default"
                )
            )

        ggplot(data = d, aes(x = codes, y = tot.cases, fill = color)) +
        geom_bar(stat = "identity") +
        scale_fill_manual(values = c(target = "#700548", default = "#857a74")) +
        scale_y_continuous(
            breaks = seq(0, max(d$tot.cases), by = 50),
            expand = c(0.01, 0)
        ) +
        xlab(NULL) + ylab("Count") +
        theme(
            legend.position = "none",
            panel.background = element_blank(),
            axis.line.x = element_line(color = "#525252", size = .5),
            axis.line.y = element_line(color = "#525252", size = .5),
            panel.grid.major = element_line(color = "#bdbdbd", size = 0.15),
            panel.grid.minor = element_blank(),
            axis.ticks = element_line(color = "#bdbdbd", size = 0.15),
            axis.title = element_text(
                color = "#525252",
                size = 14,
                margin = margin(r = 10, unit = "pt")
            ),
            axis.text = element_text(size = 11, color = "#525252")
        )
    })
}