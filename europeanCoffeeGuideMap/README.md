## European Coffee Guide

I'm a coffee drinker and I love to travel. When I lived in the UK, I traveled frequently and explored the local specialty roasters. The [European Coffee Trip](https://europeancoffeetrip.com/) team creates incredible coffee travel guides to many cities around Europe. I've used this site before every trip and enjoyed wonderful cups of coffee in the most unique cafes. 

I wanted to created an interactive map of all coffee shop guides, which could be used to plan daily itineraries and sightseeing breaks. This app was a wonderful introduction into web scrapping.

To run this app, open up R and run the following code:

```r
install.packages("shiny")

shiny::runGitHub(
    repo = "shinyAppGallery",
    username = "davidruvolo51", 
    subdir = "europeanCoffeeGuideMap"
)
```

