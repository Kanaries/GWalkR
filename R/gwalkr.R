#' Create GWalkR Interface in "Viewer"
#'
#' Use this function to create a GWalkR interface from a given data frame in your "Viewer" window, and start your data exploration! Please make sure the width and the height of your "Viewer" window are large enough.
#'
#' @import htmlwidgets
#'
#' @param data A data frame to be visualized in the GWalkR. The data frame should not be empty.
#' @param lang A character string specifying the language for the widget. Possible values are "en" (default), "ja", "zh".
#'
#' @examples
#' \dontrun{
#' data(mtcars)
#' gwalkr(mtcars)
#' }
#'
#' @export
gwalkr <- function(data, lang = "en") {
  if (!is.data.frame(data)) stop("data must be a data frame")
  lang <- match.arg(lang, choices = c("en", "ja", "zh"))

  # forward options using x
  x = list(
    dataSource = jsonlite::toJSON(data, pretty=TRUE),
    rawFields = raw_fields(data),
    i18nLang = lang
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'gwalkr',
    x,
    package = 'GWalkR'
  )
}

#' Shiny bindings for gwalkr
#'
#' Output and render functions for using gwalkr within Shiny
#' applications and interactive Rmd documents.
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
gwalkrOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'gwalkr', width, height, package = 'GWalkR')
}

#' @rdname gwalkr-shiny
#' @export
renderGwalkr <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, gwalkrOutput, env, quoted = TRUE)
}
