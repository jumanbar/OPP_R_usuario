library(tidyverse)
library(haven)
library(srvyr)

hog <- read_sav("datos/ECH2018/H_2018_TERCEROS.sav") %>% 
  as_factor # Para evitar inconveniencias con columnas "haven_labelled"

hog <- 
  hog %>% 
  mutate_at(
    # El argumento .vars acepta objetos generados por la función vars(), que
    # trabaja con los helpers que utiliza select:
    .vars = vars(starts_with("c5_")),
    # El argumento .funs acepta funciones o fórmulas, en las que se puede usar
    # el punto . como sustituto por las columnas que queremos modificar. Las 
    # fórmulas son objetos con su propia sintaxis, que utilizan el caracter ~
    # para 
    .funs = ~ . == "Sí") %>% 
  mutate(cTodas = c5_1 + c5_2 + c5_3 + c5_4 + c5_5 + c5_6 + c5_7 + c5_8 +
          c5_9 + c5_10 + c5_11 + c5_12) 

hog %>% pull(cTodas) %>% summary

hog %>% 
  ggplot() +
  aes(x = cTodas, y = HT11, col = c1) +
  geom_point() + 
  scale_y_log10() + 
  geom_jitter() + 
  scale_color_discrete(
    name = "Tipo de\nVivienda",
    labels = c("Casa", "Apto/Casa c. hab.",
               "Apto. edif. alt.", "Apto. edif. 1P",
               "Local no viv.")
    )
  

# Ejercicio 1: gráficos ----
# Graficar ingresos por hogar (HT11) en función de cTodas:
# 
# 1. Simple gráfico de puntos
# 
# 2. Ajustar el eje y a escala log10
# 
# 3. Agregar título general, subtítulo y etiquteas a ejes x e y
# 
# 3. Colorear los puntos según c1 (Tipo de vivienda)
# 
# 4. Ajustar las etiquetas de las categorías de c1, así como el título de la
#    leyenda (ver: http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/)
#    
# 5. Separar el gráfico en 5 subgráficos, según c1 con facet_grid o facet_wrap,
#    comparar resultados.

# Regresiones lineales ----
# 
# La función lm es el recurso más sencillo:
modelo <- hog %>% 
  lm(log10(HT11 + 1) ~ cTodas, data = .)

# modelo es una lista, por lo que podemos usar el $ para obtener elementos:
modelo$coefficients 
modelo[[1]]

# La función str nos sirve para ver la info que hay dentro del objeto:
str(modelo)
modelo$residuals

# Con plot podemos ver varios gráficos informativos que son útiles y necesarios
# para evaluar la validez del modelo:
plot(modelo)

# La función summary nos imprime información resumida:
summary(modelo)

# E incluso podemos guardar el summary en otro objeto, el cual también es una 
# lista

s <- summary(modelo)

str(s)

s$r.squared
s$coefficients

# Fórmulas ----
# 
# Con la sintaxis de fórmulas podemos ajustar detalles finos de los modelos:
# 
# Sin intercepto:
lm(log10(HT11 + 1) ~ cTodas + 0, data = hog) 

# Dos variables, sin interacción:
lm(log10(HT11 + 1) ~ cTodas + c1 + 0, data = hog) 

# Dos variables, con interacción:
lm(log10(HT11 + 1) ~ cTodas * c1 + 0, data = hog) 

# Dos variables, con interacción (ídem que el anterior):
lm(log10(HT11 + 1) ~ (cTodas + c1) ^ 2 + 0, data = hog) 

# Dos variables, sin interacción (ídem que ejemplo 2):
lm(log10(HT11 + 1) ~ (cTodas + c1) ^ 2 - cTodas:c1 + 0, data = hog) 

?formula

# Ejercicio 2: regresiones ----
# 
# 1. Hacer regresión de ingreso por hogar vs. tipo de vivienda (c1), con 
#    intercepto

# 2. Ídem que anterior, pero sin intercepto, cómo cambió el resultado? Por qué?
#
# 3. Determinar los p-valores de los coeficientes obtenidos
#
# 4. Determinar el R cuadrado del modelo
#
# 5. Realizar la misma regresión, pero agregando la variable d25 (cantidad de
#    personas viviendo en el hogar). Probar con y sin interacción.

# Regresión ponderada ----
# 
# El paquete survey provee de una función para ajustar modelos lineales 
# generalizados a partir del diseño de muestreo, de forma que utiliza valores
# ponderados, en lugar de simplemente tomar los casos del muestreo.
# 
# Como siempre, lo primero es construir el objeto diseño de muestreo:
dish <- as_survey_design(hog, strata = c(nomdpto, estred13), weights = pesoano)

# Comparar estos resultados:
lm(log10(HT11 + 1) ~ c1, data = hog)
survey::svyglm(log10(HT11 + 1) ~ c1, design = dish)

modelo <- survey::svyglm(log10(HT11 + 1) ~ c1, design = dish)

s <- summary(modelo)

modelo$coefficients
s$coefficients
s$coefficients %>% class
s

# Ejercicio 3: regresiones ponderadas ----
#
# Realizar varias regresiones ponderadas entre log10(H11 + 1) y cTodas, cada una
# para uno de los siguientes casos:
# 
# a. Montevideo
#
# b. Canelones, Florida, Durazno, Flores, San José, Soriano, Colonia, Río Negro
#
# c. Artigas, Salto, Paysandú, Tacuarembó, Rivera
#
# d. Lavalleja, Maldonado, Rocha, Treinta y Tres, Cerro Largo

# En cada caso, guardar los coeficientes de intercepto y pendiente, así como los
# valores de R cuadrado. Armar una tabla indicando:
#
# - Zona (a, b, c, d) 
# - Intercepto 
# - Pendiente 
# - R cuadrado
