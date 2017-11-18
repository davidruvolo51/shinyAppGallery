# Exploring Google Maps Data
## Steps for processing data

## Source data
1. go to takeout.google.com
2. follow steps to download maps data
3. unzip and then begin with the rest of the script. :-) 

## Cleaning 
For this project, I've created a dir title, 'data', and have placed all data files here. Within 'data', I've created a child dir titled, 'batches', which is contains all of the data downloaded (zip file) from takeout.google.com. The extracted files will contain a master folder titled, 'Takeout'. I've renamed that dir with the current date (formatted as yyyy-mm-dd) in order to keep track of batches. The following code block will setup the data directory for you.

#### 1. Setup directory
```r
pwd <- getwd()
batchDirName <- paste0("Takeout-",format(Sys.Date(),"%Y-%m-%d"))
dir.create(path = file.path(pwd,"data"))            
dir.create(path = file.path(pwd,"data","batches")) 
dir.create(path = file.path(pwd,"data","batches",batchDirName)) 
```
(We will setup the entire project at the end of this script.)

Move the contents of the extracted Takeout into the newly created batch path. e.g., 'Takeout-%Y-%m-%d/...' If it works, pick up here.

#### Load JSON file

```r
# set batch id
batchDir <- "Takeout-2017-10-14"

# create file path
file <- paste0("data/batches/",batchDir,"/Maps (your places)/Saved Places.json")

# load json file: 'Saved Places' (Make sure the package jsonlite is installed)
rawJSN <- jsonlite::fromJSON(txt=file, simplifyDataFrame = T)
```

_GATHER DATA_

I would strongly recommend running `str(rawJSN)` to look for any changes in the structure of the json file. More importantly it will help describe what the  next steps are doing. First, run the following line.

```r
names(rawJSN)
```
 
 If you run names(rawJSN), this ojbect contains two elements: "type" and "features":
     
     - `rawJSN$type`: contains a character string 'FeatureCollection'. There's nothing there.
     - `rawJSN$feaures`: contains all of the data.
     
Let's look at the structure of rawJSN$features

```r
str(rawJSN$features)
```

`rawJSN$features` contains many child, subchild, subsubchild, etc. elements. I'll briefly describe them here.
 
     - `...$geometry`: Only contains coordinates for your saved places. I won't go into details about elements nested within geometry. We can ignore the coords found here as it's also stored elsewhere that doesn't require mutating elements. The 'geometry' elements seems as though it would be used for placing the icons (stars, favorites, etc.) on map of your places.     
     - `...$properties`: This element contains all the data. Here we will extract the following nested elements
     - `...$Location`: all location data (names, address, coords, name, country,etc.)
     - `...$Updated`: timestamp for when the placed was marked. This will be useful in the future when you add new data
     - `...$Title`: the business names of all your saved places
     - `...$Google Maps URL`: url links to the place of business on google maps

Okay, so let's do this

```r
rawJSN_locations <- rawJSN$features$properties$Location
rawJSN_timestamps <- rawJSN$features$properties$Updated
rawJSN_titles <- rawJSN$features$properties$Title
rawJSN_urls <- rawJSN$features$properties$`Google Maps URL`
```

First, make sure the dimensions of each element contain the same number of observations

```r
dim(rawJSN_locations)
length(rawJSN_timestamps)
length(rawJSN_titles)
length(rawJSN_urls)
```

Great. We isolated the elements and verified they contain the same number of elements. Now, let's take a look at the structure of each.

```r 
str(rawJSN_locations)
str(rawJSN_timestamps)
str(rawJSN_titles)
str(rawJSN_urls)
```

Timestamps and titles look good. We will need to add it to a data.frame, but for now we can leave it alone. However, the strcture of raw_locations is a little wonky. To make sure nothing has changed, rawJSN_locations shoudl contain the following names:

     - Address
     - Business Name
     - Country Code
     - Geo Coordinates
     - Latitude
     - Longitude
 
Uh, oh! Take another look at 'Geo Coordinates'. This is a nested dataframe. Not cool! It may appear that `rawJS_locations$Latitude` and `rawJS_locations$Longitude` are empty, but are populated with a handful of coordinates. If you run look at both sets of coordinates, you can see that where `rawJSN_locations$Latitude` and `rawJSN_locations$Longitude` are NA, the missing coordinates can be found under `rawJSN_locations$Geo Coordinates$Latitude` and `rawJSN_locations$Geo Coordinates$Longitude`. So let's look at it.

