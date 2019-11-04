# Capacitación de R: nivel USUARIO (2)
# Clase 4: Survey y srvyr (en construcción)
# Fecha: 2019-11-04
# Autor: Juan Manuel Barreneche Sarasola
# **************************************
library(tidyverse)
library(haven)
install.packages("srvyr")
library(srvyr)

# Paquete survey ----

# El paquete srvyr es una adaptación del paquete altamente utilizado y popular
# survey. El funcionamiento se basa en la definición de un objeto del tipo
# "survey design" (diseño de encuesta o muestreo), el cual es una forma de
# indicar cómo se realizó el muestreo:
#
# Cual es la estratificación, cuáles son los clusters, cuál es el factor de
# corrección poblacional (fpc) y cuáles son las ids de las observaciones:
?svydesign

# La sintaxis de los argumentos de svydesign es la de las fórmulas en R:
dis <- svydesign(ids = ~1, # IDs de los clusters (obligatorio). 1= s/cluster
                 strata = ~nomdpto + estred13, # Estratificación
                 weights = ~pesoano, # Pesos
                 data = hog) # Datos de origen

# Puede ver un poco más sobre la sinatxis de las fórmulas (usadas en muchos
# contextos, incluyendo regresiones lineales, gráficos, etc):
?formula

# A partir de aquí, dis es un objeto que sustituye a la tabla de datos. La
# diferencia con los datos originales es que contiene la información del diseño
# de muestreo, la cual será utilizada por funciones del paquete survey para
# hacer cálculos ponderados. Ejemplo:
svymean(~HT11, dis) # Ingreso promedio por hogar para todo el país

# Encuentre las similitudes con:
weighted.mean(hog$HT11, hog$pesoano)

?weighted.mean # Este viene con R de base

# Más sobre survey:

# Cálculos de promedios, covarianzas, cocientes y sumas ponderadas con survey:
?svymean

# Cálculos agrupados (similar a group_by, pero nativo de survey):
?svyby

# Tablas de contingencia:
?survey::ftable
example(ftable)

# * Ejercicio 1: ----
# 
# Importar la tabla de personas (per).
# 
# Definir un objeto de diseño de muestreo con svydesign, el cual no tenga
# clusters ni estratos, pero que los pesos estén indicados correctamente.
# 
# Calcular la edad promedio ponderada para todo el país, utilizando svymean.
#
# Respuestas: ─────────────────────


# ─────────────────────────────────


# Paquete srvyr ----
#
# Una adaptación de survey a un formato amigable con tidyverse: de fondo está
# usando el survey.
# 
browseURL("https://cran.r-project.org/web/packages/srvyr/vignettes/srvyr-vs-survey.html")

# Para definir un diseño igual que el que habíamos hecho hoy, lo que cambia es
# que ya no usamos las fórmulas:
dis <- 
  hog %>% # Los datos originales
  as_factor %>% # Convertir a factores las columnas codificadas
  as_survey_design(ids = 1, # IDs de clusters (1 = s/cluster)
                   strata = c(nomdpto, estred13), # Estratos
                   weights = pesoano) # Pesos

# Una consecuencia de que tiene el uso de srvyr y no de survey, es que podemos
# aplicar funciones del tidyverse al objeto creado:
dis %>% 
  select(anio:pesomen, starts_with("c"), d25, HT11) %>% 
  filter(HT11 > 1.5e6)

# Lo malo es que no podemos ver los datos directamente... La solución puede ser
# mirar los datos originales (tabla hog), pero tenga en cuenta que los datos
# también están contenidos en el objeto dis...
#
# Dónde exactamente?
View(dis) # Método moderno

# Métodos ancestrales:
names(dis) 
sapply(dis, class)
str(dis)

# Entonces, podemos hacer esto:
dis %>% 
  select(anio:pesomen, starts_with("c"), d25, HT11) %>% 
  filter(HT11 > 1.5e6) %>% 
  .$variables

# No es lo más práctico pero es una opción posible. Hay más funciones tidyverse adaptadas a survey designs, como mutate o rename... ver:
?srvyr

# * Promedios, sumas y otras cosas ----
#
# Cómo veíamos anteriormente, el objeto dis nos permite utilizar las funciones
# que hacen varios cálculos ponderados, más o menos sofisticados, sin estar
# indicando explícitamente cuándo y cómo debe R tomar en cuenta los pesos de
# cada observación.

