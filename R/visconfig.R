#' Request the Visualization Configuration
#'
#' This function sends a message to the browser asking for the current visualization configuration
#' of a `gwalkr` widget. When used in a Shiny application, the configuration JSON
#' will be returned via `input[[paste0(id, '_visConfig')]]`.
#'
#' @param id The output id of the `gwalkr` widget.
#' @param session The shiny session object.
#'
#' @return No return value. The result will be available on the client side.
#'
#' @examples
#' # A simple Shiny app that prints the exported config
#' library(shiny)
#' library(GWalkR)
#' data(mtcars)
#'
#' ui <- fluidPage(
#'   gwalkrOutput("gw"),
#'   actionButton("save", "Save Viz"),
#'   verbatimTextOutput("config")
#' )
#'
#' server <- function(input, output, session) {
#'   output$gw <- renderGwalkr(gwalkr(mtcars))
#'
#'   observeEvent(input$save, request_vis_config("gw"))
#'
#'   output$config <- renderText({ input$gw_visConfig })
#' }
#'
#' if (interactive()) shinyApp(ui, server)
#'
#' @export
request_vis_config <- function(id, session = shiny::getDefaultReactiveDomain()) {
  if (is.null(session)) {
    stop('`request_vis_config` must be called from within a Shiny session')
  }
  session$sendCustomMessage('gwalkr_get_visconfig', list(id = id))
}