```r 
head(
  cbind(
    rawJSN_locations$Latitude, 
    rawJSN_locations$`Geo Coordinates`$Latitude),
  100
)
```

So what we need to do is to extract `Geo Coordinates` from rawJSN_locations and assign it to a new object, and then drop `Geo Coordinates` from rawJSN_locations. 

```r
# extract
extracted_coords <- rawJSN_locations$`Geo Coordinates` 

# drop
rawJSN_locations <- rawJSN_locations[, !names(rawJSN_locations) %in% "Geo Coordinates"]
```

Let's change the names of the extracted_coords to something that's more noticeable (and less confusing) for when we make the master dataset

```r
colnames(extracted_coords) <- c("lat","long")
```

Great. So that's all we need to do for extracting elements. Now let's combine them into one dataset.

```r
mapDF <- cbind(
    rawJSN_titles,
    rawJSN_locations,
    extracted_coords,
    rawJSN_timestamps,
    rawJSN_urls
)
```

Cool. We are almost there. Let's change the column names. Where 'rawJSN' is present. We will also enforce lowercase to all column names. It's annoying otherwise!

```r
colnames(mapDF)[c(1,3,4,9,10)] <- c("titles",
                                    "business_name",
                                    "country",
                                    "timestamps",
                                    "google_urls")

colnames(mapDF) <- tolower(colnames(mapDF))
```

#### Congratulations! The data is now in one place. Let's get ready to clean!

---

Before we move on to cleaning and processing. Let's take a break and look at the data. Here are few things that you could at this point.

1. Plot the lat and long to see what the data looks like

```
plot(x=mapDF$long, y=mapDF$lat)
```

You may recognize the arrangement of points. It might make the shape of your city, county, state, country, or counties you've visited.

2. If you love to travel internationally, let's look at the number of starred places by counties by ranking them.

```r
library(tidyverse)
library(forcats)

mapDF %>% 
    filter(country !="NA") %>%
    group_by(country) %>% 
    summarize(count = n()) %>%
    arrange(count) %>%
    mutate(country=factor(country,country)) %>%
    ggplot(aes(x=country,y=count)) + 
    geom_bar(stat="identity", fill="#2D7DDD") +
    coord_flip() +
    scale_y_continuous(breaks = seq(0,700,50), expand=c(0.01,0)) +
    ylab("number of starred places") + 
    theme(legend.position = "none", 
          panel.background = element_blank(),
          panel.grid.major = element_line(color="#bdbdbd",size=0.15),
          axis.ticks = element_blank())
```

Cool. So you've looked at number of starred places by country. Here's a few other research questions. Here's where the timestamp var will come into play.

     - What does the count of starred places over time look like? 
     - What time of day are you likely to star places?
     

Let's load some packages

```r
library(ggplot2)
library(scales)
```

Let's get some summary stats (we will use this for both plots). We want to get the max date and return the value as month and year (e.g., March 2017).

```r
maxDate <- mapDF %>% 
    select(timestamps) %>%
    mutate(date = format(as.Date(timestamps),"%Y-%m-%d")) %>%
    mutate(year = format(as.Date(timestamps),"%Y")) %>%
    mutate(month = format(as.Date(timestamps),"%B")) %>%
    arrange(date) %>%
    filter(date == max(date)) %>%
    distinct(date,year, month) %>%
    select(month,year) %>%
    paste0(collapse = " ")

minDate <- mapDF %>% 
    select(timestamps) %>%
    mutate(date = format(as.Date(timestamps),"%Y-%m-%d")) %>%
    mutate(year = format(as.Date(timestamps),"%Y")) %>%
    mutate(month = format(as.Date(timestamps),"%B")) %>%
    arrange(date) %>%
    filter(date == min(date)) %>%
    distinct(date,year, month) %>%
    select(month,year) %>%
    paste0(collapse = " ")
```

Let's plot the number of starred places over time.

```r
mapDF %>% 
    mutate("date" = format(as.Date(timestamps),"%Y-%m-01")) %>%
    group_by(date) %>%
    summarize(count=n()) %>% 
    ggplot(aes(x=as.POSIXct(date), y=count)) +
    geom_point(color="#2D7DDD",size=2) +
    geom_line(color="#2D7DDD") +
    scale_x_datetime(date_breaks="4 months",
                     date_minor_breaks = "2 month",
                     date_labels = "%b-%y") +
    ggtitle("Summary of My Google Map Data", 
            subtitle = paste0("Starred places over time: From ",
                              minDate, " to ",maxDate)) +
    theme(axis.text.x = element_text(angle = 45, hjust=1),
          panel.background = element_blank(),
          panel.grid.major = element_line(color="#bdbdbd",size=0.15),
          panel.grid.minor = element_line(color="#f0f0f0",size=0.15),
          axis.ticks = element_blank()) +
    xlab(NULL)
```
 
