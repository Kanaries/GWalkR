raw_fields <- function(df, columnSpecs = list()) {
  validate_columnSpecs(columnSpecs)
  cols <- colnames(df)
  props <- lapply(seq_along(cols), function(i) {
    infer_prop(cols[i], i, df, columnSpecs)
  })
  return(props)
}

infer_prop <- function(col, i = NULL, df, columnSpecs = list()) {
  s <- df[[col]]
  semantic_type <- ifelse((col %in% names(columnSpecs)), columnSpecs[[col]]$semanticType, infer_semantic(s))
  analytic_type <- ifelse((col %in% names(columnSpecs)), columnSpecs[[col]]$analyticalType, infer_analytic(s))
  prop <- list(
    fid = col,
    name = col,
    semanticType = semantic_type,
    analyticType = analytic_type
  )
  return(prop)
}

infer_semantic <- function(s) {
  v_cnt <- length(unique(s))
  kind <- class(s)
  if (any(sapply(c('numeric', 'integer'), inherits, x = s)) & v_cnt > 16) {
    return('quantitative')
  } else if (any(sapply(c('POSIXct', 'POSIXlt', 'Date'), inherits, x = s))) {
    return('temporal')
  } else if (inherits(s, 'ordered')) {
    return('ordinal')
  } else {
    return('nominal')
  }
}

infer_analytic <- function(s) {
  v_cnt <- length(unique(s))
  kind <- class(s)
  if ((inherits(s, 'numeric')) | (inherits(s, 'integer') & v_cnt > 16)) {
    return('measure')
  } else {
    return('dimension')
  }
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