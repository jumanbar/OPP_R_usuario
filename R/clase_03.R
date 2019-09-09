# Capacitación de R: nivel USUARIO
# Clase 3: Tablas & tidyverse
# Autor: Juan Manuel Barreneche Sarasola
# **************************************

library(tidyverse)
# Ejercicio 1 -----
# Cargar las tablas que preparé para la clase...
# a. Importar H_2018_Terceros_seleccion.dat, creando un objeto llamado
#    "hog_prueba"
# b. Importar ahora la versión .sav de esta tabla, creando un objeto llamado
#    "hog"
# c. Examinar las diferencias entre ambos objetos y determinar por qué existen y
#    cómo puedo darme cuenta de que son diferentes sin examinarlos visualmente.
# Respuestas: ─────────────────────

# ─────────────────────────────────

# ─── REINICIAR R (Session > Restart R) ───

ls() # Lista de objetos presentes en la sesión

load("datos/ECH2018/HP_seleccion.RData")

# Imprimir las tablas para mirar por arriba:
hog
per
class(hog)

# Por qué ahora se imprimen diferente? ...
# 
# Respuesta: porque no están cargados los paquetes necesarios para que R imprima
# correctamente los objetos de clase tbl_df. Debe notarse que no dejan de ser 
# tablas del tipo data.frame. A la clase de base, se le suma esta nueva clase,
# la cual hereda de la primera, pero cambia algunas cosas (como la forma de 
# imprimir en pantalla y otros detalles).
library(tidyverse)
hog
hog["dpto"]

# Notar que la columna dpto es numérica, pero tiene asociadas etiquetas a cada
# uno de sus valores

str(hog$dpto)

# También es práctico encontrar que al ver la tabla, aparecen etiquetas 
View(hog)

# Tidyverse 101 ----

# "The tidyverse is an opinionated collection of R packages designed for data
# science. All packages share an underlying design philosophy, grammar, and data
# structures."
browseURL("https://www.tidyverse.org/")

# Recomiendo particularmente el libro de Hadley Wickham, R for Data Sicence
# (disponible gratis en línea):
browseURL("http://r4ds.had.co.nz/")

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
# 
# Ya conocemos el tibble, que introduce la clase tbl_df

# * The Pipe ----
#
# paquete: magrittr
# 
# Debido a que lo uso, y voy a estar usando mucho en esta clase, corresponde
# presentar al pipe, al que podríamos traducir como el caño o el tubo:
#
# %>% (Ctrl+Shift+M en RStudio)

# Los siguientes 4 comandos son todos equivalentes:
dim(hog)
hog %>% dim
hog %>% dim()
hog %>% dim(.)

# En verdad no es más que una forma alternativa de escribir comandos... pero si
# lo describimos con estos términos no hacemos justicia a las posibilidades
# sintácticas que este comando abre.

# Para entender lo que quiero decir, está bueno ver otros ejemplos:
hog %>% pull(nombarrio) # nombarrio es una columna de hog

# Nota: pull es un comando de dplyr

# Lo más común es ir creando un comando que va creciendo, agregando segmentos
# de tubo al final:
hog %>% pull(nombarrio) %>% unique %>% sort

# Básicamente hay que pensarlo así:
# ENTRADA %>% SALIDA-ENTRADA %>% ... %>% SALIDA

# Esta estructura permite ir construyendo de forma orgánica nuevos comandos. El
# comando anterior escrito con notación de R base sería así:
sort(unique(pull(hog, nombarrio)))

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
hog %>% select(nomdpto, nombarrio, secc, segm, ccz)

# Esto sería equivalente a:
hog[, c("nomdpto", "nombarrio", "secc", "segm", "ccz")]

# Nota: la tabla con los datos es el primer argumento
hog %>% select(., nomdpto, nombarrio, secc, segm, ccz)
# Es igual que:
select(
  hog, # tabla con datos
  nomdpto, nombarrio, secc, segm, ccz # columnas que me interesan
  )
# Nota: en dplyr siempre casi siempre el primer argumento de las funciones es un
# objeto con datos.

