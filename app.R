# Initialization -------------------------------------------------------------

## Load libraries. ----
if (!("package:aws.s3" %in% search())) {
  suppressMessages(library(aws.s3))
}
if (!("package:shiny" %in% search())) {
  suppressMessages(library(shiny))
}
if (!("package:shinythemes" %in% search())) {
  suppressMessages(library(shinythemes))
}
if (!("package:shinipsum" %in% search())) {
  suppressMessages(library(shinipsum))
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

## Load S3 keys. ----
source("load-s3-keys.R")

## Load Water Right Info. ----
s3load(object = "sb-88-deficiencies.RData",
       bucket = "dwr-shiny-apps")

# Rename columns.
names(deficiency_list) <- c("County",
                            "Owner Name",
                            "Water Right ID",
                            "Missing Device Report(s)",
                            "Missing Datafile(s)")

## Application Title. ----
app_title <- paste("Searchable SB-88 Measurement Regulation Deficiency List")

# UI ---------------------------------------------------------------------------

ui <- fluidPage( # Begin fluid page.
  useShinyjs(),

  # Set theme.
  theme = shinytheme("cerulean"),

  # Title bar.
  titlePanel(title = app_title),

  # Intro text.
  p("The Division maintains this searchable list of water rights and/or claims of right we believe are subject to the Senate Bill 88 Measurement Regulations but appear to have either made no attempt at complying or have indicated measuring devices have been installed but the required datafiles have not. The list is updated around the beginning of each month. Water Rights within the Legal Delta are not included in the the list."),
  p("If you believe your water right(s) or claim(s) of right were incorrectly identified as being subject to the measurement regulations, please email the Division at DWR-Measurement@waterboards.ca.gov."),
  br(),

  # Table.
  DTOutput(outputId = "deficiency_table")


) # End fluid page.


# SERVER -----------------------------------------------------------------------

server <- function(input, output, session) { # Begin server.

  ## Tables. ----

  ## Demand data table.
  output$deficiency_table <- renderDT({

    deficiency_list

  },
  options = list(
    columnDefs = list(list(className = 'dt-center', targets = 3:4)),
    lengthMenu = c(10, 20, 50),
    pageLength = 20
  ),
  filter = "top",
  rownames = FALSE)

} # End server.


# APP --------------------------------------------------------------------------

shinyApp(ui = ui,
         server = server)
