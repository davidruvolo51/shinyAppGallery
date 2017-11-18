## Explore Google Maps Data in R

I started using google maps in 2011 to track favorites places and plan trips. To date, I've logged 2189 of my favorite places in 32 countries across 4 continents. This shiny app is an interactive map of my travel adventures. This dataset is available on github [here](https://github.com/davidruvolo51/data/blob/master/mapdata_master.csv") and the .R files can be found [here](https://github.com/davidruvolo51/shinyAppGallery/tree/master/travelAdventures).

If you'd like to explore your data, go to myactivity.google.com >> privacy >> control your content. I've also wrote a [guide](https://github.com/davidruvolo51/shinyAppGallery/tree/master/travelAdventures/data-processing) to cleaning and processing the data. This could be handy if you haven't worked with json files before 

To run this app locally, open up R and run the following code:

```r
install.packages("shiny")

shiny::runGitHub(
    repo = "shinyAppGallery",
    username = "davidruvolo51", 
    subdir = "travelAdventures"
)
```