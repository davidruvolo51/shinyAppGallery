# packages
require(rvest,quietly = T)
# dim vars
year.df = data.frame("years"=c(2001, 2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015))

# loop through years and build urls
for(i in 1:NROW(year.df)){
    year.df$url[i] <- paste0("http://espn.go.com/nfl/attendance/_/year/",year.df$years[i])
} 

# build tables
year_2001 <- data.frame(read_html(year.df$url[1]) %>% html_nodes("table") %>% html_table())
year_2002 <- data.frame(read_html(year.df$url[2]) %>% html_nodes("table") %>% html_table())
year_2003 <- data.frame(read_html(year.df$url[3]) %>% html_nodes("table") %>% html_table())
year_2004 <- data.frame(read_html(year.df$url[4]) %>% html_nodes("table") %>% html_table())
year_2005 <- data.frame(read_html(year.df$url[5]) %>% html_nodes("table") %>% html_table())
year_2006 <- data.frame(read_html(year.df$url[6]) %>% html_nodes("table") %>% html_table())
year_2007 <- data.frame(read_html(year.df$url[7]) %>% html_nodes("table") %>% html_table())
year_2008 <- data.frame(read_html(year.df$url[8]) %>% html_nodes("table") %>% html_table())
year_2009 <- data.frame(read_html(year.df$url[9]) %>% html_nodes("table") %>% html_table())
year_2010 <- data.frame(read_html(year.df$url[10]) %>% html_nodes("table") %>% html_table())
year_2011 <- data.frame(read_html(year.df$url[11]) %>% html_nodes("table") %>% html_table())
year_2012 <- data.frame(read_html(year.df$url[12]) %>% html_nodes("table") %>% html_table())
year_2013 <- data.frame(read_html(year.df$url[13]) %>% html_nodes("table") %>% html_table())
year_2014 <- data.frame(read_html(year.df$url[14]) %>% html_nodes("table") %>% html_table())
year_2015 <- data.frame(read_html(year.df$url[15]) %>% html_nodes("table") %>% html_table())

# get new header
new.var.names <- c("Rank","Team","HomeGames","Home_TOT","Home_AVG","Home_PCT", #home
                   "RoadGames","Road_TOT","Road_AVG","ROAD_PCT", # away
                   "TOT_Games","TOT_TOT","TOT_AVG","TOT_PCT") # overall

# assign new colnames
colnames(year_2001) <- new.var.names
colnames(year_2002) <- new.var.names
colnames(year_2003) <- new.var.names
colnames(year_2004) <- new.var.names
colnames(year_2005) <- new.var.names
colnames(year_2006) <- new.var.names
colnames(year_2007) <- new.var.names
colnames(year_2008) <- new.var.names
colnames(year_2009) <- new.var.names
colnames(year_2010) <- new.var.names
colnames(year_2011) <- new.var.names
colnames(year_2012) <- new.var.names
colnames(year_2013) <- new.var.names
colnames(year_2014) <- new.var.names
colnames(year_2015) <- new.var.names

# remove top two rows
year_2001 <- year_2001[-c(1,2),]
year_2002 <- year_2002[-c(1,2),]
year_2003 <- year_2003[-c(1,2),]
year_2004 <- year_2003[-c(1,2),]
year_2005 <- year_2005[-c(1,2),]
year_2006 <- year_2006[-c(1,2),]
year_2007 <- year_2007[-c(1,2),]
year_2008 <- year_2008[-c(1,2),]
year_2009 <- year_2009[-c(1,2),]
year_2010 <- year_2010[-c(1,2),]
year_2011 <- year_2011[-c(1,2),]
year_2012 <- year_2012[-c(1,2),]
year_2013 <- year_2013[-c(1,2),]
year_2014 <- year_2014[-c(1,2),]
year_2015 <- year_2015[-c(1,2),]

# create year variable
year_2001$year <- 2001
year_2002$year <- 2002
year_2003$year <- 2003
year_2004$year <- 2004
year_2005$year <- 2005
year_2006$year <- 2006
year_2007$year <- 2007
year_2008$year <- 2008
year_2009$year <- 2009
year_2010$year <- 2010
year_2011$year <- 2011
year_2012$year <- 2012
year_2013$year <- 2013
year_2014$year <- 2014
year_2015$year <- 2015

# rbind dfs
football <- rbind(year_2001,
                  year_2002,
                  year_2003,
                  year_2004,
                  year_2005,
                  year_2006,
                  year_2007,
                  year_2008,
                  year_2009,
                  year_2010,
                  year_2011,
                  year_2012,
                  year_2013,
                  year_2014,
                  year_2015)

