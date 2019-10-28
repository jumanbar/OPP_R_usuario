# Capacitación de R: nivel USUARIO
# Clase 3: Tablas & tidyverse
# Autor: Juan Manuel Barreneche Sarasola
# **************************************

# Preámbulo: importar tabla hogares ----

library(haven) # Para usar la función read_sav y las clases asociadas
hog <- read_sav("datos/ECH2018/H_2018_TERCEROS.sav")

# Pero para evitar algunos inconvenientes de la clase haven_labelled,
# convertimos la tabla entera con as_factor (no confundir con as.factor!):
hog <- as_factor(hog)

# Opcional: en el archivo funciones.R (sub-carpeta R del proyecto) hay una
# función práctica para mostrar las etiquetas de las columnas:

# Paso 1: ejecutar todos los comandos del script funciones.R (encoding = "UTF-8"
# es opcional):
source('~/Dropbox/R/OPP_R_usuario/R/funciones.R', encoding = "UTF-8")

# Paso 2 (ejemplo de uso de dic):
dic(hog, region_3)

# Nota: en caso de que busque descifrar el código de la función, debe tener en
# cuenta que está programada para poner el nombre de la columna sin usar
# comillas, al momento de hacer el llamado. Esto requiere cierto truquito dentro
# de la función, el cual se encuentra en la línea: 
# v <- pull(.data, !!enquo(.var)).
# Por más detalles, ver: https://dplyr.tidyverse.org/articles/programming.html

# Tidyverse 101 ----

library(tidyverse)
# Habrán notado que al cargar Tidyverse se imprime algo así:
# ── Attaching packages ────────────────────── tidyverse 1.2.1 ──
# ✔ ggplot2 3.1.1       ✔ purrr   0.3.2  
# ✔ tibble  2.1.1       ✔ dplyr   0.8.0.1
# ✔ tidyr   0.8.3       ✔ stringr 1.4.0  
# ✔ readr   1.3.1       ✔ forcats 0.4.0  
# ── Conflicts ───────────────────────── tidyverse_conflicts() ──
# ✖ dplyr::filter() masks stats::filter()
# ✖ dplyr::lag()    masks stats::lag()

# Lo que nos muestra es la lista de paquetes cargados, incluidos en el
# Tidyverse.

# "The tidyverse is an opinionated collection of R packages designed for data
# science. All packages share an underlying design philosophy, grammar, and data
# structures."
browseURL("https://www.tidyverse.org/")

# Recomiendo particularmente el libro de Hadley Wickham, R for Data Sicence
# (disponible gratis en línea):
browseURL("http://r4ds.had.co.nz/")


# * dplyr ----
browseURL("https://dplyr.tidyverse.org/articles/dplyr.html")

# dplyr es un paquete qué rediseña muchas de las tareas más importantes a la
# hora de manipular tablas de datos, ya sea para acomodar o visualizar datos,
# basándose en el uso de funciones simples pero prácticas. La lista básica
# inicial de funciones es:

# mutate() adds new variables that are functions of existing variables
# select() picks variables based on their names.
# filter() picks cases based on their values.
# summarise() reduces multiple values down to a single summary.
# arrange() changes the ordering of the rows.

# Ver el cheatsheet!
browseURL("https://www.rstudio.com/resources/cheatsheets/")

# * * select ----

# Por ejemplo, en el caso de la tabla hog, una buena forma de mirar sólo las
# columnas que nos interesan es usar la función select:
select(hog, dpto)

# Una característica de las funciones tidyverse es que, en general, nos permiten
# nombrar las columnas sin usar comillas:
select(hog, nomdpto, nombarrio, secc, segm, ccz)
# Esto es lo que se conoce como Non-Standard Evaluation (NSE;
# http://adv-r.had.co.nz/Computing-on-the-language.html). Es similar a:
curve(sin(x), from = -pi, to = pi) # Aquí usar sin(x) es el ejemplo de NSE

# El ejemplo anterior de select, sería equivalente a:
hog[, c("nomdpto", "nombarrio", "secc", "segm", "ccz")] # Standard Evaluation

