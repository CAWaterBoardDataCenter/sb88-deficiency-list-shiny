# Load libraries. ----

if(!("package:tidyr" %in% search())) {
  suppressMessages(library(tidyr))
}
if(!("package:dplyr" %in% search())) {
  suppressMessages(library(dplyr))
}
if(!("package:readr" %in% search())) {
  suppressMessages(library(readr))
}
if(!("package:readxl" %in% search())) {
  suppressMessages(library(readxl))
}
if(!("package:purrr" %in% search())) {
  suppressMessages(library(purrr))
}
if(!("package:stringr" %in% search())) {
  suppressMessages(library(stringr))
}
if(!("package:aws.s3" %in% search())) {
  suppressMessages(library(aws.s3))
}

# Save output?
save_output <- FALSE

# Set datafile source locations.
source("m-file-paths.R")

# Load S3 keys.
Sys.setenv("AWS_ACCESS_KEY_ID" = scan("swrcb-s3-keys.txt",
                                      what = "character",
                                      quiet = TRUE)[1],
           "AWS_SECRET_ACCESS_KEY" = scan("swrcb-s3-keys.txt",
                                          what = "character",
                                          quiet = TRUE)[2],
           "AWS_DEFAULT_REGION" = scan("swrcb-s3-keys.txt",
                                       what = "character",
                                       quiet = TRUE)[3])

# Minimum max. diversion size to include.
cutoff_div_size <- 10

# Water right types to include.
wr_types <- c("Appropriative",
              "Registration Cannabis",
              "Registration Domestic",
              "Registration Irrigation",
              "Registration Livestock",
              "Statement of Div and Use")


# Load SB88 Compliance Lookup file.
compliance_regex <- "(?=.*sb88-compliance-lookup-general).*RData"
compliance_file <- latestDatafile(f_path = fpath_output_sb88,
                                  f_regex = compliance_regex)
compliance_file_date <- as.Date(str_extract(string = compliance_file,
                                            pattern = "\\d{8}"),
                                format = "%Y%m%d")
load(latestDatafile(f_path = fpath_output_sb88,
                    f_regex = compliance_regex))

# Filter for target criteria.
deficiencies <- main_list %>%

  # Maximum diversion > 10 AFA.
  filter(max_diversion > cutoff_div_size) %>%

  # Water right types.
  filter(wr_type %in% wr_types) %>%

  # Filter for zero compliance or missing datafiles, not on exception list.
  filter(zero_compliance | missing_datafiles) %>%

  # Not on exception list.
  filter(!enf_exception)

# Generate deficiency list.
deficiency_list <- deficiencies %>%
  select(counties,
         owner,
         wr_id,
         # wr_type,
         # wr_status,
         zero_compliance,
         missing_datafiles) %>%
  mutate(zero_compliance = ifelse(zero_compliance, "X", NA),
         missing_datafiles = ifelse(missing_datafiles, "X", NA)) %>%
  arrange(counties, owner, wr_id)

# Rename columns.
names(deficiency_list) <- c("County",
                            "Owner Name",
                            "Water Right ID",
                            "Missing Device Report(s)",
                            "Missing Datafile(s)")

# Fix non-UTF-8 Characters, which throw errors to DT.
deficiency_list <- deficiency_list |>
  mutate(across(.cols = where(is.character),
                .fns = utf8::utf8_encode))

## Save data files locally and to S3 bucket. ----

# Save to S3 for Shiny app to pick up.

if(save_output) {
  outfile_loc <- paste0(fpath_output_sb88,
                        "/sb-88-deficiencies-",
                        format(Sys.Date(), "%Y%m%d"),
                        ".RData")
  save(deficiency_list,
       compliance_file_date,
       file = outfile_loc)
  put_object(file = outfile_loc,
             object = "sb-88-deficiencies.RData",
             bucket = "dwr-shiny-apps",
             multipart = TRUE)
}
