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
p
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

print(x)
print.default(x)
print.data.frame(x)

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

# Otra opción es usar la función which:
w <- which(x > 10)
x[w]

# * * Ejercicio 1 ----
# 
# Considere el vector y:
set.seed(0)
y <- rnorm(1e4)
length(y)

# Extraiga los elementos de y de los extremos y guárdelos en un objeto llamado
# z. Es decir, z será un vector que contenga todos los y tales que se cumple al
# menos una de estas condiciones:
# 
# - y es mayor a 1.96
# 
# - y es menor que -1.96
#
# Para esto será necesario utilizar el operador lógico |, equivalente al OR...
# (Pista: la sintaxis es similar a la en el ejemplo anterior al which.)

# Si el resultado es correcto, el porcentaje de valores en los extremos debería
# ser cercano al 5%, por tratarse de una distribución normal estándar.
# 
#  ---------------------------+

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

# II Matrices ----
# 
# (En verdad, también son vectores, pero encubiertos)
# 
# Si los vectores son 1D, las matrices son 2D:
matrix(1:12, nrow = 3, ncol = 4)
m <- matrix(1:12, nrow = 3, ncol = 4)
class(m)
is.numeric(m)
dim(m)
length(m)

# Al igual que los vectores, pueden ser de diferentes tipos, pero todos los
# elementos tienen que ser del mismo:
m <- matrix(c("a", "b"), nrow = 3, ncol = 4)
m # Observe el reciclado de elementos
class(m)
is.numeric(m)
is.character(m)

# El uso de los corchetes es muy similar, sólo que ahora se agrega una
# dimensión, lo cual es representado separando las filas y las columnas con una
# coma:
m <- matrix(c(1:6 + 3, 1:6 - 8), ncol = 4)
m[3, 3]
m[3, 3] <- 7
m[1, 2] <- -10
m[1, 4] <- NA
m

# * * Ejercicio 2 ----
#
# Reproducir la siguiente matriz, utilizando el comando matrix:

#      [,1] [,2] [,3] [,4]
# [1,]    1    2    3    4
# [2,]    5    1    2    3
# [3,]    4    5    1    2

# (Consejo: use la ayuda para aprender más de la función matrix.)


# -----------------------------+


# Observe lo siguiente:
m <- matrix(-2:2, nrow = 3, ncol = 4)

m[5]
m[3:8]

# Cómo determina R qué valor corresponde a m[5]?

# Existe también la opción de elegir filas enteras o columnas enteras:
m[1,]
m[,1]

# Debe tenerse en cuenta, que cuando extraemos una única fila o columna, el
# objeto resultante pierde su condición de matriz:
is.matrix(m)
is.matrix(m[1,])
dim(m[,1])

# Para evitar esto, se puede usar el argumento drop (ver ?Extract):

m[, 1, drop = FALSE] # Única columna
m[1, , drop = FALSE] # Única fila

# Las reglas generales de los corchetes se siguen cumpliendo, incluyendo el uso
# de vectores lógicos:
m[c(FALSE, TRUE, TRUE),]

# Para matrices también sirve la función which, pero con el agregado del
# argumento arr.ind. Los siguientes ejemplos buscan ilustrar la diferencia entre
# usar o no usar arr.ind:
w1 <- which(m >= 0, arr.ind = TRUE)
w2 <- which(m >= 0) # Por defecto: arr.ind = FALSE
w1
w2
is.matrix(w1)
is.matrix(w2)

# Claramente los resultados w1 y w2 son diferentes. Sin embargo estos dos
# comandos devuelven lo mismo:
m[w1]
m[w2]

m[5]

# * Nombres ----
#
# Las matrices pueden tener nombres también, pero serán nombres de filas y/o de
# columnas:
colnames(m)
rownames(m)

rownames(m) <- c("a", "b", "c")
colnames(m) <- c("w", "x", "y", "z")
m
m["b", , drop = FALSE] # Obs.: mantiene los nombres.
m["b", , drop =  TRUE] # Obs.: mantiene los nombres... de las columnas

# * Operaciones ----
#
# Las operaciones con matrices no guardan gran sorpresa
m + 4
m * -1
t(m) # Transpuesta
sum(m)
mean(m, na.rm = TRUE)
colMeans(m) # Mantiene nombres de columnas
rowSums(m)  # Mantiene nombres de filas