# Facilidades de select!
hog %>% select(dpto:nombarrio, h155_1) # Usar los : con nombres, en vez de nros
hog %>% select(dpto:nombarrio, -secc)  # Usar el - para quitar columnas
hog %>% select(dpto:nombarrio, -secc:-segm, -barrio, -ccz, h155_1)
hog %>% select(4, 8, 11:21, -16:-20) # Usar números si prefiere
hog %>% select(Departamento = nomdpto)
hog %>% rename(Departamento = nomdpto)
hog %>% select(starts_with("h"))     # Las que empiezan con h...
?select_helpers

# Nota: si bien tiene alguna inspiración proveniente de SQL, también hay que
# destacar que tiene múltiples diferencias

# * * filter ----
# 
# (no confundir con stats::filter)

# Filter devuelve solamente las filas que nos interesan:
hog %>% 
  filter(dpto == 2) %>% 
  nrow() # Hay 922 observaciones para Artigas

hog %>% 
  filter(dpto == 2) %>% 
  select(nomdpto, nom_locagr, mes, estred13:last_col()) # Notar: last_col()

hog %>% 
  filter(dpto == 2 & region_4 == 3)

# Con estos ejemplos, además de mostrar la utilidad de filter, la intención es
# exponer la forma en que el tubo permite ir acumulando comandos de a una línea.
# Esto es fácil de leer y de escribir.

# * * arrange ----
# 
# Ordenar los datos según columnas
hog %>% 
  arrange(dpto)

# La gracia es que puedo combinar variables para ordenar:
hog %>% 
  arrange(dpto, barrio, mes)

# Con desc() se puede ordernar a la inversa
hog %>% 
  arrange(desc(dpto), barrio, mes)

# * * mutate ----
#
# Esta función es sumamente útil... crea una nueva columna (o modifica una ya
# existente), basada en una fórmula o función, y otras columnas:
hog %>% 
  mutate(ingpers = HT11 / d25) %>%
  select(HT11, d25, ingpers) %>% 
  arrange(desc(ingpers))

# Este es un buen momento para mostrar el uso de group_by:
hog %>% 
  group_by(numero) %>% 
  summarise(ht11_max = max(HT11))

# Básicamente lo que hago con group_by es agregar datos según una o más 
# variables... Luego es necesario utilizar una función extra, summarise,
# hacer el cálculo.

hog %>% select(numero, ht19) %>% distinct()

# Ingreso del hogar con v.l. per cápita:
hog %>% 
  group_by(numero, ht19) %>% 
  summarise(ht11_max = max(HT11)) %>% 
  mutate(ypcvl = ht11_max / ht19)


# * * * Recodificar variables ----
# 
# if_else : caso sencillo, divide el conjunto en dos
hog %>%
  mutate(tresomas = if_else(d25 >= 3, "3 o más", "1 o 2")) %>% 
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

# Ejercicio 2 ----
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

# recode : convierte 1 valor en otro, relación 1 a 1
hog %>% 
  mutate(mesabr = recode(
    as.integer(mes),
    `1` = "Ene",
    `2` = "Feb",
    `3` = "Mar",
    `4` = "Abr",
    `5` = "May",
    `6` = "Jun",
    `7` = "Jul",
    `8` = "Ago",
    `9` = "Set",
    `10` = "Oct",
    `11` = "Nov",
    `12` = "Dic"
    )) %>% 
  select(mes, mesabr)

# Se imagina crear la variable urbrur utilizando recode en vez de if_else?

# case_when : el más sofisticado de los casos y el que uso más frecuentemente.