Let's plot the when places were starred over the course of a day (time of day)

```r
mapDF %>% 
    mutate("date_time" = paste0("2020-12-31 ",
                                gsub(pattern = "T", replacement =" ",timestamps) %>%
                                    gsub(pattern = "Z", replacement ="",timestamps) %>%
                                    as.POSIXct() %>%
                                    format("%H:%M"))) %>% # add %S to include seconds, but it's messy
    group_by(date_time) %>%
    summarize(count=n()) %>% 
    ggplot(aes(x=as.POSIXct(date_time), y=count)) +
    geom_line(color="#2D7DDD") +
    scale_x_datetime(date_breaks = "2 hour",
                     date_minor_breaks = "1 hour",
                     date_labels = "%H:%M",
                     expand=c(0,0)) +
    ggtitle("Analyzing travel adventures using google map data", 
            subtitle = paste0("Time of day I starred places: ",
                              minDate, " through ",maxDate)) +
    xlab(NULL) + ylab("Places Starred") + 
    theme(panel.background = element_blank(),
          panel.grid.major = element_line(color="#bdbdbd",size=0.15),
          panel.grid.minor = element_line(color="#f0f0f0",size=0.15),
          axis.ticks = element_blank())
```

--- 

## Cleaning
 
Hope you've learned something about your google maps history! Now let's get to cleaning the data to make some fun visuals! So here's what we have to do:
 