# R también incluye la permite la multiplicación matricial, pero debe hacerse con un operadore especial: %*%
m %*% t(m)
?"%*%"

# * Arreglos ----
# 
# Así como pasar de vectores atómicos a matrices es cuestión de agregar una dimensión más, pasar de matrices a arrays ("arreglos"), es como saltar del 2D al 3D, o el 4D... o el nD
?array

# Veamos un ejemplo con 3 dimensiones:
a <- array(1:24, dim = c(4, 3, 2))

# 4 Filas
# 3 Columnas
# 2 "Pisos"
a

# El uso de corchetes sigue un criterio coherente. El orden en que se indican
# las posiciones es el mismo con el que se definen las dimensiones (ver arguento
# dim de array):
a[2, 3, 2]
a[2, 3, 2:1]
a[2, 2:3, 2:1]

# ----------------------------------------------------+

# III Lógicos ----
# 
# También llamados booleanos
# 
# Vectores cuyos valores son TRUE o FALSE
set.seed(0)
x <- rpois(15, 4); x # rpois: valores aleatorios con dist. Poisson lambda = 4
x > 4
x >= 4
x != 7
x < 2
logico <- x == 4; logico # Con ; se pueden ejecutar 2 comandos en la misma línea
logico + 1
logico * -5
sum(logico)
!logico

# Ya vimos que los vectores lógicos sirven para filtrar elementos de un
# vector... esto es de gran utilidad para trabajar con tablas.

# Vimos también que es de utilidad poder combinar los operadores lógicos
x > 5 | x <= 3 # Esto es un OR
x > 5 & x <= 3 # Esto es un AND (por qué son todos falsos?)
x < 5 & x >= 3 # Complemento del primer ejemplo
x > 3 & x < 7 | x == 2 # Se pueden seguir combinando expresiones...
x > 3 & (x < 7 | x == 2) # Atención a los paréntesis (pero no abusar de ellos!)

# En el caso de && y ||, las reglas son las mismas, pero se restringen a
# comparaciones entre vectores de 1 elemento:
x > 3  # 8 TRUE
x <= 5 # 5 TRUE
x > 3 &  x <= 5 # 4 TRUE
x > 3 |  x <= 5 # 15 TRUE
# Observar: que el resultado siempre, hasta ahora, son vectores lógicos de 15
# elementos.

# Ahora en cambio se obtienen resultados de 1 sólo elemento:
x > 3 && x <= 5 # FALSE
x > 3 || x <= 5 # TRUE

# En estos casos R descarta todos los elementos excepto el primero. Es decir, los comandos anteriores son equivalentes a:
x[1] > 3 & x[1] <= 5
x[1] > 3 | x[1] <= 5

# También existe el OR exclusivo:
xor(x >= 4, x <= 6)
# Sólo es verdadero cuando una de las dos expresiones es verdadera, pero es
# falso cuando AMBAS son verdaderas...

# Tabla de operadores lógicos:
# 
# x | y | AND (&) | OR (|) | XOR | NOT x (!x)
# --+---+---------+--------+-----+-----------+
# T | T |   T     |   T    |  F  |     F
# T | F |   F     |   T    |  T  |     F
# F | T |   F     |   T    |  T  |     T
# F | F |   F     |   F    |  F  |     T

# Luego hay otras funciones y operadores para trabajar con vectores enteros:

# El operador %in% funciona como múltiples OR:
x <- c("coco", "damasco")
y <- c("coco", "mango", "durazno")
x %in% y
# Equivale a:
x == y[1] | x == y[2] | x == y[3]

# No es lo mismo A %in% B que B %in% A (ie.: operación *no* conmutativa):
y %in% x
x[x %in% y]
x[y %in% x] # Qué ocurre aquí?

# Ahora, si cambio el orden de las frutas:
x[y[c(2, 3, 1)] %in% x]
# El anterior comando sería equivalente a:
x[3]

# Otras funciones prácticas son all y any. 
# all evalua si todos los valores son TRUE (ie.: es un AND grupal):
x <- 4:8; y <- c(3, -1, 4, 2, 6)
all(x %in% y)
all(x > y)
# Era este el resultado que esperaba? Acaso no hay algunos y que son mayores que
# algunos x?

