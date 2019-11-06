# Capacitación de R: nivel USUARIO (2)
# Clase: pivot, tablas de contingencia y más...
# Autor: Juan Manuel Barreneche Sarasola
# **************************************
library(tidyverse)
library(haven)
# install.packages("srvyr")
library(survey)
library(srvyr)


# Preparación ----
hog <- read_sav("datos/ECH2018/H_2018_TERCEROS.sav")
source('R/codac.R', encoding = "UTF-8")

# Recordar esta sintaxis...
fusion <- left_join(per, hog) %>% as_factor

# Considerar este comando:
count(fusion, c1, codac)

# Contiene la misma información que podría tener una tabla de contingencia...
#
# Consideremos también que ya existe una función para crear tablas de
# contingencia:
(contin <- table(fusion$c1, fusion$codac))

# Hay que tener en cuenta algo importante este resultado no es un data.frame ni es una matriz. Es un "table":
class(contin)
typeof(contin)

# Volviendo a lo anterior, los resultados de count tienen la misma información,
# pero dispuesta en otro formato:
count(fusion, c1, codac)

# Esta diferencia es lo que se conoce como tablas en formato "ancho" vs tablas
# en formato "largo".
table(fusion$c1, fusion$codac) # ANCHO
count(fusion, c1, codac)       # LARGO

# Funciones pivot:
fusion %>% 
  count(c1, codac) %>% 
  pivot_wider(
    id_cols = c1,
    names_from = codac,
    values_from = n)

# Recientemente se cambió gather y spread por pivot_wider y pivot_longer

# Hasta ahora, la sintaxis para hacer esto era:
fusion %>% 
  count(c1, codac) %>% 
  spread(key = codac, value = n)

# spread asume que hay una única columna de donde se toman las cateogrías (key),
# así como una única columna con valures (value).
#
# pivot_wider extiende a 1 o muchas columnas de id (en este caso, c1), 1 o
# muchas columnas de nombres (codac) y 1 o muchas columnas de valores (n).

# Ejercicio 1: ----
# 
# Crear una tabla de contingencia entre departamento y tipos de vivienda.
# 
# Respuesta: ─────────────────────



# ────────────────────────────────

# Cómo sería con varias columnas de nombre?
fusion %>% 
  count(dpto, c1, codac) %>% 
  pivot_wider(
    id_cols = dpto,
    names_from = c(c1, codac),
    values_from = n) %>% 
  View


# Inversamente, pivot_longer hace el trabajo inverso.
casacodac <-
  fusion %>% 
  count(c1, codac) %>% 
  pivot_wider(
    id_cols = c1,
    names_from = codac,
    values_from = n)

# Así, por ejemplo, volveríamos al caso original:
casacodac %>% 
  pivot_longer(
    cols = -1, # Nota: cols... tidyselect specification.
    names_to = "codac",
    values_to = "n"
  ) 

# Con gather, la sintaxis sería:
casacodac %>% 
  gather(key = "codac", value = "n", -1)


# Ejercicio 2: ----
# 
# Partiendo de esta tabla de contingencia:
cntg <-
  hog %>% 
  as_factor %>% 
  count(c1, region_4) %>% 
  spread(key = region_4, value = n, fill = 0)

# Crear una tabla "larga" con 3 columnas: c1, region_4 y n

# Respuesta: ─────────────────────


# ────────────────────────────────

# Por qué es importante esta manipulación?
# 
# 1. Ya vimos como pasar de resultados de count a tablas de contingencia y 
#    viceversa
# 
# 2. ggplot:
casacodac %>% 
  pivot_longer(
    cols = -1, # Nota: cols... tidyselect specification.
    names_to = "codac",
    values_to = "n"
  ) %>% 
  group_by(c1) %>% 
  mutate(p = n / sum(n)) %>% 
  ggplot() + 
  aes(c1, p, fill = codac) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::percent) +
  coord_flip() +
  theme(legend.position = "bottom", axis.title.x = element_blank())

# Ejercicio 3: ----
# 
# Partiendo de esta tabla de contingencia
cntg <- 
  left_join(per, hog) %>%
  as_factor %>% 
  as_survey_design(ids = 1, weights = pesoano) %>% 
  group_by(c1, region_4) %>%
  summarise(n = survey_total()) %>% 
  spread(key = region_4, value = n, fill = 0) %>% 
  select(-n_se)

# Hacer un gráfico de los porcentajes de cantidad de casas por region_4
# Respuesta: ─────────────────────


# ────────────────────────────────
