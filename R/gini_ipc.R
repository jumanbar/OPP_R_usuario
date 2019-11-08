# INTRO ----

# Cálculo de índice Gini para hogares para dos años consecutivos y por
# departamentos, usando tres tablas hipotéticas:
#
# tabla_ipc: tabla con el ajuste del ipc por año y mes.
#
# - Columnas: year (integer), month (integer), ipc (numeric)
#
# hog2016: tabla con la ECH (hogares) del año 2016.
#
# - Columnas mínimas: anio (integer), mes (integer), YHOG (numeric), pesoano
# (numeric), depto (integer, factor o character)
#
# hog2017: ídem que hog2016, pero el nombre de YHOG es yhog.
#
# Nota: el cálculo del índice Gini se hace a partir del YHOG (ingresos del
# hogar no imputables a personas) multiplicado para el ajuste de ipc
# correspondiente al mes y año de la ECH.

# Paquetes ----
# install.packages("acid")
library(acid)
library(tidyverse)

# Importar tablas:
# tabla_ipc
# hog2016
# hog2017

# Resultados ----
bind_rows(
  select(hog2016, anio, mes, YHOG, pesoano, depto),
  select(hog2017, anio, mes, YHOG = yhog, pesoano, depto)
) %>% 
  left_join(tabla_ipc, by = c("anio" = "year", "mes" = "month")) %>% 
  group_by(anio, dpto) %>% 
  summarise(GINI = weighted.gini(YHOG * ipc, pesoano)$Gini) %>% 
  arrange(anio, GINI)