# (Otra característica es que la tabla con los datos va como primer argumento,
# en todas o casi todas las funciones.)

# Facilidades de select!
select(hog, dpto:nombarrio, h155_1) # Usar los : con nombres, en vez de nros
select(hog, dpto:nombarrio, -secc)  # Usar el - para quitar columnas
select(hog, dpto:nombarrio, -secc:-segm, -barrio, -ccz, h155_1)
select(hog, 4, 8, 11:21, -16:-20) # Usar números si prefiere
select(hog, Departamento = nomdpto)
rename(hog, Departamento = nomdpto)
select(hog, starts_with("h"))     # Las que empiezan con h...
?select_helpers # Elegir "Select helpers" del paquete tidyselect

# Nota: si bien tiene alguna inspiración proveniente de SQL, también hay que
# destacar que tiene múltiples diferencias

# * * * Ejercicio 1: ----

# Seleccionar todas las columnas de hog *excepto*:
# - nomdpto
# - nom_locagr
# - nombarrio
# - ^c5.* (empiezan con c5)
# - ^ht.* (empiezan con ht)
# 
# Guardar el objeto resultante bajo el nombre "hog_sel"
# 
# Respuesta: ─────────────────


# ────────────────────────────

# select_all: sirve para aplicar una funcion a todos los nombres de las
# columnas:
select_all(hog, toupper)

# select_if: selecciona columnas que cumplen con determinada condición y le
# agrega la opción de aplicar una función a todos los nombres de las columnas:
select_if(hog, is.factor, toupper)

# select_at: funcionalmente es como un select común, pero le agrega la opción de
# aplicar una función a todos los nombres de las columnas. Requiere el detalle
# de usar la función auxiliar vars():
select_at(hog, vars(dpto, mes, region_3, c1:c4), toupper)

# * * filter ----
# 
# (no confundir con stats::filter)

# Filter devuelve solamente las filas que nos interesan:
filter(hog, dpto == "Artigas") # Sólo las filas con departamento Artigas

tmp <- filter(hog, dpto == "Artigas")
select(tmp, nomdpto, nom_locagr, mes, estred13:last_col()) # Notar: last_col()

# Recordemos que se pueden combinar condiciones de varias maneras:
tmp <- filter(hog, dpto == "Artigas" & HT11 > 200000)
tmp # 3 casos en la tabla
select(tmp, pesoano) # Representan a 35+21+25:
sum(select(tmp, pesoano)) # 81 hogares

# * * * Ejercicio 2: ----
#
# Filtrar la tabla hog y guardar en un objeto llamado flo todos los casos
# correspondientes a Flores y Florida, tales que el ingreso total por hogar se
# encuentra entre 50 mil y 150 mil pesos.
#
# Respuesta: ─────────────────


# ────────────────────────────

# Además del filter común, también hay tres variantes que sirven para tratar con
# muchas variables al mismo tiempo de diferentes maneras:
?filter_all

# Se dice que aplica expresiones de fitrado a variables "scoped" (dentro de un
# certo alcance o rango):

# - filter_all: aplica un mismo filtro a todas las variables, aunque ojo que no
#               funciona si el filtro aplicado no se puede evaluar en todas las
#               columanas. Requiere el uso de all_vars o any_vars:
filter_all(hog, any_vars(. < 3)) # No filtró nada
filter_all(mtcars, any_vars(. > 400)) # No filtró nada

# - filter_if: el filtro se aplica sólamente a las variables (columnas) cuyos 
#              valores cumplen con determinada condición.
filter_if(hog, is.numeric, any_vars(. > 7e6))

# - filter_at: es como combinar un filter_all con un select... es decir, se 
#              eligen las variables usando var() (mismos criterios que select) y
#              se aplica un filtro all_vars o any_vars:
filter_at(hog, vars(starts_with("ht", ignore.case = TRUE)), any_vars(. > 1e6))

# * * arrange ----
# 
# Ordenar los datos según columnas
arrange(hog, dpto)

# La gracia es que puedo combinar variables para ordenar:
arrange(hog, dpto, barrio, mes)

# Con desc() se puede ordernar a la inversa
arrange(hog, desc(dpto), barrio, mes)
