# Capacitación de R: nivel USUARIO
# Clase 1: Objetos de R
# Autor: Juan Manuel Barreneche Sarasola
# **************************************

# ADVERTENCIA: la clase contiene apuntes incompletos.

# Vectores ----
# Secuencias de elementos de un mismo tipo
x <- c(10, 5, -3)
x * 2 # vectorización
# loops sería la alternativa
x[1]
x[2:3]
x[3:2]
x[4]  #?
x[-1] #?

x[1] <- 11
x[c(1, 3)] <- c(10.5, -4)

names(x)
names(x) <- c("Caro", "Barato", "Evaluacion")
x
class(x)
x["Caro"]

x > 4
class(x > 4)
x[x > 4]

lo <- c(FALSE, TRUE, FALSE)
x[lo]

length(x)

# Matrices ----
# 
# (En verdad, también son vectores, pero encubiertos)
# 
# Si los vectores son 1D, las matrices son 2D:
matrix(0, nrow = 3, ncol = 4)

m <- matrix(0, nrow = 3, ncol = 4)
class(m)
is.numeric(m)

m <- matrix("0", nrow = 3, ncol = 4)
class(m)
is.numeric(m)
is.character(m)

m[3, 1]
m[3, 1] <- 7
m[1, 2] <- -10
m[3]
m[4]

m[1,]
is.matrix(m)
is.matrix(m[1,])
m[,1]
m[lo,]
# Notar que dejan de ser "columnas" o "filas"

m[2:3, 3:4]

m[2:3, 3:4] <- matrix(c(5, -5, -5, 5), 2, 2)
# Desmenuzar este comando...

matrix(c(5, -5, -5, 5), 2, 2)

fil_col <- cbind(c(3, 1, 3, 2), 1:4)

m[fil_col]

class(fil_col)

# **************************
# Cómo obtener los mismos elementos de m, pero en vez de usar una matriz como fil_col, usar un vector (1D)?
# Respuesta:
m[c(3, 4, 9, 11)]
# **************************

# * Nombres ----
colnames(m)
rownames(m)

rownames(m) <- c("a", "b", "c")

# * Operaciones ----
m + 4
m * -1
t(m) # Transpuesta

m2 <- m %*% t(m)
?"%*%"

# * Recilado ----
matrix(1:2, 2, 6)
matrix(1:5, 2, 6)
matrix(1:5, 2, 6, byrow = TRUE)

# * Arreglos ----
# 
# Son como los vectores en nD...
?array
example(array)

# Clases comunes -----

# En algunos de los comandos anterriores se entrevee que las columnas tienen
# distintas clases. Las clases son categorías en las que clasificamos los tipos
# de información. Algunos ejemplos son:

# - Numéricos

# - Texto ("character")

# - Factores (algo así como niveles o tratamientos en un experimento, por 
# ejemplo...)

# - Fecha y hora

# Las clases de los objetos en R son **muy importantes**, ya que determinan cómo
# van a comportarse en diferentes situaciones:
x <- 1
x + 1
x <- c(1, 3, 5)
x * 5 # Multiplica a todos al mismo tiempo
x <- c("coco", "mango", "papaya")
x * 5
x <- c(1, 3, "5") # ¿Y esto?

# Este último ejemplo es paradigmático, ya que nos muestra como R puede
# "mezclar" dos clases diferentes sin dar mensaje de error o avisar. Lo que
# muchas veces ocurre es que aparece un error mucho más adelante, cuando
# queremos usar un objeto creado de esta forma:
x * 5
# Error in x * 5 : non-numeric argument to binary operator

# Es parte de diseño de R y tal vez responda a alguna lógica en particular, pero
# lo cierto es que puede generar fuertes dolores de cabeza. De hecho, muchas
# veces cuando tenemos un error, es buena idea analizar cuáles son las clases de
# los objetos que estamos utilizando.

# Obs.: usamos la función `c`, que sirve para concatenar elementos y formar un
# vector. Los vectores son secuencias de elementos de la misma clase.

# * Números -----

# - numeric, ingeter: números
x <- 1:6 # integer

class(x) # Esta función es muy útil

x[6] <- 5.1 # numeric

class(x) 
# Por qué cambió?
# double
# float

# * Texto -----
txt <- c("coco", "mango", "papaya")
paste(1:3, ". ", txt)

# Qué hizo esta función? La pongo aquí porque es bastánte útil en general (ver 
# ?paste).

