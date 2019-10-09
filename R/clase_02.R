# Capacitación de R: nivel USUARIO
# Clase 2: Objetos de R
# Autor: Juan Manuel Barreneche Sarasola
# **************************************

# Poli ----
# Ejemplo de clase anterior: polinomio de tercer grado: x^3 - 4x^2  + 2x + 1
#
# En ese ejemplo usamos estos dos comandos en repetición, usando las flechas
# arriba y abajo del teclado, para probar la salida del polinomio para distintos
# valores de x:
x <- 2
x ^ 3 - 4 * x ^ 2 + 2 * x + 1

# Ahora voy a aprovechar que en R me permite definir mis propias funciones, de
# forma que puedo hacer el mismo proceso pero en 1 sólo paso...
p <- function(x) x ^ 3 - 4 * x ^ 2 + 2 * x + 1

# Y entonces... voilà!
p(2)
p(1)
p(-.5)

# Puede explicar con sus propias palabras qué fue lo que ocurrió aquí? Escriba
# su explicación aquí:


# Fin de la explicación ------------------------------+

# I Vectores atómicos ----
#
# Se trata de secuencias de elementos de un mismo tipo. En otros lenguajes se
# pueden llamar arreglos o listas. En R esos términos tienen otro significado.
#
# En R, los vectores son el tipo de dato más simple (un valor único también es
# técnicamente un vector). La función concatenación es una forma sencilla de
# armar un vector nuevo:
x <- c(10, 5, -3)

# Ahora, qué viene a ser aquello de que es "atómico"? Pues que todos los
# elementos del vector son del mismo tipo.
#
# I.a Tipos y clases ----
#
# Qué es un "tipo"? (en inglés: data type)
#
# Una forma de extraer esta información es con la función typeof, aunque el
# resultado nos habla de el modo de almacenamiento en la memoria del objeto...
# en otras palabras, es jerga informática interna que la mayoría de las veces no
# usaremos.
typeof(x) # double = número con decimales

# Por otro lado, también existe la función class, que nos devuelve algo
# diferente en este caso:
class(x)

# Los tipos o clases de objeto se pueden evaluar y modificar con ciertas
# funciones, identificables por los prefijos is. y as.
#
# Como ejemplo, escriba estos prefijos (con punto y todo) y observe las
# sujerencias de autocompletado que muestra RStudio...
is.double(x)
is.numeric(x)
is.atomic(x)
is.integer(x) # integer = entero

# Observe qué ocurre ahora con estos comandos:
x <- as.integer(x)
typeof(x)
class(x)
is.double(x)
is.numeric(x)
is.atomic(x)
is.integer(x)

# Las clases de objetos son muy importantes y ya vimos algunos ejemplos que dan
# pista de por qué:
#
# ** La clase/tipo de un objeto determina cómo va a interactuar con el resto del
#    ecosistema de R **

# Determine cuáles son las clases de los siguientes vectores:
1:3                 # clase: 
c(1, 2, 3)          # clase:
c(1L, 2L, 3L)       # clase:
c("1", "2", "3")    # clase:
c(TRUE, FALSE, NA)  # clase:
NA                  # clase:
NA_character_       # clase:
NULL                # clase:
x > 0               # clase:

# I.b Extraer y modificar elementos ----
# 
# Para esta sección, vamos a crear un nuevo x, el cual tendra "nombres":
x <- c(a = 10, b = 5, c = -3, d = 44)
names(x)

# Nota: a esta altura de la clase, es necesario recomendar que siempre la
# configuración de teclado más adecuada para programar es aquella que se
# corresponde con lo que está impreso en las teclas de nuestro teclado. En otras
# palabras, si el teclado está diseñado para escribir en español
# (latinoamerica), configurar el teclado a español (latinoamerica). La razón es
# que vamos a estar utilizando con frecuencia caracteres "raros", como:
#
# [ ] | \ & ^ $ % # @ ! ~ ``

# Utilizando los paréntesis rectos o corchetes podemos extraer o modificar un
# elemento. Ejemplo:
x[1]
x[1] <- 77

# Notar que solamente el segundo comando afectó a x:
x

# Bien, parece sencillo en este caso... Ahora, experimente con variantes de este
# formato, incluyendo ejemplos debajo de cada ítem:
#
# 1. En vez de usar un único número, usar varios números entre los corchetes.
 
# 2. Usar número(s) negativos
 
# 3. Usar el cero
 
# 4. Usar números con decimales
 
# 5. Usar valores muy grandes

# 6. Usar valores no numéricos

# A continuación pongo muchos ejemplos que, espero, sean ilustrativos de los
# comportamientos de los corchetes:
x[0]
x[2:3]
x[c(2, 4)]
x[3:4] <- c(-9, 9); x # Al usar ; estoy ejecutando 2 sentencias en 1 línea
x[4:2]
x[4:2] <- 505; x
x[1:3] <- c(-1, 4); x
x[6]
x[6] <- -11; x
x[-3]
x[c(-3, 4)]
x[2.3]
x[-2.3]
x["a"]
x[c("b", "d")] <- c(34, 99); x

names(x)
names(x) <- c("a", "b", "c", "d", "e", "f"); x
names(x)[3] <- "z"; x

x[c(TRUE, TRUE, FALSE, FALSE, TRUE, TRUE)]
x[x > 10]
x[c(TRUE, FALSE, TRUE, FALSE, FALSE, FALSE)] <- rnorm(2); x
x[x > 10] <- rnorm(2) # Esto da error si hay NA

