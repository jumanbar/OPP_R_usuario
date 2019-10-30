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
source('R/funciones.R', encoding = "UTF-8")

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

# * * * Ejercicio 1 ----

# Seleccionar todas las columnas de hog *excepto*:
# - nomdpto
# - nom_locagr
# - nombarrio
# - ^c5.* (empiezan con c5)
# - ^ht.* (empiezan con ht)
# 
# Guardar el objeto resultante bajo el nombre "hog_sel".
# 
# Nota: el comando names(hog) sirve para imprimir los nombres de las columnas en la consola.
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
select_at(hog,
          vars(dpto, mes, region_3, c1:c4),
          toupper)

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

# * * * Ejercicio 2 ----
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
filter_all(mtcars, any_vars(. > 400))

# - filter_if: el filtro se aplica sólamente a las variables (columnas) cuyos 
#              valores cumplen con determinada condición.
filter_if(hog, is.numeric, any_vars(. > 7e6))

# - filter_at: es como combinar un filter_all con un select... es decir, se 
#              eligen las variables usando var() (mismos criterios que select) y
#              se aplica un filtro all_vars o any_vars:
filter_at(hog,
          vars(starts_with("ht", ignore.case = TRUE)), 
          any_vars(. > 1e6))

# * * arrange ----
# 
# Ordenar los datos según columnas
arrange(hog, dpto)

# La gracia es que puedo combinar variables para ordenar:
arrange(hog, dpto, barrio, mes)

# Con desc() se puede ordernar a la inversa
arrange(hog, desc(dpto), barrio, mes)

# * * mutate ----
#
# Esta función modifica la tabla creando o sustituyendo una variable (columna),
# utilizando expresiones a voluntad...

# Un ejemplo trivial:
hsel <- select(hog, d25, HT11)

# Aquí agregamos una columna llamada x con el valor 1 en todas las filas:
mutate(hsel, x = 1)

# Un ejemplo un poco más sofisticado: tomar las variables d25 (Total de personas
# del hogar) y HT11 (Ingresos totales del hogar con valor locativo, sin servicio
# doméstico) y calcular el ingreso por persona promedio para cada hogar. Es
# decir: HT11 / d25:
mutate(hsel, ingpers = HT11 / d25)

# Utilizando algunas funciones que hemos visto anteriormente, podemos utilizar
# mutate para recodificar variables. En el siguiente ejemplo creamos una
# variable llamada "categoria" que divide los hogares entre los que tienen un
# ingreso por person mayor o igual a 40 mil pesos y el resto:
tmp <- mutate(
  hsel, 
  ingpers = HT11 / d25, 
  categoria = ifelse(ingpers >= 4e4, "A", "B")
  )
tmp
# Con ayuda de la función count podemos hacer un conteo de estas categorías:
count(tmp, categoria)

# Nota: la función count se puede expandir con otras variables:
count(tmp, d25, categoria)

# * * * Ejercicio 3: ----
#
# Tomando como referencia el ejemplo anterior de mutate, considere la necesidad
# de construir la siguiente columna: franja
# 
# Esta columna dividirá los valores de ingpers en 4 categorías:
#  - Muy bajos: entre 0 y hasta 10 mil pesos
#  - Bajos: más de 10 mil y hasta 25 mil pesos
#  - Altos: más de 25 mil y hasta 40 mil pesos
#  - Muy altos: más de 40 mil
#  
# Nota 1: para este caso es ideal la función case_when
# 
# Nota 2: para el caso de la ECH 2018, el conteo por franjas es: 
# 
# > count(tmp, franja)[c(4, 2, 1, 3),]
# # A tibble: 4 x 2
#   franja        n
#   <chr>     <int>
# 1 Muy bajos  3490
# 2 Bajos     17870
# 3 Altos     10863
# 4 Muy altos 10059

# Respuesta: ─────────────────



# ────────────────────────────

# Nota: visitar la ayuda de mutate para ver funciones útiles para acompañar a
# mutate:
?mutate