# * Lógicos ----
# 
# Booleanos
# 
# - lógica: vectores cuyos valores son TRUE o FALSE
x > 4
x >= 4
x < 2
logico <- x == 4
logico + 1
logico * -5
sum(logico)
!logico
# Ya vimos que los vectores lógicos sirven para filtrar elementos de un vector... esto es de gran utilidad para trabajar con tablas.
u <- matrix(logico, 3, 5)
!u
# Es interesante poder combinar los operadores lógicos
x > 4 | x <= 3 # Esto es un OR
x > 4 & x <= 3 # Esto es un AND (por qué son todos falsos?)
x < 4 & x >= 3 # Complemento del penúltimo ejemplo

x[1] < 4 && x[6] > 5
x[1] < 4 || x[6] > 5


# * Factores ----
# 
# Secuencias de valores que expresan variables categóricas, muy al estilo tratamientos de un experimento controlado.
f <- factor(x = c(4, 1, 1, 1, 2, 2, 1, 4, 3, 1, 1, 2, 2, 3, 1, 2), 
            labels = c("primaria", "secundaria", "terciaria", "posgrado"))
f

# * Fecha y hora ----
# 
# fecha: Date
# fecha+hora (Date, POSIXct o POSIXt)
d <- as.Date("2019-09-04")
d
class(d)

library(lubridate)
ymd("2019/09/04")
dmy("04-9-2019")
mdy("09/04-2019")

d_t <- as.POSIXct("2019-09-04 08:59:23", tz = "America/BuenosAires")
class(d_t)

ymd_hms("2019-09-04 08:59:23")
ymd_hm("2019-09-04 08:59")

?ymd

# * Listas ----
m <- matrix(0, 3, 4)
m[c(3, 4, 8, 9, 11, 12)] <- 
  c(7, -10, 5, -5, -5, 5)
( propios <- eigen(m[,-4]) )

?eigen

# El objeto propios es una lista (tipo S3). Se pueden ver las entrañas de varias maneras:

class(propios)
is.list(propios)

propios[1]
propios[[1]]
propios[[2]]

class(propios[1])
class(propios[[1]]) # Números complejos
class(propios[[2]])

propios[[1]][2:3]

# El operador "$"
?"$"

propios$values

propios$vectors

unlist(propios)

nueva_lista <- list(a = rnorm(2), b = matrix(c(1, 0, 0, 1), 2, 2))

nueva_lista$c <- ymd("2001-01-01")

nueva_lista[[4]] <- "Texto aleatorio"

names(nueva_lista)

names(nueva_lista)[4] <- "desc"

# * * Regresión lineal ----
# 
# Un ejemplo clásico de lista...

example(lm)

lm.D9
str(lm.D9)
names(lm.D9)

lm.D9$coefficients

lm.D9[1]
lm.D9[[1]]

# Tablas -----

# * data.frame ----
# 
# - data.frame: tablas de datos, formato clásico de R:
class(iris)
dim(iris)

set.seed(0)
midf <- data.frame(
  nivel_educativo = f,
  fecha_egreso = ymd(paste0("2009-10", rpois(16, 15))),
  nota = rnorm(length(f), mean = 60, sd = 17)
)

midf
head(midf)
midf[1:3,]
midf[1:3]

midf$nota # Las data.frames son listas...
class(midf$nota)

lm(nota ~ nivel_educativo, data = midf)
plot(nota ~ nivel_educativo, data = midf)

library(ggplot2)
ggplot(midf) +
  aes(x = nivel_educativo, y = nota) +
  # geom_point() +
  # geom_jitter()
  geom_boxplot()

# - tibble: una versión de las tablas que propone el paquete tibble (tidyverse).
library(tibble)
iris
iris2 <- as_tibble(iris)
iris2[3:6, 2] <- NA
iris2[6:8, 3] <- -iris2[6:8, 3]
iris2
head(iris, 10)
iris[,3]
iris2[,3] # No deja de ser tibble

class(iris2)

# Tampoco deja de ser data.frame

tribble(
  ~a, ~b,
   2, TRUE,
   3, FALSE,
  -1, FALSE,
   5, TRUE)

#### 
#### Qué hace esta función? De qué clase es la salida de la misma?
is.numeric(x)
is.character(x)
#### 
#### 

# Importar datos ----

# En el botón import dataset tendremos muchas opciones, que van a depender de qué paquetes están instalados en el sistema...
# En mi PC tengo la opción del readr que es un paquete bastante bueno, así que lo voy a usar:
library(readr)
pqts <- read_csv(
  "datos/paquetes.csv", 
  col_types = cols(first_release = 
                     col_datetime(format = "%Y-%m-%d %H:%M:%S")))

# Más adelante veremos qué hacemos con estos warnings
# 
# La función cols puede ser de mucha ayuda...
?cols