# sort by team and year
football <- football[order(football$Team,football$year),]
# recode and recharacterize dataset
source("~/FootballAttendanceRecords/getData/nfl_recode_toSHIP.R")

# calculate means
library(psych,quietly = T)
# HomeGames
HomeGames <- describeBy(football$HomeGames,football$year,mat=T,skew = F,ranges=F,digits=2)
HomeGames <- subset(HomeGames,select =c(mean))
colnames(HomeGames) <- c("HomeGames")

# Home_TOT 
Home_TOT <- describeBy(football$Home_TOT,football$year,mat=T,skew=F,ranges=F,digits=2)
Home_TOT <- subset(Home_TOT,select = c(mean))
colnames(Home_TOT) <- c("Home_TOT")

#Home_AVG 
Home_AVG <- describeBy(football$Home_AVG,football$year,mat=T,skew=F,ranges=F,digits=2)
Home_AVG <- subset(Home_AVG,select = c(mean))
colnames(Home_AVG) <- c("Home_AVG")

#Home_PCT 
Home_PCT <- describeBy(football$Home_PCT,football$year,mat=T,skew=F,ranges=F,digits=2)
Home_PCT <- subset(Home_PCT,select = c(mean))
colnames(Home_PCT) <- c("Home_PCT")

#RoadGames
RoadGames <- describeBy(football$RoadGames,football$year,mat=T,skew=F,ranges=F,digits=2)
RoadGames <- subset(RoadGames,select = c(mean))
colnames(RoadGames) <- c("RoadGames")

#Road_TOT 
Road_TOT <- describeBy(football$Road_TOT,football$year,mat=T,skew=F,ranges=F,digits=2)
Road_TOT <- subset(Road_TOT,select = c(mean))
colnames(Road_TOT) <- c("Road_TOT")

#Road_AVG 
Road_AVG <- describeBy(football$Road_AVG,football$year,mat=T,skew=F,ranges=F,digits=2)
Road_AVG <- subset(Road_AVG,select = c(mean))
colnames(Road_AVG) <- c("Road_AVG")

#ROAD_PCT 
ROAD_PCT <- describeBy(football$ROAD_PCT,football$year,mat=T,skew=F,ranges=F,digits=2)
ROAD_PCT <- subset(ROAD_PCT,select = c(mean))
colnames(ROAD_PCT) <- c("ROAD_PCT")

#TOT_Games
TOT_Games <- describeBy(football$TOT_Games,football$year,mat=T,skew=F,ranges=F,digits=2)
TOT_Games <- subset(TOT_Games,select = c(mean))
colnames(TOT_Games) <- c("TOT_Games")

#TOT_TOT 
TOT_TOT <- describeBy(football$TOT_TOT,football$year,mat=T,skew=F,ranges=F,digits=2)
TOT_TOT <- subset(TOT_TOT,select = c(mean))
colnames(TOT_TOT) <- c("TOT_TOT")

#TOT_AVG
TOT_AVG <- describeBy(football$TOT_AVG,football$year,mat=T,skew=F,ranges=F,digits=2)
TOT_AVG <- subset(TOT_AVG,select = c(mean))
colnames(TOT_AVG) <- c("TOT_AVG")

#TOT_PCT
TOT_PCT <- describeBy(football$TOT_PCT,football$year,mat=T,skew=F,ranges=F,digits=2)
TOT_PCT <- subset(TOT_PCT,select = c(mean))
colnames(TOT_PCT) <- c("TOT_PCT")

# make year
year <- data.frame("year"=c(2001:max(football$year)))
Rank <- data.frame("Rank" = as.character(rep("Total",length(unique(football$year)))))
Team <- data.frame("Team" = as.character(rep("Total",length(unique(football$year)))))

# cbind means dataframe
means <- suppressWarnings(cbind(Rank,Team,HomeGames,Home_TOT,Home_AVG,Home_PCT,RoadGames,Road_TOT,Road_AVG,ROAD_PCT,TOT_Games,TOT_TOT,TOT_AVG,TOT_PCT,year))

# change to character once again
means$Rank <- sapply(means$Rank,as.character,na.rm=F)
means$Team <- sapply(means$Team,as.character,na.rm=F)

# recode "NaN"
means[means=="NaN"] <- NA

#rbind means with master df
football <- rbind(football,means)
football <- subset(football, select = c(1,2,15,3:14)) # reorder columns: move year two 3rd position
football <- subset(football, year >= 2009)

#write dataset
write.csv(football,"football_2008-2015.csv")