# * * El pipe: %>% ----
#
# paquete: magrittr, parte del tidyverse
#
# Este es una funcionalidad del tidyverse cuyo impacto es difícil de comprender
# inicialmente, pero hace una diferencia sustancial para el trabajo día a día.
#
# Observación: estos dos comandos dan el mismo resultado:

hsel <- select(hog, d25, HT11, pesoano)

hsel <- hog %>% select(d25, HT11, pesoano)

# Nota: el pipe se puede escribir en RStudio con el atajo: Ctrl+Shift+M
# 
# (lista completa de atajos Alt+Shift+K)

# Sintaxis: los siguientes 4 comandos son todos equivalentes:
dim(hog)
hog %>% dim
hog %>% dim()
hog %>% dim(.)

# En este último caso, el punto actúa como sustituo de hog. La idea es que con
# el punto podemos argumentos distintos del primero. Un ejemplo que uso
# frecuentemente es el grupo de funciones grep:
deptos <- hog %>% pull(dpto) %>% levels # Primero extraigo los departamentos
deptos %>% grep("flo", ., ignore.case = TRUE, value = TRUE)

# En verdad no es más que una forma alternativa de escribir comandos... pero si
# lo describimos con estos términos no hacemos justicia a las posibilidades
# sintácticas que este comando abre.

# Ya vimos que para seleccionar algunas columnas, la función select espera que
# el primer argumento sea una tabla de datos. Pero esto último aplica a otras
# funciones del tidyverse: filter, mutate, arrange, count... De hecho, es una
# regla impuesta por el tidyverse. La razón, aunque parezca superficial, es que
# esta dispoción facilita el uso del pipe concatenado...

# Para entender lo que quiero decir, está bueno ver otros ejemplos:
#
# En el trabajo diario, uno normalmente inicia un comando complejo con algo muy
# simple. Por ejemplo:
hog %>% 
  filter(grepl("flo", dpto, ignore.case = TRUE)) 

# (Notar que por ahora no estoy "guardando" la salida del comando... eso lo haré
# una vez que tengo mi comando final, si es que considero que me es de
# utilidad.)

# Dado que me interesan solo algunas columnas, voy a proceder a agregar un
# select al final del comando anterior:
hog %>% 
  filter(grepl("flo", dpto, ignore.case = TRUE)) %>% 
  select(HT11, d25, pesoano)

# Aquí ya estoy visualizando parte de los datos, la parte que me interesa de
# hecho. En estos casos no sería raro ordenar según alguna columna de interés.
# En este caso, me interea ver los hogares encuestados con mayores ingresos:
hog %>% 
  filter(grepl("flo", dpto, ignore.case = TRUE)) %>% 
  select(HT11, d25, pesoano) %>% 
  arrange(desc(HT11))

# Supongamos que en este punto me dí cuenta de que es más interesante el ingreso
# promedio por persona en el hogar, así que voy a agregar un comando más, pero
# esta vez en lugar de ser al final, lo haré previo al arrange (y cambiaré la
# columna por la cual se ordenan las entradas):
hog %>% 
  filter(grepl("flo", dpto, ignore.case = TRUE)) %>% 
  select(HT11, d25, pesoano) %>% 
  mutate(ingpers = HT11 / d25) %>% 
  arrange(desc(ingpers))

# Interesante como los hogares con mayores ingresos por persona son aquellos
# constituidos por 1 persona. Posiblemente los hogares con más de una persona
# incluyen hijos/as...

# Luego de construir este comando, veamos cómo se escribiría usando solamente
# funciones anidadas...
arrange(
  mutate(
    select(
      filter(hog, grepl("flo", dpto, ignore.case = TRUE)), 
      HT11, d25, pesoano), 
    ingpers = HT11 / d25),
  desc(ingpers))

# En esta versión, el primer comando que escribimos es el último en
# ejecutarse... lo cual no ayuda a la intuición. Notar además que cuando las
# funciones tienen varios argumentos, puede ser difícil identificar quién
# corresponde a quién (ej: ingpers = HT11 / d25 corresponde a mutate,
# desc(ingpers) corresponde a arrange!).

