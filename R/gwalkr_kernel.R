gwalkr_kernel <- function(data, lang, dark, rawFields, visConfig, toolbarExclude) {
  cat("GWalkR kernel mode init...")

  filter_func <- function(data, req) {
    query <- parseQueryString(req$QUERY_STRING)

    res <- duckdb_get_data(query$sql)
    
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
          width='100%',
          height='100%'
        )
      })
      session$onSessionEnded(function() {
        cat("GwalkR closed")
        duckdb_unregister_con()
      })
    },

    options=c(launch.browser = .rs.invokeShinyPaneViewer)
  )

  if (interactive()) app
}