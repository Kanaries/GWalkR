library(shiny)
library(GWalkR)

data(mtcars)

ui <- fluidPage(
  titlePanel("Export GWalkR Configuration"),
  gwalkrOutput("gw", height = "600px"),
  actionButton("save", "Save Viz"),
  verbatimTextOutput("config")
)

server <- function(input, output, session) {
  output$gw <- renderGwalkr(gwalkr(mtcars))

  observeEvent(input$save, request_vis_config("gw"))

  output$config <- renderText({
    input$gw_visConfig
  })
}

shinyApp(ui, server)
