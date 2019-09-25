# Clase 8

library(tidyverse)

# Loops ----
#
# * Fibonacci ----
#
# La secuencia de Fibonacci: según una consulta de wikipedia, se define así:
#
# F(1) = 0
#
# F(2) = 1
#
# F(n) = F(n - 1) + F(n - 2)
#
# El siguiente código reproduce esta secuencia, usando una sintáxis que hasta
# ahora no había mostrado:

fibo <- numeric(20)

fibo[2] <- 1

for (i in 3:20) {
  print(i)
  fibo[i] <- fibo[i - 1] + fibo[i - 2]
}

# Gráfico estándar:
plot(fibo)

# ggplot2:
tibble(fibo, i = 1:20) %>% 
  ggplot() + aes(i, fibo) + geom_area(fill = "skyblue") + geom_point()

# Tómese 5 minutos para intentar interpretar lo que hace este código.

# Nota!: la contribución más importante de Fibonacci a la historia de las
# matemáticas es la de traer a la europa medieval las técnicas operatorias (ie:
# algoritmos) utilizados en el mundo árabe, así como los numerales, muchas de
# las cuales conocemos hoy en día. La secuencia en sí aparece en su libro más
# famoso como un simple ejemplo más.

# * for ----
# 
# El concepto de loop, o bucle, está en la base de la programación. Equivale a
# automatizar una tarea repetitiva.
#
# Ejemplo de juguete (no correr!):
for (secuencia_de_valores) tarea

# Si la secuencia_de_valores tiene n elementos, entonces la tarea se ejecutará n
# veces, pero siempre con el iésimo elemento de la secuencia.
#
# En el ejemplo de Fibonacci, la secuencia es 3:20 y el objeto i es quien porta
# con el iésimo valor en cada pasada del bucle.
#
# Tome el siguiente ejemplo y busque interpretar lo que está ocurriendo:

x <- seq(0, 8 * pi, by = .01)
y <- numeric(length(x))

for (i in 1:length(x)) {
  y[i] <- sin(x[i])
}

plot(x, y, type = "l")

# Nota: las llaves { } sirven para delimitar el inicio y fin de una "expresión":
# uno o más comandos de R. Es particularmente útil cuando queremos englobar una
# secuencia de muchos comandos.
#
# Nota 2: este ejemplo se puede hacer sin usar loops. En R las operaciones
# matemáticas básicas hacen loops tras las cortinas. A esto se le llama
# "vectorización", y es más rápida que usar loops, debido al propio diseño de R
# (usa C, C++ o Fortran internamente):
plot(x, sin(x), type = "l", main = "Ahora vectorizando")

# De todas formas, hay que tener en cuenta que una secuencia como la de
# Fibonacci no se puede vectorizar, ya que cada elemento nuevo depende de haber
# calculado los dos elementos anteriores.

# Ejercicio 1 ----
# 
# Se intenta utilizar un loop for para calcular la secuencia descripta por la 
# siguiente ecuación:
# 
#          1
# Z(n) = -----
#           n
#         2 
#         
# El siguiente código está casi completo, pero tiene un par de errores, 
# encuéntrelos!:
z <- numeric(20)

for (i in 1:10) {
  z <- 1 / (2 ** i)
}

plot(1 - z)

plot(cumsum(z))


# Condicionales (if / else) ----
#
set.seed(0)               # Para controlar los números aleatorios
x <- sample(5, 10, TRUE)  # Números aleatorios del 1 al 5
y <- character(length(x)) # Vector vacío para rellenar
for (i in 1:length(x)) {
  if (x[i] >= 3) 
    y[i] <- "alto"
}

tibble(x, y)
table(y)

# Tómese 5 minutos para evaluar lo que está ocurriendo...

# * if ----
#
# El controlador if sirve para evaluar un valor y ejecutar una tarea en función
# de alguna regla que nos interese.
# 
# El esquema básico es:
if (condicion) tarea

# * if + else ----
set.seed(0)               # Para controlar los números aleatorios
x <- sample(5, 10, TRUE)  # Números aleatorios del 1 al 5
y <- character(length(x)) # Vector vacío para rellenar
for (i in 1:length(x)) {
  if (x[i] >= 3) {        # Condición
    y[i] <- "alto"
  } else {                # En otro caso:
    y[i] <- "bajo"
  }
}

tibble(x, y)
table(y)

# Ejercicio 2 ----
#
# El siguiente loop es utilizado en combinación con dos if+else consecutivos,
# pero no está haciendo bien su trabajo. El objetivo es clasificar los valores
# del 1 al 5 como "bajo", del 6 al 10 como "medio" y del 11 al 15 como "alto".
#
# Encuentre el (único) problema con el código:
 
set.seed(0)               # Para controlar los números aleatorios
x <- sample(15, 20, TRUE) # Números aleatorios del 1 al 15
y <- character(length(x)) # Vector vacío para rellenar
for (i in 1:length(x)) {
  if (x[i] >= 11) {       # Condición
    y[i] <- "alto"
  } else if (x[i] < 6) { # En otro caso:
    y[i] <- "medio"
  } else {               # En otro caso:
    y[i] <- "bajo"
  }
}

