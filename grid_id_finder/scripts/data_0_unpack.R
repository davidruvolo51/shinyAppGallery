#'//////////////////////////////////////////////////////////////////////////////
#' FILE: data_0_unpack.R
#' AUTHOR: David Ruvolo
#' CREATED: 14 May 2018
#' MODIFIED: 14 May 2018
#' PURPOSE: unpack and move data files
#' PACKAGES: NA
#' STATUS: in.progress
#' COMMENTS: 
#'//////////////////////////////////////////////////////////////////////////////
#' GLOBAL OPTIONS:
options(stringsAsFactors = FALSE)


# ~ 0 ~

# go to: https://www.grid.ac/downloads and download the latest release. Save file
# to you local downloads directory. Update with your university username, and then
# run

# parameters -- set grid release date, e.g., 20180501
release = ""

#'////////////////////////////////////////

# ~ 1 ~

# move from  ~/Downloads/ to  ./data/releases
file.rename(
  from = paste0(path.expand("~/Downloads"),"/grid",release,".zip"),
  to = paste0("data/grid", release, ".zip")
)

#'////////////////////////////////////////

# ~ 2 ~

# unzip file - extract files into data/
unzip(
  zipfile = paste0("data/grid", release, ".zip"),
  exdir = "/data"
)

