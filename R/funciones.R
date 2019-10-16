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
  require(haven)
  cat("\nColumn:", as.character(enquo(.var))[-1], "\n")
  v <- pull(.data, !!enquo(.var))
  cat("Label:", attr(v, "label"), "\n")
  cat("Class:", class(v), "\n")

  if (!is.labelled(v)) {
    if (is.factor(v)) {
      cat("Labels:\n")
      cat(levels(v), sep = "\n")
    } else {
      cat("\nNo labels available. Levels present:\n")
      v %>%
        unique() %>%
        sort() %>%
        cat(sep = "\n")
    }
  } else {
    haven::print_labels(v)
  }
}

#' Frase con listado de frutas
#'
#' @param frutas Vector character con nombres de frutas (o cualquier lista de
#'   sustantivos en singular)
#'
#' @return Un vector character de longitud 1, con una frase listando la cantidad
#'   de ocurrencias de cada fruta. Para k frutas con n_1, n_2, ..., n_k
#'   repeticiones cada una, el resultado final es: "Tengo unos n_1 fruta_1, n_2
#'   fruta_2, ..., y n_k fruta_{k}".
#'
#' @export
#'
#' @examples
#' frutas <- sample(c("limón", "Durazno", "ananá"), size = 21, replace = TRUE)
#' frase_frutas(frutas)
frase_frutas <- function(frutas) {
  cuantas.frutas <- table(frutas)
  names(cuantas.frutas) <- tolower(names(cuantas.frutas))

  n <- length(cuantas.frutas)

  eses <- ifelse(
    grepl("[aáeéiíoóuú]$", names(cuantas.frutas)),
    "s",
    "es"
  )

  tmp <- paste0(cuantas.frutas[-n], " ",
    names(cuantas.frutas)[-n], eses[-n],
    collapse = ", "
  )

  paste0(
    "Tengo unos ", tmp, " y ",
    cuantas.frutas[n], " ",
    names(cuantas.frutas)[n], eses[n]
  )
}
