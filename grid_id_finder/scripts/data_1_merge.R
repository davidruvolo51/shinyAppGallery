#'//////////////////////////////////////////////////////////////////////////////
#' FILE: data_1_merge.R
#' AUTHOR: David Ruvolo
#' CREATED: 05 April 2018
#' MODIFIED: 14 May 2018
#' PURPOSE: merge grid ac datasets
#' PACKAGES: dplyr
#' STATUS: in.progress
#' COMMENTS: check website https://www.grid.ac/downloads for the latest releases
#' HISTORY:
#'         - 2018-05-14: using version 2018-05-01
#'          
#'//////////////////////////////////////////////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)

# pkgs
library(tidyverse)


#' Select Files to merge:
#'     - institutes.csv = list of institutes with id, wiki url, email, year est.
#'     - acronyms.csv = list of acronyms by institute id
#'     - addresses.csv = formal address by id with geodata
#'     - aliases.csv = alternative names
#'     - labels.csv = unicode formating
#'     - links.csv = university url
#'     - relationships.csv = grid ids and their matching pairs
#'     - types.csv = entry type (e.g., edu,gov,etc.)
#'////////////////////////////////////////

# ~ 0 ~

# load source data
grid_insts <- read.csv("data/full_tables/institutes.csv", stringsAsFactors = F)
grid_acros <- read.csv("data/full_tables/acronyms.csv", stringsAsFactors = F)
grid_addrs <- read.csv("data/full_tables/addresses.csv",stringsAsFactors = F)
grid_alias <- read.csv("data/full_tables/aliases.csv",stringsAsFactors = F)
grid_label <- read.csv("data/full_tables/labels.csv",stringsAsFactors = F)
grid_links <- read.csv("data/full_tables/links.csv", stringsAsFactors = F)
grid_rship <- read.csv("data/full_tables/relationships.csv",stringsAsFactors = F)
grid_types <- read.csv("data/full_tables/types.csv",stringsAsFactors = F)


# set primary dataset of which all data will be merged with
gridDF <- grid_insts

NROW(gridDF)                     # get length of data
length(unique(gridDF$grid_id))   # verify length = unique ids

#'////////////////////////////////////////

# ~ 1 ~
# Merge addresses with master dataset


# addresses check for sanity
NROW(grid_addrs)
length(unique(grid_addrs$grid_id))


# join
gridDF <- left_join(gridDF, grid_addrs)


# run check for sanity
NROW(gridDF)
length(unique(gridDF$grid_id))
head(gridDF)


#'////////////////////////////////////////

# ~ 2 ~
# Merge acronyms with master dataset


# run check for sanity: acronyms df
NROW(grid_acros)
length(unique(grid_acros$grid_id))


# there are multiple entries for 1292 cases
# meaning that some institutions have more than
# one acronym - trim data to unique values only and
# merge additional names into one cell

grid_acros$flag <- duplicated(grid_acros$grid_id)
grid_acros_unq <- subset(grid_acros, flag == FALSE)
grid_acros_dups <- subset(grid_acros, flag == TRUE)



# append duplicate variables to the dataset
for(i in 1:NROW(grid_acros_unq)){
  
  id=grid_acros_unq$grid_id[i] 
  
  if( id %in% grid_acros_dups$grid_id){
    
    unq_vals = grid_acros_unq$acronym[i]
    dup_vals = paste(grid_acros_dups$acronym[grid_acros_dups$grid_id==id],collapse = ", ")
    grid_acros_unq$acro_paste[i] <- paste(unq_vals, dup_vals, sep = ", ")
    
    
  } else if( !(id %in% grid_acros_dups$grid_id)) {
    grid_acros_unq$acro_paste[i] <- grid_acros_unq$acronym[i]
  } else {
    warning("ERROR: match not found")
  }
  
}


# run check for sanity
NROW(grid_acros_unq[(stringr::str_detect(grid_acros_unq$acro_paste,"\\,")),])

grid_acros_unq <- grid_acros_unq %>% select(grid_id, acro_paste)
colnames(grid_acros_dups) <- c("grid_id","acronym")

# looks like it worked, let's merge acronyms with the main dataset
gridDF <- left_join(gridDF, grid_acros_unq)

# run check for sanity
NROW(gridDF)
length(unique(gridDF$grid_id))


#'////////////////////////////////////////

# ~ 3 ~
# Merge aliases

# run check for sanity: aliases data
head(grid_alias)
NROW(grid_alias)
length(unique(grid_alias$grid_id)) 
grid_alias <- grid_alias[order(grid_alias$alias),]


# check for duplicates
grid_alias$flag <- duplicated(grid_alias$grid_id)


# summarize duplicate cases
grid_alias %>% 
  group_by(flag) %>%
  count()  # 276 flagged cases


# separate distinct values from repeated cases
grid_alias_uniq <- subset(grid_alias,flag==FALSE)
grid_alias_dups <- subset(grid_alias,flag==TRUE)