1. merge the geo coordinates into two columns (remember there's two sets). Where there are missing data in geo coordinates ('lat' and 'long'), get value from 'latitude' and 'longitude'.
2. Clean missing addresses. If addresses are missing, then substitute with business name.
3. Clean missing bussines name. If there are businesses are missing, then replace with address.

Here we go!

```r
for(i in 1:NROW(mapDF)){
    
    # clean missing lat
    if(is.na(mapDF$lat[[i]]) & !is.na(mapDF$latitude[[i]])){
        mapDF$lat[[i]] <- mapDF$latitude[[i]]
    } 
    
    # clean missing long
    if(is.na(mapDF$long[[i]]) & !is.na(mapDF$longitude[[i]])){
        mapDF$long[[i]] <- mapDF$longitude[[i]]
    }
    
    # clean missing address
    if(is.na(mapDF$address[[i]]) & !is.na(mapDF$business_name[[i]])){
        mapDF$address[[i]] <- mapDF$business_name[[i]]
    }
    
    # clean missing place
    if(is.na(mapDF$business_name[[i]]) & !is.na(mapDF$address[[i]])){
        mapDF$business_name[[i]] <- mapDF$address[[i]]
    }
}
```


Next, we will recode the 'timestamps' column into a few columns

1. date: extract date as yyyy-mm-dd
2. time: gsub (replace 'T' and 'Z' with " " ) timestamp in order for format() to work
3. time_leveled: for further time of day analysis, force times to the 1 day.

```r
mapDF <- mapDF %>% 
    mutate("date" = format(as.Date(timestamps),"%Y-%m-%d"),
           "time" = paste0(gsub(pattern = "T", replacement =" ",timestamps) %>%
                               gsub(pattern = "Z", replacement ="",timestamps) %>%
                               as.POSIXct() %>%
                               format("%H:%M:%S")),
           "time_leveled" = paste0("2099-12-31 ",
                                   gsub(pattern = "T", replacement =" ",timestamps) %>%
                                       gsub(pattern = "Z", replacement ="",timestamps) %>%
                                       as.POSIXct() %>%
                                       format("%H:%M"))
    )
```

(If you didn't work through the research questions, the above code will help you answer those questions.)

Great! We filled in the gaps and reformatted date/times. Now let's get ride of some uncessary vars.

- business_name
- latitude
- longitude
- timestamps

```r
mapDF <- mapDF %>% select(.,-business_name, -latitude, -longitude, -timestamps)
```

If you've already worked through this script and you are adding new data, here's where we filter dates. In this case, the last time I've worked through this dataset was on April 28, 2017. Therefore, we will filter the data for all entries after 2017-04-28. (Remember date is formated as yyyy-mm-dd)

```r
dateBreak <- "2017-04-28"
mapDF <- mapDF %>% filter(date > dateBreak)
```

Lastly, let's take a look at the reduced dataset.

```r 
str(mapDF)
sapply(mapDF, class)

Looks like we have some issues with variable classes. Let's eliminate factors and make sure numeric variables are numeric.

```r
mapDF$titles <- as.character(mapDF$titles)
mapDF$lat <- as.numeric(mapDF$lat)
mapDF$long <- as.numeric(mapDF$long)
mapDF$google_urls <- as.character(mapDF$google_urls)
```
 
Let's check once more.

```r 
sapply(mapDF, class)
```

Okay, all looks good. Let's save mapDF and move on to the next steps.

```r 
write.csv(mapDF, "data/new_mapdata.csv",row.names = F)
```

Let's also make a note of when you've worked on this date (i.e., filter date)

```r
write(
  paste0("updated: ",format(Sys.Date(),"%Y-%m-%d")),
  "data/cleaning_log.txt",
  append = T
)
```

---

## Post-cleaning

Here's where I'm breaking from reproducible research techniques. You don't have to do this part, but it's necessary if you want to analyze favorite places by category, country, etc. 

The end goal is to create an interactive map that can be shared with friends and family. I wanted to create a travel map where people can look and see what sites, points of interest and food that I recommend and where they are located. You can do this on google maps, but why not in R? Why not analyze your travel adventures?

Eventually, I'd like to implement techniques for removing personal and uncessary points (e.g., local grocery stores, healthcare locations, home address, banks, shops, work address, etc.) and reformatting business names, addresses, etc.. For now, I do this by hand. This is also a good time to confirm the data and make sure there aren't any text encoding issues (e.g., accent marks, language specific characters, etc.). 

Here's what we are going to do.

The current dataset (mapDF) should be x rows by 9 columns. We are going to add 5 columns  Starting after column 9, create several columns: 'city', 'country_name', 'region', 'category', 'icons'.

- city: name of the city where the business is located
- country_name: name of the country where the business is located
- region: the continent where the business is located 
- category: categorical listing of the business. Choices include - 
    - bar
    - beer
    - coffee
    - food
    - hotel
    - other
    - shop
    - site
    - transit
 - icons: assign a fontAwesome icon to the categorical listing (see below)
    - bar = glass
    - beer = beer
    - coffee = coffee
    - food = cutlery
    - hotel = bed
    - other = map-pin
    - shop = shopping-bag
    - site = map-marker
    - transit = car
#'             
#' Here's the formula for assigning FA icons:
#' 

```
=LOOKUP($M2,{"bar","beer","coffee","food","hotel","other","shop","site","transit"},{"glass","beer","coffee","cutlery","bed","map-pin","shopping-bag","map-marker","car"})
```

Copy and paste the above formula into the first cell in the 'icons' column, and then apply the formula to the entire column. (Note: make sure the input data is  the column titled 'category'; this should be column M). The following formula will do the same thing, but return "NA" if a match is not found, which can be useful for detecting typos

```
=IFERROR(LOOKUP($M2, {"bar","beer","coffee","food","hotel","other","shop","site","transit"},
{"glass","beer","coffee","cutlery","bed","map-pin","shopping-bag","map-marker","car"}),"NA")
```

To make life easier, I've compiled a list of country codes and names. This can help with the cleaning. Those can be found [here](https://github.com/davidruvolo51/data/blob/master/world-codes.csv).


## Merging Datasets

Great! So now you've probably cleaned the dataset and fixed some issues. Now, we will merge the master dataset with the new data. 

```r
options(stringsAsFactors = F)                                # no factors!
new_data <- read.csv("data/new_mapdata.csv")                 # read in new data
master_data <- read.csv("data/mapdata_master.csv")           # read in master
masterDF <- rbind(master_data, new_data )                    # combine data
``` 

 
I've a big fan of saving copies of data as places are added in the event of errors, missing files, rewrites, etc. So let's save this data.

```r
dir.create("data/archive")                           # only the first time
newDir <-paste0("data/archive/mapdata_prep_",        # set path of arch. dir with date
                format(Sys.Date(),"%Y%m%d"))  
dir.create(newDir)                                   # create archive dir
fileName <- paste0(newDir,"/", "new_mapdata.csv")    # create file name path
file.rename("data/new_mapdata.csv",fileName)         # move new data file
file.rename("data/mapdata_master.csv",               # move master
            paste0(newDir,"/","mapdata_master.csv"))
```

Cool. We've moved the data into an archived folder. Let's write the new data.

```
write.csv(masterDF, "data/mapdata_master.csv")
```
 
That's it! That's all the cleaning that needs to be done. Now let's get to the map making!