# La alternativa para hacer las cosas "en orden", es crear objetos temporales
# que no volveremos a usar:
tmp1 <- filter(hog, grepl("flo", dpto, ignore.case = TRUE))
tmp2 <- select(tmp1, HT11, d25, pesoano)
tmp3 <- mutate(tmp2, ingpers = HT11 / d25)
arrange(tmp3, desc(ingpers))

# En resumen, cosas que sacamos de todo esto:
# 
# 0. Básicamente, el los pipes hay que pensarlos como:
#    ENTRADA %>% SALIDA-ENTRADA %>% ... %>% SALIDA
# 1. Con los pipes podemos construir gradualmente comandos concatenados de una
#    forma gradual y ordenada, **facil de armar y de leer**.
# 2. También nos podemos ahorrar la creación de muchos objetos innecesarios.
# 3. Para sacar el mayor provecho posible de los pipes es conveniente que
#    A. Simpre el primer argumento de las funciones sea una data.frame/tibble.
#    B. La salida de las funciones también debe ser una data.frame/tibble.
# 4. Ciertas funciones, como $, [, +, etc., no articulan tan bien con el pipe. 
#    Por esta razón existen funciones alias que sustituyen aquellas:
?magrittr::extract

# Ejemplos:
hog %>% extract(1:4,)
hog %>% pull(HT11) # Esta pertenece a dplyr

# * * * Ejercicio 4 ----
#
# Escriba el equivalente a este comando usando pipes en vez de funciones
# anidadas:
grep("^La", sort(unique(pull(hog, nombarrio))), 
     ignore.case = TRUE, value = TRUE)

# Respuesta: ─────────────────


# ────────────────────────────

# * * group_by + summarise ----
#
# Calcular el promedio de personas por hogar por departamento, o por tipo de
# vivienda, o por departamento + tipo de vivienda... Este tipo de tareas
# requieren de hacer un agrupamiento y luego el cáculo deseado.

# 1. Agrupar (group_by):
hog %>% 
  group_by(dpto)
#
# Notar este mensaje:
# A tibble: 42,282 x 164
# Groups:   dpto [19]

hog %>% 
  group_by(dpto, c1)
# A tibble: 42,282 x 164
# Groups:   dpto, c1 [84]
 
# 2. Calcular (summarise):
hog %>% 
  group_by(dpto) %>% 
  summarise(mean_d25 = mean(d25))

# Notar que tiene cierto parecido con mutate. Al igual que mutate puede
# incorporar varias variables sucesivas y usarlas en el mismo comando:

hog %>% 
  group_by(dpto) %>% 
  summarise(
    mean_ingpers = mean(HT11 / d25),
    mean_d25 = mean(d25), 
    mean_HT11 = mean(HT11),
    mean_ingpers2 = mean_HT11 / mean_d25
  )

# Es conveniente visitar la página de ayuda de summarise para ver la sección
# "Userful functions":
?summarise

# Ejemplos:
hog %>% 
  group_by(dpto) %>% 
  summarise(
    n = n(), # Igual al resultado de count(hog, dpto)
    primer_c1 = first(c1), # Primer valor de  para cada dpto
    n_sec = n_distinct(secc)
  )

# * * * Ejercicio 5 ----

# (Es una comparación, a propósito, de dos calculos de ingpers que dan
# distinto.)
# 
# En el ejercicio 3 hicimos la tabla tmp con un comando similar a:
tmp <-
  hog %>% 
  select(HT11, d25, pesoano) %>% 
  mutate(
    ingpers = HT11 / d25, 
    franja = case_when(
      ingpers <= 10e3 ~ "Muy bajos",
      ingpers >  10e3 & ingpers <= 25e3 ~ "Bajos",
      ingpers >  25e3 & ingpers <= 40e3 ~ "Altos",
      TRUE ~ "Muy altos"
      )
  )
count(tmp, franja)[c(4, 2, 1, 3),]

