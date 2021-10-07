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
if (!("package:shinyjs" %in% search())) {
  suppressMessages(library(shinyjs))
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
if (!("package:readr" %in% search())) {
  suppressMessages(library(readr))
}
if (!("package:DT" %in% search())) {
  suppressMessages(library(DT))
}

## Load S3 keys. ----
source("load-s3-keys.R")

## Application Title. ----
app_title <- paste("Searchable SB-88 Measurement Regulation Deficiency List")

# UI ---------------------------------------------------------------------------

ui <- fluidPage( # Begin fluid page.
  useShinyjs(),

  # Set theme.
  theme = shinytheme("cerulean"),

  titlePanel(title = div(img(src = "DWR-ENF-Logo-2048.png", height = 60, width = 60), app_title),
             windowTitle = app_title),

  includeHTML(("./docs/intro-text.html")),
  br(),
  p(paste0("List last updated: ", gsub("(\\D)0", "\\1", format(compliance_file_date, "%B %d, %Y")), ".")),

  # Table.
  DTOutput(outputId = "deficiency_table"),

  # Download filtered data button.
  downloadButton(outputId = "download_filtered",
                 label = "Download Filtered Data")


) # End fluid page.


# SERVER -----------------------------------------------------------------------

server <- function(input, output, session) { # Begin server.

  ## Load data. ----
  s3load(object = "sb-88-deficiencies.RData",
         bucket = "dwr-shiny-apps")

  ## Buttons. ----

  # Download filtered data.
  output$download_filtered <-
    downloadHandler(
      filename = "Filtered Data.csv",
      content = function(file){
        write_csv(deficiency_list[input[["deficiency_table_rows_all"]], ],
                  file,
                  na = "")
      }
    )

  ## Tables. ----

  ## Demand data table.
  output$deficiency_table <- renderDT({

    deficiency_list

  },
  options = list(
    columnDefs = list(list(className = 'dt-center', targets = 3:4),
                      list(targets = c(3:4), searchable = FALSE)),
    lengthMenu = c(15, 30, 50),
    pageLength = 15
  ),
  filter = "top",
  rownames = FALSE)

} # End server.


# APP --------------------------------------------------------------------------

shinyApp(ui = ui,
         server = server)
