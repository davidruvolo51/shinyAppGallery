#'//////////////////////////////////////////////////////////////////////////////
#' FILE: plot-tests.R
#' AUTHOR: David Ruvolo
#' CREATED: 07 April 2018
#' MODIFIED: 07 April 2018
#' PURPOSE: space to test plots
#' PACKAGES: tbd
#' STATUS: on.going
#' COMMENTS: NA
#'//////////////////////////////////////////////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)

# we want to make a chart that summarizes the allegations and what resolutions
# are tied to them - parallel coordinates plot with categorical data
# let's pull a subset of the data at one field office (that's how the app will
# work).

sample <- tsaALL[tsaALL$Field.Office=="NYC",]

sampleSUM <- sample %>%
    group_by(Allegation,Final.Disposition) %>%
    count()

# sampleSUM$n <- NULL

# devtools::install_github("timelyportfolio/parcoords")
# library(parcoords)

parcoords(sampleSUM[,1:2], rownames = F, reorderable = T)


#'////////////////////////////////////////
# let's try a snakey chart
# install.packages("networkD3")
library(networkD3)
library(htmlwidgets)

nodes <- data.frame(name = unique(c(sampleSUM$Allegation,sampleSUM$Final.Disposition)))

# source <- as.character(unique(sampleSUM$Allegation))
# target <- as.character(unique(sampleSUM$Final.Disposition))

nodes$cat <- ifelse(is.na(match(nodes$name,sampleSUM$Allegation)), "target","source")

sampleSUM$source <- match(sampleSUM$Allegation,nodes$name) - 1
sampleSUM$target <- match(sampleSUM$Final.Disposition, nodes$name) - 1
sampleSUM <- data.frame(sampleSUM, stringsAsFactors = F)

sn <- sankeyNetwork(
    Links = sampleSUM, Source = "source", Target = "target", 
    Value = "n", Nodes = nodes, nodeWidth = 0,
    NodeGroup = "cat", #LinkGroup = "Final.Disposition",
    margin = list("right" = 175),
    sinksRight = F,
    fontSize = 10)
# sn
schart <-onRender(sn,
         '
function(el, x){

// style labels and create an object
labels = d3.selectAll(".node text")
    .style("cursor", "default")
    .style("font-family","monospace")
    .style("font-size","8pt")
    .attr("x", function(d){
        if(d.group == "source"){
            return "-6 - x.options.nodeWidth";
         } else {
            return "6 + x.options.nodeWidth";
        }
    })
    .attr("text-anchor", function(d){
        if(d.group == "source"){
            return "end";
        } else {
            return "start";
        }
    })

// modify path colors
paths = d3.selectAll("path.link")
        .style("stroke","rgb(32,221,119)")
        .style("stroke-opacity","0.1")
        .on("mouseover",showConnections)
        .on("mouseout",hideConnections);

}');schart


# the node label placement doesn't quite work
#'////////////////////////////////////////
# devtools::install_github("gaborcsardi/sankey")
# library(sankey)
# edges <- sampleSUM[,1:2] %>% as.data.frame()
# nodes <- data.frame(id =sort(unique(c(edges[,1],edges[,2]))),stringsAsFactors = F)
# p <- make_sankey(edges = edges,nodes=nodes,)
# sankey(p,shape="invisible",boxw=0)

#'//////////////////////////////////////////////////////////////////////////////
# I want to make a horizontal bar chart that shows the placement of airports and
# highlights the selected airport field office with a label

library(ggplot2)

tsaSUM %>%
    arrange(tot.cases) %>%
    mutate(codes = factor(codes,codes),
           color = ifelse(codes == "PHI","target","default")) %>%
    ggplot(aes(x=codes, y=tot.cases, fill=color)) + 
        geom_bar(stat="identity") +
    scale_fill_manual(values = c("target"= "#2d7ddd","default"="#525252")) +
    # scale_y_continuous(breaks = seq(0,max(tsaSUM$tot.cases),by = 50),expand = c(0,0)) +
    xlab(NULL) + ylab("Count") +
    theme(
        legend.position = "none",
        panel.background = element_blank(),
        panel.grid.major = element_line(color="#bdbdbd",size=0.15),
        panel.grid.minor = element_blank(),
        axis.ticks = element_line(color="#bdbdbd",size=0.15)
    )













