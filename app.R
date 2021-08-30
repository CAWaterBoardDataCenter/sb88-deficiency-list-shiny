# Initialization -------------------------------------------------------------

# Load libraries. ----
if (!("package:aws.s3" %in% search())) {
  suppressMessages(library(aws.s3))
}
if (!("package:shiny" %in% search())) {
  suppressMessages(library(shiny))
}
if (!("package:shinythemes" %in% search())) {
  suppressMessages(library(shinythemes))
}
if (!("package:shinyjs" %in% search())) {
  suppressMessages(library(shinyjs))
}
if (!("package:shinycssloaders" %in% search())) {
  suppressMessages(library(shinycssloaders))
}
if (!("package:htmltools" %in% search())) {
  suppressMessages(library(htmltools))
}
if (!("package:tidyr" %in% search())) {
  suppressMessages(library(tidyr))
}
if (!("package:dplyr" %in% search())) {
  suppressMessages(library(dplyr))
}
if (!("package:DT" %in% search())) {
  suppressMessages(library(DT))
}