# La siguiente tablita nos ayuda a entender lo que ocurre:
data.frame(x, y, x_mayor_y = x > y)
# La clave es que x > y compara los valores según las posiciones (1 a 1)

# any evalua si al menos un TRUE en el conjunto (ie.: OR grupal):
any(x %in% y)
any(x <= y)

# * * Ejercicio 3 ----
#
# Una recodificación sencilla.
#
# Considere el vector dpto, que contiene los nombres de departamentos de
# Uruguay. El objetivo es crear un vector llamado zona, el cual tendrá 19
# valores y cada uno indicará la zona a la que pertenece el departamento.
# Empezaremos por el caso más simple e iremos complejizando gradualmente el
# problema.
dpto <- c("Montevideo", "Artigas", "Canelones", "Cerro Largo", "Colonia", 
          "Durazno", "Flores", "Florida", "Lavalleja", "Maldonado", "Paysandú", 
          "Río Negro", "Rivera", "Rocha", "Salto", "San José", "Soriano", 
          "Tacuarembó", "Treinta y Tres")
zona <- character(19)

# 3.a:
# 
# Empecemos con dos zonas.
# 
# A: Montevideo
# 
# B: Resto del país
# 
# Respuesta:

# Nota: la función ifelse es conveniente para estos casos.
# -------------+

# 3.b: 
# 
# Cambiamos un poco la clasificación:
# 
# A: Montevideo
# 
# B: Colonia, San José, Canelones, Maldonado, Rocha
#
# C: Resto del país
# 
# (Consejo: %in%)
# Respuesta:
costa <- c("Colonia", "San José",
           "Canelones", "Maldonado", 
           "Rocha")

zona <- case_when(
  dpto == "Montevideo" ~ "A",
  dpto %in% costa ~ "B",
  TRUE ~ "C"
)

table(zona)
# Nota: la función case_when, del paquete dplyr, puede ser una herramienta muy
# práctica para recodificaciones complejas.
# --------------------+

# 3.c:
#
# Además de las zonas ya definidas, queremos incorporar la variable basalto a la
# equcación:
library(dplyr)
basalto <- c(0, 0, 0, 1, 0, 1, 0, 0, 0, 0,
             2, 1, 2, 0, 2, 0, 0, 2, 0)

# La clasificación final quedaría así:
# 
# A: Montevideo
# 
# B: Colonia, San José, Canelones, Maldonado, Rocha
#
# C: Departamentos en que el basalto es >= 1
#
# D: Resto del país
# 
# Respuesta:

# Nota: acá también es muy útil case_when...
# -----------+

table(zona) -> x

# Extra:
tabla <- data.frame(dpto, basalto, zona)

# IV Texto (character) -----
# 
# El uso de comillas, simples o dobles, denotan un vector character:
txt <- c("comillas dobles", 'comillas simples', 
         "comillas simples 'adentro' de comillas dobles")

# Funciones de gran utilidad para trabajar con texto son: paste, substr,
# strsplit, grep y gsub...
# 
# Aquí veremos ejemplos de algunas de ellas.
# 
# Ver más en: cheatsheet de strings.R o
?character

# IV.a grep y sub ----
#
# Es un grupo de funciones que trabaja con expresiones regulares. Las
# expresiones regulares son herramientas muy poderosas que sirven para detectar
# patrones en cadenas de caracteres.

txt <- c("Aaa", "Aab", "bbc", "BBC", "ccd", "acd", "aa1", "dec")

grep("a", txt)
grep("b", txt)
grep("bc", txt)
grep("bc", txt, ignore.case = TRUE)
grep("c", txt, ignore.case = TRUE, value = TRUE)
grep("c", txt, ignore.case = TRUE, value = TRUE, invert = TRUE)
grepl("c", txt, ignore.case = TRUE)
!grepl("c", txt, ignore.case = TRUE)

# En particular, estos ultimos dos ejemplos son muy útiles para utilizar con
# tablas de datos, ya que nos permiten hacer un filitrado de filas según alguna
# columna de texto.

# En estos ejemplos estamos usando patrones súper simples. Veamos uno un poco
# más abstracto:
txt <- c("alvin87i", "dOn4tell0", "Oli_007e", "jamN98", "ATrueRealm")