NROW(grid_alias_uniq)
NROW(grid_alias_dups)

length(unique(grid_alias_uniq$grid_id))
length(unique(grid_alias_dups$grid_id))

# run loop to merge duplicates for uniques
# we want to concatenate the values into one position
for(i in 1:NROW(grid_alias_uniq)){
  
  query = grid_alias_uniq$grid_id[i]
  
  if(query %in% grid_alias_dups$grid_id){

    unq_vals = grid_alias_uniq$alias[i]
    dup_vals = paste(grid_alias_dups$alias[grid_alias_dups$grid_id == query],collapse = ", ")
    grid_alias_uniq$alias_paste[i] <- paste(unq_vals, dup_vals, sep = ", ")
    
  } else if( !(query %in% grid_alias_dups$grid_id)){
    
    grid_alias_uniq$alias_paste[i] <- grid_alias_uniq$alias[i]
    
  } else {
    warning("ERROR: match not found. This should never ever happen.")
  }
  
  
}

# run check for sanity
# (grid_alias_uniq[(stringr::str_detect(grid_alias_uniq$alias_paste,"\\,")),])
NROW(grid_alias_uniq)
length(unique(grid_alias_uniq$grid_id))

grid_alias_uniq <- grid_alias_uniq %>% select(grid_id,alias_paste)
colnames(grid_alias_uniq) <- c("grid_id", "alias")

# looks good! Let's merge
gridDF <- left_join(gridDF, grid_alias_uniq)

# run check for sanity
NROW(gridDF)

#'////////////////////////////////////////

# ~ 4 ~
# Merge labels

# run check for sanity
head(grid_label)
NROW(grid_label)
length(unique(grid_label$grid_id))

# isolate duplicates and unique values
grid_label$flag <- duplicated(grid_label$grid_id)

grid_label %>%
  group_by(flag) %>%
  count()

grid_label_uniq <- subset(grid_label, flag == FALSE)
grid_label_dups <- subset(grid_label, flag == TRUE)

NROW(grid_label_uniq)
NROW(grid_label_dups)

length(unique(grid_label_uniq$grid_id))
length(unique(grid_label_dups$grid_id))


for( i in 1:NROW(grid_label_uniq) ){
  
  
  id = grid_label_uniq$grid_id[1]
  
  if( id %in% grid_label_dups$grid_id ){
    
    unq_vals = grid_label_uniq$label[i]
    dup_vals = paste(
      grid_label_dups$label[grid_label_dups$grid_id == id],
      collapse = ", "
    )
    
    grid_label_uniq$label_paste[i] <- paste(unq_vals,dup_vals,sep = ", ")
    
  } else if( !( id %in% grid_label_dups$grid_id) ){
    
    grid_label_uniq$label_paste[i] <- grid_label_uniq$label[i]
    
  }
  
  
}


# run check for sanity
head(grid_label_uniq)
NROW(grid_label_uniq)
length(unique(grid_label_uniq$grid_id))


# select columns and rename
grid_label_uniq <- grid_label_uniq %>% select(grid_id, iso639, label_paste)
colnames(grid_label_uniq) <- c("grid_id","iso639", "label")
head(grid_label_uniq)


# merge with master
gridDF <- left_join(gridDF, grid_label_uniq)


# run check for sanity
NROW(gridDF)
length(unique(gridDF$grid_id))


#'////////////////////////////////////////

# ~ 5 ~
# Merge Links
head(grid_links)
NROW(grid_links)
length(unique(grid_links$grid_id))

grid_links$flag <- duplicated(grid_links$grid_id)

grid_links %>% 
  group_by(flag) %>%
  count()

# there are three cases!! ugh, I will likely manually recode the links rather
# than subsetting and writting a loop and then merging them back together

# let's view the two cases
grid_links[grid_links$flag == T,]

# get ids
dup_ids <- grid_links$grid_id[grid_links$flag == T]

# run id to determine if the entries are true duplicates
grid_links[grid_links$grid_id==dup_ids[1],] # links are the same (remove)
grid_links[grid_links$grid_id==dup_ids[2],] # links are the same (remove)
grid_links[grid_links$grid_id==dup_ids[3],] # links are diff, but one is IP (remove)

# after running the ids, it is clear that the ids are duplicated and there are 
# no differences in the urls. In this situation we can remove these two cases.
# since we've already created a flag, we can subset the data to keep only FALSE
# cases. This will remove the two cases. The current total number of false cases
# is 68182. This total won't change. What will change is the number of rows. The
# number of rows is 68184. After removing the two cases this total should be 68182.

grid_links_uniq <- subset(grid_links, flag ==FALSE)
NROW(grid_links_uniq)  # the totals match

head(grid_links_uniq)
grid_links_uniq$flag <- NULL