# Notar que este conteo no toma en cuenta la ponderación de la encuesta. Esto se
# puede solucionar usando ingeniosamente las capacidades de group_by, summarise
# y la función sum (sumatoria).
#
# Encuentre la forma de hacer este conteo ponderado y obtenga una tabla que
# muestre el conteo* y el conteo ponderado lado a lado.
# 
# [*]: En este caso es conveniente usar n() y summarise, en lugar de count.
#
# Respuesta: ─────────────────



# ────────────────────────────
#
# * * * Ejercicio 5 extra ----
#
# Partiendo del mismo tmp que en el ejercicio anterior, arme un comando que
# calcule el promedio y el **promedio ponderado** de ingpers por franja.
#
# Recuerde que si x es un vector y p son los pesos de los elementos de x,
# entonces el promedio ponderado equivale a sum(x * p) / sum(p).

# Respuesta: ─────────────────



# ────────────────────────────

# * ggplot2
#
# El paquete ggplot2 es uno de los más populares de R para hacer gráficos, por
# muchas razones, incluyendo:
#
# 1. Estética: hace figuras muy lindas
#
# 2. Gramática: permite combinar varios comandos para ir construyendo un gráfico
#    y, sobre todo, codificar y separar la información de manera útil.
#
# 3.
#
# Tres componentes básicos:
# 
# DATOS + MAPEO (aes) + GEOMETRÍA
# 
# (data + geom + coordinate system):
ggplot(hog) +              # DATOS
  aes(x = d25, y = HT11) + # MAPEO
  geom_point()             # GEOMETRÍA

# Los valores de HT11 de repente quedan mejor en logaritmo:
ggplot(hog) +
  aes(x = d25, y = HT11) +
  geom_point() +
  scale_y_log10()

# También me interesa ver si hay alguna asociación con el tipo de vivienda (c1)
# ... para esto sirve modificar el MAPEO (aes):
ggplot(hog) +
  aes(x = d25, y = HT11, col = c1) +
  geom_point() +
  scale_y_log10()

# Supongamos también que preferimos ver las regiones 4 por separado:
ggplot(hog) +
  aes(x = d25, y = HT11, col = c1) +
  geom_point() +
  scale_y_log10() +
  facet_grid(region_4 ~ .)

# La función facet_grid separa los gráficos en subgráficos. La sintaxis que usa
# es la de la "formula" (formula en este contexto tiene un significado técnico
# muy específico). Ejemplos:
# facet_grid(region_4 ~ .) # region_4 en las "filas"
# facet_grid(. ~ region_4) # region_4 en las "columnas"
# facet_grid(c1 ~ region_4) # c1 en "filas" y region_4 en las "columnas"
# 
# Una alternativa es la función facet_wrap, que simplemente incluye los
# gráficos dentro del espacio disponible.

# Veamos otro tipo de gráfico, como el histograma:
ggplot(hog) +
  aes(x = HT11, col = c1) +
  geom_histogram() +
  scale_x_log10()

# Como pueden ver, la coloración afecta el borde de las barras, no el centro. En
# la ayuda de geom_histogram, en la sección Aesthetics (ie: aes):
?geom_histogram

# Allí encontramos que geom_histogram usa las mismas "estéticas" que geom_bar,
# así que hacemos click para ir a la página de esa función y, nuevamente,
# buscamos la sección Aesthetics, en donde figura esta lista:
# - x
# - y
# - alpha
# - colour
# - fill
# - group
# - linetype
# - size

# Y nos dice: learn more about setting these aesthetics in
# vignette("ggplot2-specs"):
vignette("ggplot2-specs")

# Si miramos la sección sobre Polygons, veremos que "The inside is controlled by
# fill", entonces...:
ggplot(hog) +
  aes(x = HT11, fill = c1) +
  geom_histogram() +
  scale_x_log10()

# Notar que los colores no son controlados por el usuario directamente. Ggplot
# se encarga de esos detalles. La **decisión** principal del usuario es
# **definir qué variable será codificada por el color**. Es decir, por diseño
# ggplot orienta al usuario a enfocarse en las decisiones que, según los
# autores, deberían ser las más importantes.