tibble(x, y)
table(y)

# Otros controladores de flujo -----
# 
?"for"

# * while ----
# 
# Es otro tipo de loop, pero que se detiene solamente cuando se cumple con una condición:
# 
while (condicion) tarea

# Ejemplo: while
# 
# Iniciación:
z <- numeric(2000)
z[1] <- 1
i <- 1
while (z[i] > .001) {  # Condición que sé que se va a cumplir
  i <- i + 1           # Debo modificar i manualmente
  z[i] <- 1 / (2 ** i) # Cálculo de Z(i)
}
z <- z[1:i]            # Recortar z

plot(z)

# * break ----
# 
z <- numeric(2000)
z[1] <- 1
for (i in 1:length(z)) {  
  z[i] <- 1 / (2 ** i) # Cálculo de Z(i)
  if (z[i] <= .001)     # Condición de quiebre
    break              # Cortar el loop si se cumple la condición
  }
z <- z[1:i]            # Recortar z

plot(z)

# * next ----
# 
set.seed(0)                     # Para controlar los números aleatorios
x <- sample(5, 10, TRUE)        # Números aleatorios del 1 al 5
y <- rep.int("bajo", length(x)) # Vector lleno a modificar
for (i in 1:length(x)) {
  if (x[i] >= 3) {        # Condición
    y[i] <- "alto"
  } else {                # En otro caso:
    next                  # Saltamos al siguiente elemento
  }
}

tibble(x, y)
table(x, y)


# Funciones ----
#
# Cuando el objetivo es programar, la creación de funciones es de enorme
# utilidad.
#
# Una función es la forma de ejecutar una tarea una y otra vez sin tener que
# escribir todo el código una y otra vez.
# 
# 
library(haven)
hog <- read_sav("datos/ECH2018/H_2018_TERCEROS.sav")

# Por ejemplo, para tomar información de una columna de la tabla de hogares, una
# forma es usar la función attributes:
attributes(hog[["c1"]])

# Pero a mi no me interesan toda esta info, sino específicamente esto:
attributes(hog[["c1"]])$label
attributes(hog[["c1"]])$labels

# A partir de estos comandos, hago esta función:
vercol <- function(columna) {
  print(attributes(hog[[columna]])$label)
  print(attributes(hog[[columna]])$labels)
}

vercol("c1")
vercol("region_3")

# Bastante bien... aunque ya que hago una función, prefiero hacer algo un poco
# más lindo:
vercol <- function(columna) {
  print(attributes(hog[[columna]])$label)
  eti <- attributes(hog[[columna]])$labels
  
  tibble(Valor = eti, Codigo = names(eti))
}

vercol("c1")
vercol("region_3")

# Nota: eti no "existe" en nuestra sesión de trabajo...
eti

# Esto es porque los objetos creados dentro de la definición de la función sólo
# existen durante la ejecución del código (un brevísimo instante).
#
# Lo otro importante a destacar es que el código interno termina con un objeto
# tipo tabla. Este será la salida de la función:
salida <- vercol("c1")
salida

# Comportamiento extraño verdad? El asunto es que  lo que imprime en la consola
# no necesariamente es lo mismo que la función devuelve.
#
# El siguiente código busca hacer más coherente la salida de la función con lo
# que imprime:

vercol <- function(columna) {
  egral <- attributes(hog[[columna]])$label
  eti <- attributes(hog[[columna]])$labels
  
  list(
    `Etiqueta general` = egral,
    `Códigos` = tibble(Valor = eti, Codigo = names(eti))
  )
}

vercol("c1")
salida <- vercol("c1")
salida

# Ahora, veamos lo que ocurre si cambio el nombre de hog:
th <- hog
rm(hog)
vercol("c1")

# Por qué ocurre esto?
#
# Ejercicio 3 ----
#
# Qué cambios debo hacer a la función para que funcione siempre, sin importar el
# nombre de la tabla?



# *************************

# Respuestas -----

# Ejercicio 1:
z <- numeric(20)

for (i in 1:20) {
  z[i] <- 1 / (2 ** i)
}

plot(1 - z)

plot(cumsum(z))

# *************************

# Ejercicio 2:

set.seed(0)               # Para controlar los números aleatorios
x <- sample(15, 20, TRUE) # Números aleatorios del 1 al 15
y <- character(length(x)) # Vector vacío para rellenar
for (i in 1:length(x)) {
  if (x[i] >= 11) {       # Condición
    y[i] <- "alto"
  } else if (x[i] < 6) { # En otro caso:
    y[i] <- "bajo"
  } else {                # En otro caso:
    y[i] <- "medio"
  }
}

tibble(x, y)
table(y)

# Ejercicio 3:
vercol <- function(tabla, columna) {
  egral <- attributes(tabla[[columna]])$label
  eti <- attributes(tabla[[columna]])$labels
  
  list(
    `Etiqueta general` = egral,
    `Códigos` = tibble(Valor = eti, Codigo = names(eti))
  )
}

vercol(tabla = th, columna = "c1")