# Recordar que para trabajar con NA, hay que tener en cuenta ciertas reglas
# especiales. En particular, considere estos dos vectores lógicos:
x > 10    # Contiene 1 NA
is.na(x)  # Este en cambio no tiene ningún NA
!is.na(x) # Ídem que el anterior, pero invertido (efecto de agregar !)

# Para evitar el problema del NA, una opción es usar el & para combinar dos vectores lógicos y el ! para invertir los valores de is.na(x):
x[x > 10 & !is.na(x)] <- rnorm(2)
x

# También es importante tener en cuenta que cuando insertamos un valor que
# corresponde a otra clase, el resultado puede sorprendernos (y no vamos a
# recibir mensaje de error):
x[3] <- "7"; x # Inserto un valor character
class(x)

# El criterio que sigue R en estas situaciones, parecería ser "no perder
# información". Veamos otro ejemplo:
x <- as.integer(x)
x[3] <- TRUE # Inserto un valor logical
class(x)

# Por último, no está de más mencionar el doble corchete:
x[[5]]

# El doble corchete siempre devuelve o modifica un único elemento:
x[[1:3]]

# Hay algún detalle más que queda sin explorar en estos ejemplos. La ayuda es un
# buen lugar en donde empezar:
?Extract
# o
?"["

# -------------------------+
# Nota: TRUE y FALSE se comportan como 1 y cero respectivamente, en operaciones 
# numéricas (multiplicación, suma, etc...):
TRUE == 1
FALSE == 0

# Es por esta razón que es posible hacer un conteo de los valores de x que son
# mayores que 0, de esta manera:
sum(x > 0, na.rm = TRUE) # na.rm funciona igual que con la función mean
# -------------------------+

# I.c Operaciones ----
#
# Creamos un nuevo x:
x <- c(3, -4, 12, NA, -7)

# Las operaciones con vectores son muy simples. Por ejemplo, considere el caso
# de multiplicar a todos los elementos de x por 2:
x * 2

# Observación: esta multiplicación es un ejemplo de lo que llamamos
# vectorización. Es decir, se trata de una operación que se repite elemento por
# elemento, pero se realiza "tras las cortinas", implícitamente. La alternativa
# a la vectorización es el caso de la mayoría de los lenguajes de programación
# tradicionales: el uso de loops o bucles.
# 
# El siguiente es un ejemplo ilustrativo.
# 
# Con vectorización:
y1 <- x * 2
# Sin vectorización:
y2 <- numeric()
for (i in 1:length(x)) y2[i] <- x[i] * 2

# Comparemos:
y1 == y2
all.equal(y1, y2)
identical(y1, y2)

# Así como podemos multiplicar, hay varias otras operaciones que se pueden
# hacer.
#
# División:
x / 5

# Elemento por elemento:
x + 100:104
x + 100:105 # Qué ocurre aquí?

# Raíz cuadrada:
sqrt(x) 

# Qué es NaN?

# Potencia:
2 ** x
x ** 2

# Logaritmos
log(x)
log2(x)
log10(x)
log(x, 9)

# Exponencial
exp(x) # Conoce esta notación? 2.1e04 = 2.1 * 10 ^ 4

# Sumatoria
sum(x, na.rm = TRUE)

# Productoria
prod(x, na.rm = TRUE)

# Promedio, desvío estándar, varianza...
mean(x, na.rm = TRUE)
sd(x, na.rm = TRUE)
var(x, na.rm = TRUE)

# Observación: en los últimos 5 casos se usaron funciones que generan un único
# número. Llamaremos a eso "agrupación" o funciones resumen (summary function),
# para diferenciarlas de las funciones que devuelven tantos elementos como tenía
# el vector original: funciones vectorizadas (vectorized functions).
#
# (Es un poco desafortunado que se use el término vectorización aquí también,
# porque no necesariamente tiene por qué significar lo mismo. De todas formas,
# es un detalle menor.)

# Matrices ----
# 
# (En verdad, también son vectores, pero encubiertos)
# 
# Si los vectores son 1D, las matrices son 2D:
matrix(0, nrow = 3, ncol = 4)
m <- matrix(0, nrow = 3, ncol = 4)
class(m)
is.numeric(m)

# Al igual que los vectores, pueden ser de diferentes tipos, pero todos los
# elementos tienen que ser del mismo:
m <- matrix("0", nrow = 3, ncol = 4)
class(m)
is.numeric(m)
is.character(m)

# El uso de los corchetes es muy similar, sólo que ahora se agrega una
# dimensión, lo cual es representado separando las filas y las columnas con una
# coma:
m <- matrix(c(1:6 + 3, 1:6 - 8), ncol = 4)
m[3, 1]
m[3, 1] <- 7
m[1, 2] <- -10

# Ejercicio 1 ----
#
# Reproducir la siguiente matriz, utilizando el comando matrix:

#      [,1] [,2] [,3] [,4]
# [1,]    1    2    3    4
# [2,]    5    6    7    8
# [3,]    9   10   11   12

# (Consejo: use la ayuda para aprender más de la función matrix.)

# -----------------------------+

# Observe lo siguiente:
m[5]

# Cómo determina R qué valor corresponde a m[5]?

# También aparece ahora la opción de elegir filas enteras o columnas enteras:
m[1,]
m[,1]

# Debe 
is.matrix(m)
is.matrix(m[1,])



m[lo,]
# Notar que dejan de ser "columnas" o "filas"

m[2:3, 3:4]

m[2:3, 3:4] <- matrix(c(5, -5, -5, 5), 2, 2)

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