# Pero eso no quiere decir que no se puedan decidir los colores manualmente...
# En estos casos suelo ir a esta página para consultar:
browseURL("http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/")

# Allí encuentro que hay un ejemplo con scale_fill_manual que es el que me
# sirve... usa colores en código hexagesimal. Hay muchos recursos en la web para
# elegir colores (buscar: "color picker"; ej:
# https://www.w3schools.com/colors/colors_picker.asp)

# Pero personalmente prefiero tomar paletas de Color Brewer:
browseURL("http://colorbrewer2.org/")

# De ahí exporté este texto:
# ['#7fc97f','#beaed4','#fdc086','#ffff99','#386cb0']
# 
# El cual rápidamente modifique como:
paleta <- c('#7fc97f','#beaed4','#fdc086','#ffff99','#386cb0')

# Visualización:
barplot(c(1, 1, 1, 1, 1), col = paleta)

# Nota: dentro de ggplot hay funciones para generar este tipo de paletas
??brewer

# Entonces, con la paleta creada, hago por fin mi gráfico:
hog %>% 
  ggplot() +
  aes(x = HT11, fill = c1) +
  geom_histogram() +
  scale_x_log10() +
  xlab("Ingresos totales / hogar") +
  ylab('Cantidad') +
  ggtitle("Distribución de los ingresos según tipo de hogar") +
  scale_fill_manual(values = paleta,
                    name = "Tipo de vivienda", 
                    labels = c("Casa", "Apto/Casa comp. hab.", 
                               "Apto. ed. altura", "Apto. ed. 1 planta",
                               "No p/vivienda"))

# Nota: combinar los pipes con ggplot es un paso natural:
tmp %>% 
  group_by(franja) %>% 
  summarise(mean_ingpers = sum(pesoano * ingpers) / sum(pesoano)) %>% 
  extract(c(4, 2, 1, 3),) %>% # Este paso es para reordenar la tabla resultante 
  ggplot() +
  aes(franja, mean_ingpers) +
  geom_bar(stat = "identity")

# Nota: toma los valores de franja en orden alfabético... este es un típico
# problema de ggplot2... ocurre que un vector tipo character tiene un orden
# natural y es el orden alfabético. La clase de objetos que tiene un orden
# independiente de lo "natural", es el factor. Entonces para que el gráfico use
# el orden que nosotros queremos, tenemos que modificar la columna franja (con
# la función mutate, por ejemplo), de forma que pase a ser un vector ordenado.
#
# Hay funciones en el paquete forcats que ayudan con esto: fct_relevel,
# fct_infreq, fct_inorder, fct_rev, fct_reorder y otras... Ejemplo: fct_relevel
# (ver trensito de forcats)
tmp %>% 
  group_by(franja) %>% 
  summarise(mean_ingpers = sum(pesoano * ingpers) / sum(pesoano)) %>% 
  # Agrego un mutate aquí, para modificar a franja:
  mutate(franja = fct_relevel(franja, c("Muy bajos", "Bajos", 
                                        "Altos", "Muy altos"))) %>% 
  ggplot() +
  aes(franja, mean_ingpers) +
  geom_bar(stat = "identity")

# Nota: ni summarise ni mutate generan cambios permanentes en tmp, ya que no
# estamos sobrescribiendo, por lo tanto cuando digo que "modifico" la columna
# franja, me estoy refiriendo a uno de los pasos intermedios entre el inicio y
# el final de este comando.

# Trensito de ggplot2
browseURL("https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf")

# * * * Ejercicio 6 ----
#
# Explore la hoja de trensitos de ggplot2 y experimente con posibles
# visualizaciones de los datos de la tabla de hogares. Algunas sugerencias:
# 
# Histogramas de pesos, con colores y facetas según deparamentos y/o nom_locagr.
# 
# Boxplot de HT11 según tipo de vivienda.
# 
# Otros....

# Respuesta: ─────────────────



# ────────────────────────────