# Survey mean:
#
# Al tratarse de un paquete orientado a trabajar con tidyverse, hay una
# condición importante y es que se trabaja modificando y/o creando tablas. Una
# consecuencia inmediata es que el promedio ponderado debe calcularse ahora en
# el contexto de un summarise:
dis %>% summarise(media_pond = survey_mean(HT11))
?survey_mean

# Esta es una restricción que no es necesaria usando el paquete survey a secas,
# como ya vimos. Por otro lado, trabajando con datos esto puede facilitar una
# tarea más fluida.

# Notar además que junto con el promedio, survey_mean devuelve el error
# estándar. Esto se puede ajustar con el argumento vartype (ver ayuda):
dis %>% summarise(media_pond = survey_mean(HT11, vartype = "ci"))

# Otra función típica es la suma ponderada:
dis %>% summarise(suma_pond = survey_total(d25))

# Ejercicio 2: -----
#
# Calcular los cuantiles .25, .50 y .75 de ingreso total (HT11) para los hogares
# de la encuesta, usando survey_quantile.
# 
# Respuestas: ─────────────────────


# ─────────────────────────────────

# + GROUP BY ----

# Una de las ventajas e usar tidyverse es el uso de group_by para hacer cálculos
# agrupados:

dis %>% 
  mutate(ingpers = HT11 / d25) %>% 
  group_by(dpto) %>% 
  summarise(n = survey_total(d25),
            media_ingpers = survey_mean(ingpers)) %>% 
  arrange(desc(media_ingpers))

# El paquete srvyr además viene con una variante de summarise, con la cual se
# agregan los totales de cada grupo, llamada cascade:
dis %>% 
  group_by(dpto) %>% 
  cascade(n = survey_total(d25))

dis %>% 
  group_by(dpto, region_4) %>% 
  cascade(n = survey_total(d25))

# Nota: la función survey_ratio...
?survey_ratio
# Es decir, no es lo mismo hacer
dis %>% summarise(ingpers = survey_ratio(HT11, d25))

# que
dis %>% summarise(ingpers = survey_total(HT11) / survey_total(d25))

# que
dis %>% mutate(ingpers = HT11 / d25) %>% 
  summarise(ingpers = survey_mean(ingpers))

# Ejercicio 3: ----
#
# a. Calcular la cantidad de personas viviendo en los distintos tipos de hogar
#    (c1), por departamento.
#    
# b. Agregar al cálculo anterior, el promedio de ingresos de cada tipo de hogar
#
# c. Ordenar por Departamento + Ingreso descendiente
# 
# d. Agregar el porcentaje de personas en cada tipo de casa, por departamento


# Unir tablas ----

t1 <- tribble(
   ~x, ~y,
   "A", 4,
   "B", 12, 
   "C", 43
   )

t2 <- tribble(
  ~x, ~Y, ~z,
  "B", 12, .1,
  "D", -9, .3,
  "F", 5, .5
  )

t3 <- tribble(
  ~w, ~u,
  "alfa", TRUE,
  "beta", FALSE
  )

left_join(t1, t2)
left_join(t1, t2, by = "x")
left_join(t1, t2, by = c("x", "y" = "Y"))
inner_join(t1, t2, by = c("x", "y" = "Y"))
semi_join(t1, t2, by = c("x", "y" = "Y"))
anti_join(t1, t2, by = c("x", "y" = "Y"))


full_join(t1, t2)
full_join(t1, t2, by = c("x", "y" = "Y"))


# Supongamos que me interesa unir 
# 
source('~/Dropbox/R/OPP_R_usuario/R/codac.R', encoding = "UTF-8")





### Respuestas
### 
### 
### Ejercicio 1
per <- read_sav("datos/ECH2018/P_2018_TERCEROS.sav") 

disper <- svydesign(~1, weights = pesoano, data = per)

### Ejercicio 2
### 
qu <- 
  dis %>% 
  summarise(q = survey_quantile(HT11, quantiles = c(.25, .5, .75)))

### Extra:
bind_cols(
  qu %>% pivot_longer(1:3) %>% select(-1:-3),
  qu %>% pivot_longer(4:6) %>% select(-1:-3)
)

### Ejercicio 3
### 
dis %>% 
  group_by(dpto, c1) %>%
  summarise(n = survey_total(d25), # a
            mean_ht11 = survey_mean(HT11)) %>% # b
  arrange(dpto, desc(mean_ht11)) %>% # c
  group_by(dpto) %>%
  mutate(p = 100 * n / sum(n)) # d