grep("[0-9]", txt) # Tienen dígitos
grep("[ou]", txt, ignore.case = TRUE)  # Tienen O o U
grep("n[0-9]", txt, ignore.case = TRUE) # n seguida de un número
grep("^[aeiou]", txt, ignore.case = TRUE)  # empiezan con vocal
grep("[0-9]$", txt) # Termina en un dígito
grep("^[aeiou].*[aeiou]$", txt, ignore.case = TRUE)
# empiezan o terminan con vocal

grepl("^[aeiou].*[aeiou]$", "a452394fjghh7", ignore.case = TRUE)

# Para profundizar:
?grep
?regex

# Un par de ejemplitos con gsub:
gsub("O", "o", txt) # Todas las o en minúsculas
gsub("\\.", ",", "85,453")
gsub("[0-9_]+", "", txt) # Eliminar números y guiones bajos

dir(pattern = "\\.txt$")

# IV.b paste (y paste0) ----
#
# Sirven para pegar textos... paste0 es idéntico a paste, excepto que el
# argumento sep = "". Algunos ejemplos ilustrativos:
paste(1:5, ". ", txt)
paste(1:5, ". ", txt, sep = "")
paste(1:5, ". ", txt, sep = "", collapse = "; ")

# Los caracteres especiales \t y \n
txt2 <- paste(1:5, "\t", txt, sep = "", collapse = "\n")
txt2
print(txt2)
cat(txt2)

# Qué interpreta usted de este resultado?

# * * Ejercicio 4 ----
# 
# Cocos, duraznos y mangos
# 
# Considere el siguiente vector:
frutas <- sample(c("coco", "durazno", "mango"), size = 21, 
                 replace = TRUE)
frutas # Una muestra aleatoria de frutas
# Considere además las funciones table y names (la segunda aplicada a la salida
# de table):
cuantas.frutas <- table(frutas)
cuantas.frutas # Esta es la salida de table
names(cuantas.frutas)
cuantas.frutas["coco"]

# 4.a:
#
# Escriba código en R (usando paste o paste0) que permita generar un vector
# similar al siguiente, aún si no sabemos de antemano cuántas veces se repite
# cada fruto:
ej <- c("Tengo unos 100 cocos", 
        "Tengo unos 99 duraznos", 
        "Tengo unos 50 mangos")

# Respuesta:

# - - - - -
# 4.b:
#
# Cambiar el resultado final a un único texto con la frase:
# 
# "Tengo unos 100 cocos, 99 duraznos y 50 mangos"
#
# Considere utilizar el argumento collapse, de la función paste o paste0:
# 
# Respuesta:

# -----------------------------+


# * Factores ----
#
# Secuencias de valores que expresan variables categóricas, muy al estilo
# tratamientos de un experimento controlado.
f <- factor(x = c(4, 1, 1, 1, 2, 2, 1, 4, 3, 1, 1, 2, 2, 3, 1, 2), 
            labels = c("primaria", "secundaria", "terciaria", "posgrado"))
f
as.ordered(f)
f[1]
f[f == "primaria"]

# Los factores no son character, y esto es importante recordar.
#
# Las funciones de importar tablas de datos tradicionales (read.table,
# read.csv), convierten cualquier columna del tipo texto a factor... Esto puede
# y muchas veces genera, confusiones innecesarias (ver: argumento
# stringsAsFactors en read.table).

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

# Las listas son el otro tipo de vector que existe en R. En el vector atómico
# todos los elementos son de la misma clase, pero en las listas, cada elemento
# tiene libertad de ser de clase o tipo diferente al resto.
x <- list(numerosNormales = rnorm(10), matriz = matrix(1:20, 4), "Salamín")
x

# Observación: los primeros dos elementos se imprimen bajo el nombre, con una $
# antes, pero el tercer elemento sólo tiene un [[3]] antes de los valores.

x[[1]]
x$numerosNormales
x$matriz

# Observación 2: evalúe las siguientes salidas:
x[[3]] # clase :
x[3]   # clase :

# Experimente con estos comandos:
x[[1:2]]
x[[-3]]
x[-3]
x[[4]] <- summary(x$numerosNormales)
x$x <- x
x[[6]] <- x$x

# Imprimir x para ver el maravilloso entrevero que hemos creado:
x
str(x)
names(x)
summary(x) # Habla de Class y Mode
sapply(x, class)

