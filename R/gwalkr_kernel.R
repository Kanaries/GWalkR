utils::globalVariables(c(".rs.invokeShinyPaneViewer"))

convert_timestamps_in_df <- function(df) {
  for (colname in colnames(df)) {
    if (inherits(df[[colname]], "POSIXt")) {
      df[[colname]] <- as.numeric(as.POSIXct(df[[colname]], tz = "UTC")) * 1000
    }
  }
  return(df)
}

gwalkr_kernel <- function(data, lang, dark, rawFields, visConfig, toolbarExclude) {
  cat("GWalkR kernel mode initialized...\n")
  cat("Note: The console is unavailable while running a Shiny app. You can stop the app to use the console.\n")

  filter_func <- function(data, req) {
    query <- parseQueryString(req$QUERY_STRING)

    res <- duckdb_get_data(query$sql)
    res <- convert_timestamps_in_df(res)

    json <- toJSON(
      res,
      auto_unbox = TRUE
    )

    httpResponse(
      status = 200L,
      content_type = "application/json",
      content = json
    )
  }

  app_options <- if (exists(".rs.invokeShinyPaneViewer")) {
    c(launch.browser = .rs.invokeShinyPaneViewer)
  } else {
    list()
  }

  app <- shinyApp(
    ui = fluidPage(
      shinycssloaders::withSpinner(
        gwalkrOutput("gwalkr_kernel"),
        proxy.height="400px"
      )
    ),

    server = function(input, output, session) {
      path <- session$registerDataObj(
        "GWALKR",
        NULL,
        filter_func
      )

      duckdb_register_con(data)
      fieldMetas <- duckdb_get_field_meta()

      x = list(
        rawFields = rawFields,
        i18nLang = lang,
        visSpec = visConfig,
        dark = dark,
        toolbarExclude = toolbarExclude,
        useKernel = TRUE,
        fieldMetas = fieldMetas,
        endpointPath = path
      )

      output$gwalkr_kernel = renderGwalkr({
        htmlwidgets::createWidget(
          name = 'gwalkr',
          x,
          package = 'GWalkR',
          width = '100%',
          height = '100%'
        )
      })
      session$onSessionEnded(function() {
        cat("GwalkR closed")
        duckdb_unregister_con()
        stopApp()
      })
    },

    options = app_options
  )

  if (interactive()) app
}