# * * * Recodificar variables (viejo)
# 
# if_else : caso sencillo, divide el conjunto en dos
hog %>%
  mutate(tresomas = if_else(d25 >= 3, "3 o más", "1 o 2")) %>% 
  select(1:5, tresomas)

hog %>%
  mutate(tresomas = if_else(d25 >= 3, 1, 2)) %>% 
  select(1:5, tresomas)

# Por ejemplo, la variable MDEOINTTP se codifica con este código en SPSS
# **** MDEOINTTP (Total país dividido entre Montevideo e interior)***.
# 
# RECODE
# region_3
# (1=1)  (ELSE=2)  INTO  MDEOINTTP.
# VARIABLE LABELS MDEOINTTP 'Total país dividido entre Montevideo e interior'.
# EXECUTE .
# 
# value labels MDEOINTTP 1 'Montevideo' 2 'Interior'.
hog <- 
  hog %>% 
  mutate(mdeointtp = if_else(region_3 == 1, 1, 2))

attr(hog$mdeointtp, "label") <- "Total país dividido entre Montevideo e interior"
attr(hog$mdeointtp, "labels") <- c("Montevideo" = 1, "Interior" = 2)
class(hog$mdeointtp) <- "haven_labelled"
hog %>% select(mdeointtp)
hog %>% select(mdeointtp) %>% View

# Bonus:
hog %>% count(mdeointtp)

# Ejercicio 2 (viejo)
# 
# Codificar la variable urbrur basada en el siguiente código SPSS
# 
# RECODE
# region_4
# (1,2=1)  (3,4=2)  INTO  URBRUR.
# VARIABLE LABELS URBRUR 'Total país dividido entre urbano y rural+peq.loc.'.
# EXECUTE .
# 
# value labels URBRUR 1 'País urbano' 2 'Peq. localidades y rural'.
# freq URBRUR.
# Respuestas: ─────────────────────

# ─────────────────────────────────

# Clase: haven_labelled ----
# PARÉNTESIS
# Las etiquetas son una implementación de los atributos diseñada para el paquete
# haven, imagino que para imitar funcionalidades de SPSS. Lo primero  para 
# entender objetos nuevos, es identificar su clase:
class(hog$dpto)
library(haven)
?haven_labelled
??haven_labelled

# Luego de ver el primer ejemplo de as_factor, me hice un ejemplo para usar aquí:
labelled(1:5,
         c("Muy malo" = 1, "Malo" = 2, "Normal" = 3, "Bueno" = 4, "Muy Bueno" = 5))

x <- labelled(1:5, c("Muy malo" = 1, "Malo" = 2, "Normal" = 3, 
                     "Bueno" = 4, "Muy Bueno" = 5))

# Respuestas

# Ejercicio 3: ───────────────
tmp <- mutate(
  hsel, 
  ingpers = HT11 / d25, 
  franja = case_when(
    ingpers <= 10e3 ~ "Muy bajos",
    ingpers >  10e3 & ingpers <= 25e3 ~ "Bajos",
    ingpers >  25e3 & ingpers <= 40e3 ~ "Altos",
    TRUE ~ "Muy altos"
  )
)
count(tmp, franja)[c(4, 2, 1, 3),]
# ────────────────────────────

# Ejercicio 4: ─────────────────
hog %>% 
  pull(nombarrio) %>%
  unique %>%
  sort %>% 
  grep("^la", ., ignore.case = TRUE, value = TRUE)
# ────────────────────────────


# Ejercicio 5: ───────────────
tmp %>% 
  group_by(franja) %>% 
  summarise(
    conteo = n(), 
    conteo_p = sum(pesoano)
    )
# ────────────────────────────


# Ejercicio 5: ───────────────
tmp %>% 
  group_by(franja) %>% 
  summarise(
    mean_ingpers = mean(ingpers),
    n_pond = sum(pesoano),
    sum_ingpers = sum(pesoano * ingpers),
    pmean_ingpers = sum_ingpers / n_pond)
# ────────────────────────────