# *parentesco (conyuge, hijos, otros parientes, otros no parientes excluido servicio doméstico).
# if (e30 = 2) conyuge = 1 .
# if (e30>=3 and e30<=5) hijo=1.
# if (e30=3 ) hijoambos=1.
# if (e30=4 or e30=5) hijouno=1.
# if (e30>=6 and e30<=12) otropar=1.
# if (e30 = 13) otronopa = 1 .
# if(e30=14) servdom=1.
# 
# recode conyuge hijo hijoambos hijouno otropar otronopa servdom (sysmis=0).
per <- 
  per %>% 
  mutate(parentesco = case_when(
    e30 == 2 ~ "conyuge",
    e30 >= 3 & e30 <= 5 ~ "hijo", # Esta se superpone con las dos siguientes
    e30 == 3 ~ "hijoambos",
    e30 == 4 | e30 == 5 ~ "hijouno",
    e30 >= 6 & e30 <= 12 ~ "otropar",
    e30 == 13 ~ "otronopa",
    e30 == 14 ~ "servdom"
  ))

per %>% count(parentesco)

# El caso de count, es un wrapper de group_by y summarise
hog %>% count(nomdpto, region_4)

hog %>% count(nomdpto, region_4) %>% 
  arrange(nomdpto, desc(n)) %>% View

# Ejercicio 3 ----
#
# crear la variable sexojefe, siguiendo la premisa:
# 
# *sexo del jefe.

# if (e30=1 and e26=1)jefehom=1.
# if (e30=1 and e26=2)jefemuj=1.
# 
# recode jefehom jefemuj (sysmis=0).
# execute.



# Seleccionar hogares en Artigas, Salto y Rivera, en zonas rurales
#
# Operadores lógicos útiles:
# <  <=   is.na() %in%  | xor()
# >  >=  !is.na()    !  &
# 
# Respuestas: ─────────────────────

# ─────────────────────────────────

# Hogares en artigas, salto y rivera cuyos ingresos en dinero sean mayores a la
# media de los hogares de todo el país consultados en la encuesta. Me interesa

attributes(hog$h155_1)

j <- 
  sapply(hog, attr, which = "label") %>%
  grep("Monto", .)

monto <- hog %>% 
  select(j) %>% 
  apply(1, sum)

hog$monto <- monto

mean(monto)

hog %>% 
  filter(dpto %in% c(2, 13, 15) & monto >= mean(monto)) %>% 
  select(numero, dpto, )
  

# A tener en cuenta... tiene sentido usar el promedio? Sería mejor capaz usar el promedio en escala logarítmica

lmean <- hog %>% filter(h155_1 > 0) %>% pull(h155_1) %>% log10 %>% mean
mean0 <- hog %>% filter(h155_1 > 0) %>% pull(h155_1) %>% mean
10**lmean
mean(hog$h155_1)

# Contabilizar la proporción de estos hogares que son mayores al promedio nacional, 
# separando por departamento.
# 
# 

# h155_1 es monto percibido en dinero:
hog %>% pull(h155_1) %>% mean
hog %>% pull(h155_1) %>% median

# Qué raro esto de la mediana...
hog %>% pull(h155_1) %>% summary

# Este resumen nos da un indicio de que hay muchos ceros en los datos
nceros <- hog %>% 
  filter(h155_1 == 0) %>% 
  nrow
nceros / nrow(hog)
# 93 %

hog %>% 
  mutate(escero = h155_1 == 0) %>%
  group_by(nomdpto) %>% 
  summarise(prop_ceros = sum(escero) / n()) %>% 
  arrange(desc(prop_ceros))
  

# Veamos un histograma...
h <- hog %>% 
  ggplot() +
  aes(x = h155_1) +
  geom_histogram()
h # Se vé demasiado apretado... tal vez con alguna transformación

h + geom_vline(xintercept = mean(hog$h155_1), col = "red")

h + scale_x_log10() +
  geom_vline(xintercept = 10**lmean, col = "red") +
  geom_vline(xintercept = mean0, linetype = 2, col = "red") +
  geom_vline(xintercept = mean(hog$h155_1), linetype = 3, col = "red")


# Como podrán ver, en este comando se pueden 
group_by(iris, Species) %>% slice(1:4)


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
tibble(x)
tibble(x) %>% View

attributes(x)
attr(x, "labels")
attr(x, "label") <- "Calificación de encuesta"

tibble(x) %>% View

