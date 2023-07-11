raw_fields <- function(df) {
  cols <- colnames(df)
  props <- lapply(seq_along(cols), function(i) {
    infer_prop(cols[i], i, df)
  })
  return(props)
}

infer_prop <- function(col, i = NULL, df) {
  s <- df[[col]]
  semantic_type <- infer_semantic(s)
  analytic_type <- infer_analytic(s)
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