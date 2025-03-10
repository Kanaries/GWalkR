library(DBI)

my_env <- new.env()

duckdb_register_con <- function(df) {
  my_env$con <- dbConnect(duckdb::duckdb(), ":memory:")
  dbExecute(my_env$con, "INSTALL icu")
  dbExecute(my_env$con, "LOAD icu")
  dbExecute(my_env$con, "SET GLOBAL TimeZone = 'UTC'")
  DBI::dbWriteTable(my_env$con, "gwalkr_mid_table", as.data.frame(df), overwrite = FALSE)
}

duckdb_unregister_con <- function(df) {
  if (!is.null(my_env$con)) {
    dbDisconnect(my_env$con)
    my_env$con <- NULL  # Set to NULL after disconnecting
  }
}

duckdb_get_field_meta <- function() {
  if (exists("con", envir = my_env)) {
    result <- dbGetQuery(my_env$con, 'SELECT * FROM gwalkr_mid_table LIMIT 1')
    if (nrow(result) > 0) {
      return(get_data_meta_type(result))
    }
  } else {
    stop("Database connection not found.")
  }
}

duckdb_get_data <- function(sql) {
  if (exists("con", envir = my_env)) {
    result <- dbGetQuery(my_env$con, sql)
    if (nrow(result) > 0) {
      return(result)
    }
  } else {
    stop("Database connection not found.")
  }
}

get_data_meta_type <- function(data) {
  meta_types <- list()

  for (key in names(data)) {
    value <- data[[key]]
    field_meta_type <- if (inherits(value, "POSIXct")) {
      if (!is.null(attr(value, "tzone"))) "datetime_tz" else "datetime"
    } else if (is.numeric(value)) {
      "number"
    } else {
      "string"
    }
    meta_types <- append(meta_types, list(list(key = key, type = field_meta_type)))
  }

  return(meta_types)
}