# Nota: recordar que con las comillas podemos acceder a la ayuda de "símbolos":
?"["
?"%in%"
# etc...


# * * Regresión lineal ----
# 
# Un ejemplo clásico de lista...
x <- runif(30, 0, 40)
y <- 11 + x * 1.4 + rnorm(length(x), sd = 15)

modelo <- lm(y ~ x)
modelo
class(modelo)
summary(modelo)
str(modelo)
names(modelo)

modelo$coefficients

plot(modelo$residuals ~ x)

plot(x, y)
plot(y ~ x)
abline(modelo, col = "red")

plot(modelo)

# Tablas -----

# * data.frame ----
# 
# - data.frame: tablas de datos, formato clásico de R:
class(iris)
dim(iris)

library(lubridate)
set.seed(0)
midf <- data.frame(
  nivel_educativo = c("primaria", "secundaria", "terciaria", "posgrado"),
  fecha_egreso = ymd(paste0("2009-10", rpois(16, 15))),
  nota = rnorm(16, mean = 60, sd = 17)
)

midf
head(midf)
midf[1:2,]
midf[1:2]

midf$nivel_educativo # Las data.frames son listas...
class(midf$nivel_educativo)

lm(nota ~ nivel_educativo, data = midf)
plot(nota ~ nivel_educativo, data = midf)

library(ggplot2)
p <- ggplot(midf) + aes(x = nivel_educativo, y = nota)
p + geom_point() + geom_jitter()
p + geom_boxplot()

p <- ggplot(midf) + aes(x = fecha_egreso, y = nota, col = nivel_educativo)
p + geom_point()

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


# Importar datos ----

# En R y otros lenguajes, la forma clásica de importar y exportar datos es el
# uso de archivos de texto plano (.txt, .csv, .dat, .tsv...).

# La función elemental de importar datos es read.table. Típicamente un comando
# de importación requiere algunas especificaciones (ver los argumentos que usa
# aquí).
#
# Lea la ayuda de read.table y piense, para poder importar la tabla contenida en
# el archivo paquetes.csv, qué opciones tengo que poner en los argumentos:
#
# - file:
#
# - sep:
#
# - header:
#
# Nota: los archivos csv se pueden abrir con notepad u otro editor de texto
# plano... Incluso se pueden abrir con el editor de texto de RStudio (File >
# Open File... aunque puede que demore un poco).
#
# Escriba aquí el comando:




# Respuesta:
pqts <- read.table(file = "datos/paquetes.csv", # Ruta (relativa) del archivo
                   sep = ",", # Otras opciones comunes: \t (tabulaciones) y ;
                   header = TRUE) # Si tiene encabezado
View(pqts)
class(pqts$name)  # Pensaríamos que era character, pero no
levels(pqts$name) # Una cantidad excesiva de niveles...

# Lo que ocurre es que las columnas con texto son interpretadas como factor por
# defecto, lo cual puede pasar inadvertido y tiene algunas consecuencias
# inesperadas.
# 
# Con read.table, la forma de evitar este inconveniente desde el principio es
# con el argumento stringsAsFactor = FALSE:
pqts <- read.table("datos/paquetes.csv", # Ruta (relativa) del archivo
                   sep = ",", # Otras opciones comunes: \t (tabulaciones) y ;
                   header = TRUE, # Si tiene encabezado
                   stringsAsFactor = FALSE) # No a los factor!

# Bueno, mejoramos, aunque...
head(pqts)
class(pqts$first_release) # Esto debería ser una fecha...

# Esto se puede arreglar durante o posteriormente a la importación. 

# Hoy en día hay herramientas más sofisticadas para importar datos y se integran
# amablemente a la interfaz de RStudio...

