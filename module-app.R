# ui <- fluidPage(
#
#   selectInput("var", "Variable", names(mtcars)),
#
#   numericInput("bins", "bins", 10, min = 1),
#
#   plotOutput("hist")
# )
#
# server <- function(input, output, session) {
#
#   data <- reactive(mtcars[[input$var]])
#
#   output$hist <- renderPlot({
#     hist(data(), breaks = input$bins,
#          main = input$var)
#   }, res = 96)
# }
#
# shinyApp(ui = ui,
#          server = server)


histogramUI <- function(id) {
  tagList(

    # Variable input.
    selectInput(inputId = NS(namespace = id,
                             id = "var"),
                label = "Variable",
                choices = names(mtcars)),

    # Bins.
    numericInput(inputId = NS(namespace = id,
                              id = "bins"),
                 label = "bins",
                 value = 10,
                 min = 1),

    # Plot.
    plotOutput(outputId = NS(namespace = id,
                             id = "hist"))
  )
}


histogramServer <- function(id) {
    moduleServer(id = id,
               module = function(input, output, session) {

                 # Get data.
                 data <- reactive(mtcars[[input$var]])

                 # Render plot.
                 output$hist <- renderPlot({
                   hist(x = data(),
                        breaks = input$bins,
                        main = input$var)
                 }, res = 96)
               })
}


# histogramApp <- function() {
#   ui <- fluidPage(
#     histogramUI("hist1"),
#     histogramUI("hist2")
#   )
#   server <- function(input, output, session) {
#     histogramServer("hist1")
#     histogramServer("hist2")
#   }
#   shinyApp(ui, server)
# }

  ui <- fluidPage(
    histogramUI("hist1")
  )
  server <- function(input, output, session) {
    histogramServer("hist1")
  }
  shinyApp(ui, server)






