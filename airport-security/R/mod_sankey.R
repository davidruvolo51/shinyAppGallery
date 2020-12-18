#'////////////////////////////////////////////////////////////////////////////
#' FILE: mod_sankey.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-12-09
#' MODIFIED: 2020-12-12
#' PURPOSE: sankey diagram
#' STATUS: in.progress
#' PACKAGES: networkD3; htmlwidgets
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' mod_sankey
#'
#' UI module for networkD3 sankey viz
#'
#' @param id unique identifier
#'
#' @noRd
mod_sankey <- function(id) {
    networkD3::sankeyNetworkOutput(NS(id, "sankey"), height = "600px")
}

#' mod_sankey_server
#'
#' Server-side module for rendering sankey
#'
#' @param id unique identifier
#' @param data input dataset
#' @param group a grouping variable
#' @param value a continuous variable
#'
#' @noRd
mod_sankey_server <- function(id, data, group, value) {
    moduleServer(
        id,
        function(input, output, session) {
            sankey_data <- data %>%
                ungroup() %>%
                group_by(.data[[group]], .data[[value]]) %>%
                count() %>%
                as.data.frame()

            # build nodes
            nodes <- data.frame(name = unique(c(data[, group], data[, value])))
            nodes$cat <- case_when(
                is.na(match(nodes$name, sankey_data[[group]])) ~ "target",
                TRUE ~ "source"
            )

            sankey_data$source <- match(sankey_data[[group]], nodes$name) - 1
            sankey_data$target <- match(sankey_data[[value]], nodes$name) - 1

            output$sankey <- networkD3::renderSankeyNetwork({
                s <- networkD3::sankeyNetwork(
                    Links = sankey_data,
                    Source = "source",
                    Target = "target",
                    Value = "n",
                    Nodes = nodes,
                    nodeWidth = 0,
                    NodeGroup = "cat",
                    margin = list("right" = 175),
                    sinksRight = FALSE,
                    fontSize = 10
                )
                htmlwidgets::onRender(
                    s,
                    'function(el, x) {
                        // style labels and create an object
                        labels = d3.selectAll(".node text")
                            .style("cursor", "default")
                            .style("font-family","monospace")
                            .style("font-size","8pt")
                            .attr("x", function(d) {
                            // set label position based on group
                                if(d.group == "source") {
                                    return "-6 - x.options.nodeWidth";
                                } else {
                                    return "6 + x.options.nodeWidth";
                                }
                            })
                            .attr("text-anchor", function(d) {
                                // set label anchor based on group
                                if(d.group == "source") {
                                    return "end";
                                } else {
                                    return "start";
                                }
                            })

                        // modify path colors
                        paths = d3.selectAll("path.link")
                            .style("stroke","rgb(112,5,72)")
                            .style("stroke-opacity","0.1")
                    }'
                )
            })
        }
    )
}