# En el botón import dataset tendremos muchas opciones, que van a depender de
# qué paquetes están instalados en el sistema...
#
# Seleccione primero el paquete base y observe las opciones que figuran.
# Identifique aquellas que se corresponden con los argumentos recién ensayados.
# Observe además que tenemos un vistazo de las primeras líneas del archivo csv,
# para que podamos identificar si tiene encabezado, cuál es el delimitador de
# campos, etc...
#
# Vuelva a usar el botón Import Dataset, pero elija la opción readr ahora...
# Antes de apretar el botón de importar, juege con las distintas opciones y
# observe los cambios que cada una genera en la previsualización del objeto de
# salida.
#
# En particular, observe las clases por defecto de las columnas name y
# first_release: tienen un desplegable que permite ajustar la clase que nos
# interesa para cada columna.
#
# Para la segunda columna (fecha), elija el tipo dateTime como formato. Note que
# se nos pide ingresar el "format string", que no es más que una forma de
# especificar dónde va qué parte de la fecha-hora (similar al excel). El valor por defecto es (en mi PC al menos):
# 
# %m/%d/%Y %H:%M
#
# Sin embargo, el que preciso es:
# 
# %Y-%m-%d %H:%M:%S
#
# En mi PC tengo la opción del readr que es un paquete bastante bueno, así que
# lo voy a usar:
library(readr)
pqts <- read_csv("datos/paquetes.csv", 
  col_types = cols(first_release = col_datetime(format = "%Y-%m-%d %H:%M:%S")))

# Más adelante veremos qué hacemos con estos warnings
# 
# La función cols puede ser de mucha ayuda...

# También se puede leer un archivo desde una URL en la web:
# pqts <- read_csv("https://raw.githubusercontent.com/jumanbar/curso_camtrapR/master/clase_1/data/paquetes.csv", 
#   col_types = cols(first_release = col_datetime(format = "%Y-%m-%d %H:%M:%S")))

# Nota: hay formas más primitivas de leer archvos:
readLines("datos/paquetes.csv", n = 6)
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

# Warning: 2 parsing failures.
# row           col                    expected     actual                 file
# 6103 first_release date like %Y-%m-%d %H:%M:%S 2014-03-04 'datos/paquetes.csv'
# 7384 first_release date like %Y-%m-%d %H:%M:%S 2015-02-06 'datos/paquetes.csv'

pqts[c(6103, 7384), ] # En esas filas, las fechas son NA

# El problema es que no reconoce los valores encontrados (2014-03-04 y
# 2015-02-06) como fecha-hora, porque son sólo fecha. Hay muchas formas de
# resolver este problema, pero vamos a proponer lo siguiente:

# Ejercicio 5 ----
#
# Sustituir esos dos valores problemáticos con una fecha-hora artificial, usando
# las fechas que nos muestra el mensaje de advertencia y una hora arbitraria...
# el mediodía, por ejemplo.
#
# Ahora, hay un detalle: precisamos crear dos valores de la clase
# correspondiente (los datetime se llaman POSIXct). Hagamos un par de búsquedas
# a ver q encontramos:
??datetime
??POSIXct
#
# Hagamos click en ymd_hms...
?ymd_hms
#
# Esta será la función que debemos utilizar.
# 
# 5.a:
# 
# Cargue el paquete necesario para usar la función:

# -------------+
# 5.b:
#
# Escriba el comando necesario para crear un vector fecha-hora con estas dos
# fechas y horas:
# 
# 4 de abril de 2014 a las 12 del mediodía
# 
# 6 de febrero de 2015 a las 12 del mediodía

# -------------+
# 5.c
#
# Utilice el comando anterior (o el resultado, mejor dicho) para modificar los
# dos valores de first_release, de la tabla pqts, que no se importaron
# correctamente:

# (Nota: recuerde el uso de corchetes y/o $, junto con la asignación, para
# modificar valores dentro de un vector).
# -------------+


# Nota: puedo importar todo como character y modificar las columnas
# posteriormente:
pqts2 <- read_csv("datos/paquetes.csv", 
                  col_types = cols(first_release = col_character()))
#
# De esta forma no se pierde información.
#
# Es una alternativa útil cuando arreglar a mano no es una opción (por ejemplo,
# si la cantidad de mensajes de warning es excesiva). De todas formas, para
# arreglar la columna de una forma automatizada (o semi), tendremos que adquirir
# otras habilidades que veremos más adelante.
#
# Por qué no modificamos directamente la tabla en excel?



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



# * Datos del ECH 2018 ----

# Explore la forma de importar la tabla de hogares utilizando el archivo .sav...

library(haven)
hog <- read_sav("datos/ECH2018/H_2018_TERCEROS.sav")

# Es una tabla grandecita:
dim(hog)
sapply(hog, class)

# Observación: figuran varias columnas de la clase "haven_labelled"... Podemos
# ver qué implica esto en los siguientes ejemplos:

