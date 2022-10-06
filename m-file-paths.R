## m-file-paths.R
##
## Version 1.3
## 2022-04-25


# Load libraries. ----
library(tidyr)
library(dplyr)
library(purrr)

## Set datafile locations.

# Set path to home data folder.
if(Sys.info()[1] == "Windows") {

  # Set data path to H: on Network
  fpath_home <- ("C:/Users/jyeazell/OneDrive - Water Boards/data/")
} else {

  # Set data path to work drive on home Mac.
  fpath_home <- "/Users/jyeazell/R/work/data/"
}

if(!dir.exists(fpath_home)) dir.create(fpath_home)

dir_list <- c(
  "sb88",
  "sb88/specials",
  "sb88/device-reports",
  "sb88/datafile-submittals",
  "ewrims-flat-files",
  "ewrims-misc",
  "diversions",
  "legal-delta",
  "gis",
  "project",
  "drought_2021",
  "drought_2021/output",
  "output",
  "output/sb88",
  "complaints",
  "complaints/salesforce",
  "complaints/open-complaint-list",
  "complaints/open-complaint-list/old"
)

# Make datafile directories if they don't exist.
old_dir <- getwd()
setwd(fpath_home)

purrr::walk(.x = dir_list,
            .f = dir.create, showWarnings = FALSE)

setwd(old_dir)
rm(old_dir)

# Set datafile subfolder locations.
fpath_sb88_data <- paste0(fpath_home, "sb88")
fpath_sb88_specials <- paste0(fpath_home, "sb88/specials")
fpath_dev_rept <- paste0(fpath_home, "sb88/device-reports")
fpath_eff <- paste0(fpath_home, "ewrims-flat-files")
fpath_ewrims <- paste0(fpath_home, "ewrims-misc")
fpath_diversions <- paste0(fpath_home, "diversions")
fpath_delta_rights <- paste0(fpath_home, "legal-delta")
fpath_datafiles <- paste0(fpath_home, "sb88/datafile-submittals")
fpath_gis <- paste0(fpath_home, "gis")
fpath_projects <- paste0(fpath_home, "projects")
fpath_drought_output <- paste0(fpath_home, "drought_2021/output")
fpath_drought_2021 <- paste0(fpath_home, "drought_2021")
fpath_output_sb88 <- paste0(fpath_home, "output/sb88")
fpath_complaints <- paste0(fpath_home, "complaints")

# latest file function.
latestDatafile <- function(f_path,f_regex) {
  file.info(list.files(f_path, full.names = T)) %>%
    filter(grepl(f_regex, rownames(.), perl = TRUE)) %>%
    filter(mtime == max(mtime)) %>%
    rownames()
}

# Scrape file date from file name.
scrapeDate <- function(x) {
  y <- as.Date(str_extract(x,
                           pattern = "\\d{8}"),
               format = "%Y%m%d")
  return(y)
}
