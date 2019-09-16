#' Diccionario de variables
#'
#' @param .data 
#' @param .var Variable de .data (columna) de clase labelled: debe tener dos atributos
#'
#' @return
#' @export
#'
#' @examples
#' dic(hog, dpto)
#' dic(hog, nomdpto)
#' dic(hog, c1)
dic <- function(.data, .var) {
  require(dplyr)
  require(magrittr)
  require(rlang)
  cat("\nColumn:", as.character(enquo(.var))[-1], "\n")
  v <- pull(.data, !! enquo(.var))
  cat("Label:", attr(v, "label"), "\n")
  
  if (!is.labelled(v)) {
    cat("\nNo labels available. Levels present:\n")
    v %>% unique %>% sort %>% cat(sep = "\n")
  } else {
    haven::print_labels(v)
  }
}