# Merge with the master df
gridDF <- left_join(gridDF, grid_links_uniq)

# run check for sanity
NROW(gridDF)
length(unique(gridDF$grid_id))



#'////////////////////////////////////////

# ~ 7 ~
# Merge Types

head(grid_types)
NROW(grid_types)
length(unique(grid_types$grid_id))
NROW(grid_types) - length(unique(grid_types$grid_id))

# there are 9 cases of duplicated types
grid_types$flag <- duplicated(grid_types$grid_id)

grid_types %>%
  group_by(flag) %>%
  count()

# view
grid_types[grid_types$flag == T,]

# subset by duplicated status
grid_types_uniq <- subset(grid_types, flag == FALSE)
grid_types_dups <- subset(grid_types, flag == TRUE)

NROW(grid_types_uniq)
NROW(grid_types_dups)

dupIDS = grid_types_dups$grid_id

# run loop to bring all the variables across

for( i in 1:NROW(grid_types_uniq) ){
 
  id = grid_types_uniq$grid_id[i]
  unq_vals = grid_types_uniq$type[i]  
  
  if( id %in% grid_types_dups$grid_id ){
    
    dup_vals = paste(grid_types_dups$type[grid_types_dups$grid_id == id],collapse=", ")
    grid_types_uniq$type_paste[i] <- paste(unq_vals,dup_vals, sep = ", ")
    
  } else if ( !( id %in% grid_types_dups$grid_id) ){
    
    grid_types_uniq$type_paste[i] <- unq_vals
    
  } else {
    warning("ERROR: Something went terrible wrong. This should never happen")
  }
   
}

# run check for sanity
head(grid_types_uniq)
tail(grid_types_uniq)
NROW(grid_types_uniq)

grid_types_uniq[grid_types_uniq$grid_id == dupIDS[1],]

grid_types_uniq <- grid_types_uniq %>% select(grid_id, type_paste)
colnames(grid_types_uniq) <- c("grid_id","type")
head(grid_types_uniq)

# great, now we are in business! Let's merge with the master dataset and then we
# are ready to merge with the collaborations dataset

NROW(gridDF)
gridDF <- left_join(gridDF, grid_types_uniq)

head(gridDF)

#'////////////////////////////////////////////////////////////////////////////////

# ~ 8 ~
# Let's check a few things over before we save the data

# ~ a ~
# rename a missed name change earlier on in the script

names(gridDF)[names(gridDF) == "acro_paste"] <- "acronym" # recode 1 column name


# ~ b ~
# summarize line_1:3 variables

summary(gridDF$line_1)
length(unique(gridDF$line_1))    # number of unique entries
length(unique(gridDF$line_2))    # number of unique entries
length(unique(gridDF$line_3))    # number of unique entries

unique(gridDF$line_1)    # inspect
unique(gridDF$line_2)    # inspect
unique(gridDF$line_3)    # inspect

gridDF$line_1 <- NULL    # remove
gridDF$line_2 <- NULL    # remove
gridDF$line_3 <- NULL    # remove

head(gridDF)    # inspec


# ~ c ~
# let's check out the email address variable

unique(gridDF$email_address)                # get unique entries
length(unique(gridDF$email_address))        # get number of unique entries
NROW(gridDF[gridDF$email_address =="",])    # get number of missing values

gridDF$email_address <- NULL    # remove

head(gridDF)    # inspect


# ~ d ~
# examine the postcode primary variable

unique(gridDF$postcode)                # get unique entries
length(unique(gridDF$postcode))        # get number of unique entries
NROW(gridDF[gridDF$postcode == "",])   # get number of missing values

gridDF$postcode <- NULL   # remove it!

head(gridDF)    # inspect


# ~ e ~
# examine the primary variable

unique(gridDF$primary)
NROW(gridDF[gridDF$primary == "false",])
NROW(gridDF[gridDF$primary =="",])

# remove it
gridDF$primary <- NULL
head(gridDF)

NROW(gridDF)

#'////////////////////////////////////////////////////////////////////////////////

# ~ 9 ~
# Sanitize a few variables

gridDF$name <- tolower(gridDF$name)                   # institution name
gridDF$city <- tolower(gridDF$city)                   # institution city
gridDF$state <- tolower(gridDF$state)                 # institution state
gridDF$state_code <- tolower(gridDF$state_code)       # institution state code
gridDF$country <- tolower(gridDF$country)             # institution country name
gridDF$country_code <- tolower(gridDF$country_code)   # institution country code
gridDF$acronym <- tolower(gridDF$acronym)             # institution acronym
gridDF$alias <- tolower(gridDF$alias)                 # institution alias(es)
gridDF$type <- tolower(gridDF$type)                   # institution type


# save data
saveRDS(gridDF, "data/grid_merged.RDS")
# file.copy(from="grid_merged.RDS","C:/Users/druv5154/Documents/rstudio/projects/collaboration/data/")