# De todas formas, es bueno saber que R tiene la función read.table, que lee cualquier archivo en texto plano (txt, csv, dat), si le indicamos cuál es el separador correcto. Algunas funciones como read.csv son wrappers de read.table hechas para ahorrar tiempo.
?read.table

# Nota: cuando use read.table o read.csv, etc., tener en cuenta que los campos de texto son ingresados como factores, lo que puede generar confusiones, malestar y mareos. El argumento stringsAsFactors = FALSE es una buena opción para evitar tal transformación:
# pqts <- read.csv("datos/paquetes.csv", stringsAsFactors = FALSE)

# También se puede leer un archivo desde una URL en la web:
# pqts <- read.csv("https://raw.githubusercontent.com/jumanbar/curso_camtrapR/master/clase_1/data/paquetes.csv")

# Nota: hay formas más primitivas de leer archvos:
readLines("cdo.txt")
scan("datos/numeritos.txt")

# Mirar la tabla por arriba -----

class(pqts)

head(pqts) # La cabeza
tail(pqts) # La cola

dim(pqts)           # Qué dimensiones tiene la tabla pqts (sirve para matrices también)
nrow(pqts)
ncol(pqts)

sapply(pqts, class)
str(pqts)           # Un montón de información sobre pqts
summary(pqts)       # Resumen de todas las columnas

table(pqts$first_release) # Acá uso `$` para llamar a la variable
table(pqts$Camera, pqts$Species)

# Warning: 2 parsing failures.
# row           col                    expected     actual                 file
# 6103 first_release date like %Y-%m-%d %H:%M:%S 2014-03-04 'datos/paquetes.csv'
# 7384 first_release date like %Y-%m-%d %H:%M:%S 2015-02-06 'datos/paquetes.csv'

# Qué hacemos en estos casos? Es decisión de cada uno/a
pqts[c(6103, 7384),]
pqts[c(6103, 7384), 2] <-
  ymd_hms(c("2014-03-04 12:00:00", "2015-02-06 12:00:00"))

table(pqts$versions)
library(tidyverse)
table(pqts$versions) %>% barplot()

# Alternativa: guardar fechas como character y luego modificarlas
pqts2 <- read_csv("datos/paquetes.csv", 
  col_types = cols(first_release = col_character()))
# De esta forma no se pierde información
# 
# Es una alternativa útil cuando arreglar a mano no es una opción (por ejemplo, si la cantidad de mensajes de warning es excesiva). De todas formas, para arreglar la columna de una forma automatizada (o semi), tendremos que adquirir otras habilidades que veremos más adelante.
# 
# Por qué no modificamos directamente la tabla en excel?

# * Datos del ECH ----

# Veremos ejemplos con el .dat y con el .sav

# Exportar datos ----

# Muchas opciones, todas empiezan con write...

write_excel_csv2(pqts, "salidas/paquetes_excel.csv")

# Considerar, que utilizando las funciones de base, generalmente en el archivo se incluye el nombre de las filas, lo cual puede ser molesto.

write.csv2(pqts, "salidas/paquetes2.csv")
# "";"name";"first_release";"versions";"archived";"index"
# "1";"BN";NA;0;TRUE;1
# "2";"DP";NA;0;TRUE;2
# "3";"Rm";NA;0;TRUE;3

# RData ----

save(pqts, file = "salidas/paquetes.RData")

load("datos/hum_got.RData")

# Extras ----

# * Arreglo automatizado ----

pqts2$first_release %>% 
  ymd_hms

w <- grep("[12][90][0-9]{2}-[01][0-9]-[0-3][0-9]", pqts2$first_release)
length(w)
nrow(pqts2)

pqts2[-w,]
w <- grep("[12][90][0-9]{2}-[01][0-9]-[0-3][0-9]$", 
          pqts2$first_release)
length(w)
pqts2[w,]
pqts2$first_release[w] <- 
  paste(pqts2$first_release[w], "12:00:00")

pqts2$first_release <- ymd_hms(pqts2$first_release)

pqts2 <- mutate(pqts2, first_release = ymd_hms(first_release))

# Algunos gráficos...

library(tidyverse)
pqts %>% 
  mutate(year = year(first_release)) %>% 
  pull(year) %>%
  table %>% 
  barplot()

pqts %>% 
  mutate(year = year(first_release)) %>% 
  count(year) %>%
  ggplot() +
  aes(year, n) +
  geom_col()

pqts %>% 
  mutate(year = year(first_release)) %>% 
  count(year) %>%
  mutate(nacum = cumsum(n)) %>% 
  ggplot() +
  aes(year, nacum) +
  geom_point()

