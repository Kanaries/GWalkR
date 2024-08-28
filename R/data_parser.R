library(openssl)

raw_fields <- function(df, columnSpecs = list()) {
  validate_columnSpecs(columnSpecs)
  cols <- colnames(df)
  if (nrow(df) > 1000) {
    df_sample <- df[sample(nrow(df),1000),]
  } else {
    df_sample <- df
  }
  props <- lapply(seq_along(cols), function(i) {
    infer_prop(cols[i], i, df_sample, columnSpecs)
  })
  return(props)
}

infer_prop <- function(col, i = NULL, df, columnSpecs = list()) {
  s <- df[[col]]
  semantic_type <- ifelse((col %in% names(columnSpecs)), columnSpecs[[col]]$semanticType, infer_semantic(s, col))
  analytic_type <- ifelse((col %in% names(columnSpecs)), columnSpecs[[col]]$analyticalType, infer_analytic(s, col))
  prop <- list(
    fid = fname_encode(col),
    name = col,
    semanticType = semantic_type,
    analyticType = analytic_type
  )
  return(prop)
}

is_geo_field <- function(field_name) {
  field_name <- tolower(trimws(field_name, which = "both", whitespace = " ."))
  return(field_name %in% c("latitude", "longitude", "lat", "long", "lon"))
}

infer_semantic <- function(s, field_name) {
  v_cnt <- length(unique(s))
  kind <- class(s)
  if (all(kind %in% c("numeric", "integer", "double", "complex")) || is_geo_field(field_name)) {
    return('quantitative')
  } else if (any(sapply(c('POSIXct', 'POSIXlt', 'POSIXt', 'Date'), inherits, x = s))) {
    return('temporal')
  } else {
    return('nominal')
  }
}

infer_analytic <- function(s, field_name) {
  v_cnt <- length(unique(s))
  kind <- class(s)
  if (is_geo_field(field_name)) {
    return("dimension")
  }
  if (all(kind %in% c("numeric", "integer", "double", "complex"))) {
    return("measure")
  }
  return("dimension")
}

validate_columnSpecs <- function(columnSpecs) {
  acceptable_analyticalTypes <- c("measure", "dimension")
  acceptable_semanticTypes <- c("quantitative", "temporal", "nominal", "ordinal")
  
  # Check that columnSpecs is a list
  if (!is.list(columnSpecs)) {
    stop("columnSpecs should be a list.")
  }
  
  for (column in names(columnSpecs)) {
    # Check that the column specification is a list
    if (!is.list(columnSpecs[[column]])) {
      stop(paste0("The specification for '", column, "' should be a list."))
    }
    
    # Check that the analyticalType and semanticType are specified
    if (!"analyticalType" %in% names(columnSpecs[[column]]) ||
        !"semanticType" %in% names(columnSpecs[[column]])) {
      stop(paste0("Both 'analyticalType' and 'semanticType' should be specified for '", column, "'."))
    }
    
    # Check that the analyticalType and semanticType have acceptable values
    if (!(columnSpecs[[column]]$analyticalType %in% acceptable_analyticalTypes)) {
      stop(paste0("The 'analyticalType' for '", column, "' is invalid. It should be either 'measure' or 'dimension'."))
    }
    
    if (!(columnSpecs[[column]]$semanticType %in% acceptable_semanticTypes)) {
      stop(paste0("The 'semanticType' for '", column, "' is invalid. It should be one of 'quantitative', 'temporal', 'nominal', or 'ordinal'."))
    }
  }
}

fname_encode <- function(fname) {
  # Convert fname to base64
  return(base64_encode(charToRaw(as.character(fname))))
}

fname_decode <- function(fname) {
  # Convert base64 back to string
  decoded <- rawToChar(base64_decode(fname))
  if (grepl("_", decoded)) {
    return(unlist(strsplit(decoded, "_"))[1])
  } else {
    return(decoded)
  }
}