hog[1:4] # Observar la columna dpto...

# Además... cómo es que 
hog[1:4]
hog[, 1:4]
# Dan lo mismo?

View(hog[1:4]) # Vea las etiquetas de cada columna

hog$dpto[1:5] # Los valores son numéricos, pero tienen etiquetas asociadas.
attributes(hog$dpto)
attr(hog$dpto, "label")
attr(hog$dpto, "labels")


# FIN ----


# ----------------------------------- #
# Respuestas

# Ejercicio 1
w <- which(y > 1.96 | y < -1.96)
z <- y[w]
length(z) / length(y)

# Ejercicio 2
matrix(1:5, nrow = 3,  ncol = 4, byrow = TRUE)

# Ejercicio 3
# 
# 3.a:
dpto <- c("Montevideo", "Artigas", "Canelones", "Cerro Largo", "Colonia",
          "Durazno", "Flores", "Florida", "Lavalleja", "Maldonado", "Paysandú",
          "Río Negro", "Rivera", "Rocha", "Salto", "San José", "Soriano", 
          "Tacuarembó", "Treinta y Tres")

# Opción 1:
zona <- character(19)
zona[dpto == "Montevideo"]  <- "A"
zona[dpto != "Montevideo"] <- "B"

# Alternativamente:
zona <- ifelse(dpto == "Montevideo", "A", "B")


# 3.b: 
#
# Opción 1a:
zona <- rep.int("C", 19)
zona[dpto == "Montevideo"]  <- "A"
deptosCosteros <- c("Colonia", "San José", "Canelones", "Maldonado", "Rocha")
zona[dpto %in% deptosCosteros] <- "B"

# Opción 1b:
zona[dpto == "Montevideo"]  <- "A"
costa <- c("Colonia", "San José", "Canelones", "Maldonado", "Rocha")
zona[dpto %in% costa] <- "B"
zona[!(depto %in% c("Montevideo", costa))] <- "C"

# Opción 1c:
zona[dpto == "Montevideo"]  <- "A"
zona[dpto == "Colonia" | dpto == "San José" | dpto == "Canelones" | 
       dpto == "Maldonado" | dpto == "Rocha"] <- "B"
zona[dpto != "Montevideo" & dpto != "Colonia" & dpto != "San José" &
       dpto != "Canelones" & dpto != "Maldonado" & dpto != "Rocha"] <- "C"

# Alternativamente:
costa <- c("Colonia", "San José", "Canelones", "Maldonado", "Rocha")
zona <- case_when(
  dpto == "Montevideo" ~ "A",
  dpto %in% costa ~ "B",
  TRUE ~ "C"
)

# 3.c:
zona <- rep.int("D", 19)
zona[dpto == "Montevideo"]  <- "A"
deptosCosteros <- c("Colonia", "San José", "Canelones", "Maldonado", "Rocha")
zona[dpto %in% deptosCosteros] <- "B"
zona[basalto >= 1] <- "C"

# Alternativamente:
deptosCosteros <- c("Colonia", "San José", "Canelones", "Maldonado", "Rocha")
zona <- case_when(
  dpto == "Montevideo" ~ "A",
  dpto %in% deptosCosteros ~ "B",
  basalto >= 1 ~ "C",
  TRUE ~ "D"
)

# Tablas:
tabla <- tibble(dpto = dpto, basalto = basalto, zona = zona)
tabla

# Ejercicio 4
# 
# 4.a:
paste0("Tengo unos ", cuantas.frutas, " ", names(cuantas.frutas), "s")

# 4.b
t1 <- paste0(cuantas.frutas, " ", names(cuantas.frutas), "s")
t2 <- paste0(t1[-length(t1)], collapse = ", ")
paste0("Tengo unos ", t2, " y ", t1[length(t1)])


# Ejercicio 5:
# 
# Precisamos el paquete lubridate:
library(lubridate)

# La función ymd_hms espera cierto tipo de formatos muy específicos de fecha y
# hora, escritos entre comillas:
fh <- ymd_hms(c("2014-03-04 12:00:00", "2015-02-06 12:00:00"))

# Un par de formas de cambiar los valores que nos interesan:
pqts[c(6103, 7384), 2] <- fh
pqts$first_release[c(6103, 7384)] <- fh
