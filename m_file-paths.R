## Set datafile locations.

# Set path to home data folder.
fpath_home <- "/Volumes/work-stuff/data"

# Datafile subfolder locations.
fpath_sb88_data <- paste0(fpath_home, "/sb88")
fpath_sb88_specials <- paste0(fpath_home, "/sb88/specials")
fpath_dev_rept <- paste0(fpath_home, "/sb88/device-reports")
fpath_eff <- paste0(fpath_home, "/ewrims-flat-files")
fpath_ewrims <- paste0(fpath_home, "/ewrims-misc")
fpath_diversions <- paste0(fpath_home, "/diversions")
fpath_delta_rights <- paste0(fpath_home, "/legal-delta")
fpath_datafiles <- paste0(fpath_home, "/sb88/datafile-submittals")
fpath_gis <- paste0(fpath_home, "/gis")
fpath_projects <- paste0(fpath_home, "/projects")
fpath_drought_output <- paste0(fpath_home, "/drought_2021/output")
fpath_drought_2021 <- paste0(fpath_home, "/drought_2021")
fpath_output_sb88 <- paste0(fpath_home, "/output/sb88")

# latest file function.
latestDatafile <- function(f_path,f_regex) {
  file.info(list.files(f_path, full.names = T)) %>% 
    filter(grepl(f_regex, rownames(.), perl = TRUE)) %>% 
    filter(mtime == max(mtime)) %>% 
    rownames()
}
