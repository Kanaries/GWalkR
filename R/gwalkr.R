#' Create GWalkR Interface in "Viewer"
#'
#' Use this function to create a GWalkR interface from a given data frame in your "Viewer" window, and start your data exploration! Please make sure the width and the height of your "Viewer" window are large enough.
#'
#' @import htmlwidgets
#' @import openssl
#'
#' @param data A data frame to be visualized in the GWalkR. The data frame should not be empty.
#' @param lang A character string specifying the language for the widget. Possible values are "en" (default), "ja", "zh".
#' @param dark A character string specifying the dark mode preference. Possible values are "light" (default), "dark", "media".
#' @param columnSpecs An optional list of lists to manually specify the types of some columns in the data frame. 
#' Each top level element in the list corresponds to a column, and the list assigned to each column should have 
#' two elements: `analyticalType` and `semanticType`. `analyticalType` can 
#' only be one of "measure" or "dimension". `semanticType` can only be one of 
#' "quantitative", "temporal", "nominal" or "ordinal". For example:
#' \code{list(
#'   "gender" = list(analyticalType = "dimension", semanticType = "nominal"),
#'   "age" = list(analyticalType = "measure", semanticType = "quantitative")
#' )}
#' @param visConfig An optional config string to reproduce your chart. You can copy the string by clicking "export config" button on the GWalkR interface.
#' @param visConfigFile An optional config file path to reproduce your chart. You can download the file by clicking "export config" button then "download" button on the GWalkR interface.
#'
#' @return An \code{htmlwidget} object that can be rendered in R environments
#'
#' @examples
#' data(mtcars)
#' gwalkr(mtcars)
#'
#' @export
gwalkr <- function(data, lang = "en", dark = "light", columnSpecs = list(), visConfig = NULL, visConfigFile = NULL) {
  if (!is.data.frame(data)) stop("data must be a data frame")
  if (!is.null(visConfig) && !is.null(visConfigFile)) stop("visConfig and visConfigFile are mutually exclusive")
  lang <- match.arg(lang, choices = c("en", "ja", "zh"))

  rawFields <- raw_fields(data, columnSpecs)
  colnames(data) <- sapply(colnames(data), fname_encode)
  
  if (!is.null(visConfigFile)) {
    visConfig <- readLines(visConfigFile, warn=FALSE)
  }
  # forward options using x
  x = list(
    dataSource = jsonlite::toJSON(data),
    rawFields = rawFields,
    i18nLang = lang,
    hideDataSourceConfig = TRUE,
    visSpec = visConfig,
    dark = dark
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'gwalkr',
    x,
    package = 'GWalkR',
    width='100%',
    height='100%'
  )
}

#' Shiny bindings for gwalkr
#'
#' Output and render functions for using gwalkr within Shiny
#' applications and interactive Rmd documents.
#' 
#' @import shiny
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a gwalkr
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name gwalkr-shiny
#'
#' @export
#' @examples # !formatR
#' library(GWalkR)
#' library(shiny)
#' data(mtcars)
#' app <- shinyApp(
#'   ui = fluidPage(
#'     titlePanel("Explore the data here: "),
#'     gwalkrOutput("mygraph")
#'   ),
#'   server = function(input, output, session) {
#'     output$mygraph = renderGwalkr(
#'       gwalkr(mtcars)
#'     )
#'   }
#' )
#' \donttest{if (interactive()) app}
#' @return \itemize{
#'   \item \code{gwalkrOutput}: A \code{shinyWidgetOutput} object for the root HTML element.
#'   \item \code{renderGwalkr}: A server-side function to help Shiny display the GWalkR visualization.
#' }
gwalkrOutput <- function(outputId, width = '100%', height = '100%'){
  htmlwidgets::shinyWidgetOutput(outputId, 'gwalkr', width, height, package = 'GWalkR')
}

#' @rdname gwalkr-shiny
#' @export
renderGwalkr <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, gwalkrOutput, env, quoted = TRUE)
}
