# script ships with nfl_workspc.R script
# get number of rows   
xlen <- NROW(football)
#===============================================================================
# football$HomeGames
for(i in 1:xlen){
    if(football$HomeGames[i] == "NA" | football$HomeGames[i] == "-"){
        football$HomeGames[i] <- "NA"
    } else{
        football$HomeGames[i] <- as.numeric(football$HomeGames[i])
    }
}
#===============================================================================
# football$Home_TOT
for(i in 1:xlen){
    if(football$Home_TOT[i] == "NA" | football$Home_TOT[i] == "-"){
        football$Home_TOT[i] <- "NA"
    } else{
        cell.sub <- gsub(",","",football$Home_TOT[i])
        football$Home_TOT[i] <- as.numeric(cell.sub)
    }
}
#===============================================================================
# football$Home_AVG
for(i in 1:xlen){
    if(football$Home_AVG[i] == "NA" | football$Home_AVG[i] == "-"){
        football$Home_AVG[i] <- "NA"
    } else{
        cell.sub <- gsub(",","",football$Home_AVG[i])
        football$Home_AVG[i] <- as.numeric(cell.sub)
    }
}
#===============================================================================
# football$Home_PCT
for(i in 1:xlen){
    if(football$Home_PCT[i] == "NA" | football$Home_PCT[i] == "-"){
        football$Home_PCT[i] <- "NA"
    } else{
        cell.sub <- gsub(",","",football$Home_PCT[i])
        football$Home_PCT[i] <- as.numeric(cell.sub)
    }
}
#===============================================================================
# football$RoadGames
for(i in 1:xlen){
    if(football$RoadGames[i] == "NA" | football$RoadGames[i] == "-"){
        football$RoadGames[i] <- "NA"
    } else{
        cell.sub <- gsub(",","",football$RoadGames[i])
        football$RoadGames[i] <- as.numeric(cell.sub)
    }
}
#===============================================================================
#football$Road_TOT 
for(i in 1:xlen){
    if(football$Road_TOT[i] == "NA" | football$Road_TOT[i] == "-"){
        football$Road_TOT[i] <- "NA"
    } else{
        cell.sub <- gsub(",","",football$Road_TOT[i])
        football$Road_TOT[i] <- as.numeric(cell.sub)
    }
}
#===============================================================================
#football$Road_AVG 
for(i in 1:xlen){
    if(football$Road_AVG[i] == "NA" | football$Road_AVG[i] == "-"){
        football$Road_AVG[i] <- "NA"
    } else{
        cell.sub <- gsub(",","",football$Road_AVG[i])
        football$Road_AVG[i] <- as.numeric(cell.sub)
    }
}
#===============================================================================
#football$ROAD_PCT 
for(i in 1:xlen){
    if(football$ROAD_PCT[i] == "-"| football$ROAD_PCT[i] == "NA"){
        football$ROAD_PCT[i] <- "NA"
    }
    else{
        cell.sub <- gsub(",","",football$Road_PCT[i])
        football$Road_PCT[i] <- as.numeric(cell.sub)
    }
}
#===============================================================================
#football$TOT_TOT 
for(i in 1:xlen){
    if(football$TOT_TOT[i] == "-"| football$TOT_TOT[i] == "NA"){
        football$TOT_TOT[i] <- "NA"
    }
    else{
        cell.sub <- gsub(",","",football$TOT_TOT[i])
        football$TOT_TOT[i] <- as.numeric(cell.sub)
    }
}
#===============================================================================
#football$TOT_AVG 
for(i in 1:xlen){
    if(football$TOT_AVG[i] == "NA" | football$TOT_AVG[i] == "-"){
        football$TOT_AVG[i] <- "NA"
    }
    else{
        cell.sub <- gsub(",","",football$TOT_AVG[i])
        football$TOT_AVG[i] <- as.numeric(cell.sub)
    }
}
#===============================================================================
#football$TOT_PCT 
for(i in 1:xlen){
    if(football$TOT_PCT[i] == "NA" | football$TOT_PCT[i] == "-"){
        football$TOT_PCT[i] <- "NA"
    } else{
        cell.sub <- gsub(",","",football$TOT_PCT[i])
        football$TOT_PCT[i] <- as.numeric(cell.sub)
    }
}
#===============================================================================
# recode variables and recharacterize dataset
football$Team <- suppressWarnings(sapply(football$Team, as.character,na.rm=F))
football$Rank <- suppressWarnings(sapply(football$Rank,as.numeric, na.rm=F))
football$HomeGames <- suppressWarnings(sapply(football$HomeGames,as.numeric,na.rm = F))
football$Home_TOT <- suppressWarnings(sapply(football$Home_TOT,as.numeric,na.rm = F))
football$Home_AVG <- suppressWarnings(sapply(football$Home_AVG,as.numeric,na.rm = F))
football$Home_PCT <- suppressWarnings(sapply(football$Home_PCT,as.numeric,na.rm = F))
football$RoadGames <- suppressWarnings(sapply(football$RoadGames,as.numeric,na.rm = F))
football$Road_TOT <- suppressWarnings(sapply(football$Road_TOT,as.numeric,na.rm = F))
football$Road_AVG <- suppressWarnings(sapply(football$Road_AVG,as.numeric,na.rm = F))
football$ROAD_PCT <- suppressWarnings(sapply(football$ROAD_PCT,as.numeric,na.rm = F))
football$TOT_Games <- suppressWarnings(sapply(football$TOT_Games,as.numeric,na.rm = F))
football$TOT_TOT <- suppressWarnings(sapply(football$TOT_TOT,as.numeric,na.rm = F))
football$TOT_AVG <- suppressWarnings(sapply(football$TOT_AVG,as.numeric,na.rm = F))
football$TOT_PCT <- suppressWarnings(sapply(football$TOT_PCT,as.numeric,na.rm = F))
