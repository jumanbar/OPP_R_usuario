# Capacitación de R: nivel USUARIO
# Clase 4: Tablas & tidyverse (II)
# Autor: Juan Manuel Barreneche Sarasola
# **************************************

library(tidyverse)

# Filtrar sin filter ----
filter(hog, dpto == 2)

x <- 6:10
w <- which(x > 7.5)
x[x > 4]
x[w]

hog[hog$dpto == 2,]
w <- which(hog$dpto == 2)
hog[w,]

# Recodificar on if_else: nueva columna = urbrur
# 
# Repaso de lo último visto en la clase anterior: recodificar variables usando
# if_else
hog <- 
  hog %>% 
  mutate(
    mdeointtp = if_else(region_3 == 1, 1, 2),
    urbrur    = if_else(region_4  < 3, 1, 2)
    )

class(hog$mdeointtp) <- "haven_labelled"
attr(hog$mdeointtp, "label") <- "Total país dividido entre Montevideo e interior"
attr(hog$mdeointtp, "labels") <- c("Montevideo" = 1, "Interior" = 2)

class(hog$urbrur) <- "haven_labelled"
attr(hog$urbrur, "label") <- "Total país dividido entre urbano y rural+peq.loc."
attr(hog$urbrur, "labels") <- c("País urbano" = 1, "Peq. localidades y rural" = 2)

hog %>% count(urbrur)
hog %>% count(region_4, urbrur)
hog %>% distinct(region_4, urbrur)
hog %>% distinct(region_3, region_4, mdeointtp, urbrur)

# Nota: la función count es un wrapper (ie: sinónimo) al siguiente comando:
hog %>% 
  group_by(urbrur) %>% 
  summarise(n = n())
hog %>% count(urbrur)

# Ejercicio 1 ----
#
# Aprender a recodificar con recode y case_when.
#
# El objetivo es poner a prueba nuestra habilidad para aprender a utilizar una
# función nueva.
#
# Si miramos la documentación de mutate, podremos encontrar la sección "Useful
# functions available in calculations of variables". Desde allí podemos navegar
# directamente a la documentación de recode y case_when.

# Problemas: 
# 
# 1. Crear urbrur utilizando recode...
# 
# 2. Crear, utilizando case_when, la variable sjefe, en la tabla per, 
# siguiendo las reglas:
#
# e30 | e26 | sjefe  
#   1 |   1 |     1
#   1 |   2 |     2

# Respuestas: ─────────────────────

hog <- 
  hog %>% 
  mutate(urbrur = 
           recode(as.integer(region_4),
                  `1` = 1, `2` = 1,
                  .default = 2))
           # recode(as.integer(region_4),
           #        1, 1, 2, 2))
           # recode(as.integer(region_4),
           #        `1` = 1, `2` = 1,
           #        `3` = 2,  `4` = 2))

count(hog, region_4, urbrur)

# e30 | e26 | sjefe  
#   1 |   1 |     1
#   1 |   2 |     2
per <-
  per %>% 
  mutate(sjefe = case_when(
    e30 == 1 & e26 == 1 ~ 1,
    e30 == 1 & e26 == 2 ~ 2,
    TRUE ~ 0
  ))
per %>% distinct(e30, e26, sjefe)

# ─────────────────────────────────

# recode : convierte 1 valor en otro, relación 1 a 1
hog <- 
  hog %>% 
  mutate(trim = recode(
    as.integer(mes),
    `1` = "T1",
    `2` = "T1",
    `3` = "T1",
    `4` = "T2",
    `5` = "T2",
    `6` = "T2",
    `7` = "T3",
    `8` = "T3",
    `9` = "T3",
    .default = "T4"
  )) 
hog %>% select(mes, trim)

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

# Seleccionar hogares en Artigas, Salto y Rivera, en zonas rurales
#
# Operadores lógicos útiles:
# <  <=   is.na() %in%  | xor()
# >  >=  !is.na()    !  &
# 
# Respuestas: ─────────────────────

# ─────────────────────────────────

# mutate_all ----
# 
hog$nombarrio %>% unique %>% sort

?mutate_all

x <- c("Villa Espa¦ola", "Villa Mu¦oz, Retiro")

hog %>% 
  mutate_all(
    function(columna) gsub("¦", "ñ", columna))

hog %>% 
  mutate_if(
    is.character,
    function(columna) gsub("¦", "ñ", columna)) %>% 
  distinct(nombarrio)

hog %>% 
  mutate(nombarrio = gsub("¦", "ñ", nombarrio)) 

# Fusionar tablas ----
hp <- left_join(hog, per, by = "numero")
hp <- left_join(hog, per)
names(hp) %>% tibble %>% View

c("anio", "numero", "dpto", "nomdpto", "secc", "segm", "locagr", "nom_locagr", "ccz", "barrio", "nombarrio", "mes", "estred13", "region_3", "region_4", "pesoano", "pesotri", "pesomen")

# ggplot2 ----

p <-
  ggplot(hog) +
  aes(x = HT11) +
  geom_histogram()

p
print(p)

p + scale_x_log10() +
  ggtitle("Ingresos", "Subtítulo") +
  xlab("Ingreso en pesos") +
  ylab("Cantidad de hogares")

ggplot(hog) +
  aes(x = HT11, fill = nomdpto) +
  geom_histogram() +
  scale_x_log10() +
  ggtitle("Ingresos", "Subtítulo") +
  xlab("Ingreso en pesos") +
  ylab("Cantidad de hogares")


ggplot(hog) +
  aes(x = HT11, fill = nomdpto) +
  geom_histogram() +
  scale_x_log10() +
  facet_grid(as.character(region_3) ~ as.character(region_4))

sapply(hog, class)

hog %>% mutate(
  region_3 = as.character(region_3),
  region_4 = as.character(region_4),
) %>%
  ggplot() +
  aes(x = d25, y = HT11, shape = region_4, color = region_4) +
  geom_point() +
  scale_y_log10()

# spread gather ---- 

# FIN ----
# 
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


