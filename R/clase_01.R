# Capacitación de R: nivel USUARIO
# Clase 1: Introducción
# Autor: Juan Manuel Barreneche Sarasola
# **************************************

# I. RStudio ----
#
# (A partir de aquí se asume que se está trabajando en el proyecto
# "OPP_R_usuario", contenido en el archivo OPP_R_usuario.Rproj, presente en la
# carpeta de trabajo.)
#
# Empezaremos haciendo una recorrida por la interfaz gráfica de RStudio Se trata
# de un IDE (Integrated Development Environment) de gran popularidad, casi el
# estándar para trabajar con R al día de hoy.
#
# El entorno de RStudio propone 4 paneles básicos, a los que llamaremos:
#
# | 1. Código   | 3. Ambiente |
# +-------------+-------------+
# | 2. Consola  | 4. Gráficos |

# I.a Consola (panel 2) ----

# Es la interfaz histórica de R. Es interactiva: los comandos se ejecutan 
# inmediatamente (ie: es un interpetador), a diferencia de otros lenguajes de
# programación que necesitan de una instancia de compilación.
# 
# Ejemplo:
1 + 1

# El > al inicio de la línea es el "prompt", el lugar en donde escribimos los
# comandos. Ese caracter diferencia nuestros comandos (input) de los resultados
# obtenidos (output).

# Se dice que los resultados "se imprimen" en la consola. De hecho hay un
# comando para "imprimir" salidas, el cual veremos más adelante que puede ser
# muy útil, aunque por ahora parezca innecesario.
print(1 + 1)

# En el entorno de la consola tenemos acceso a objetos y funciones...
print
print(1 + 5)
# Por qué los resultados de estos dos comandos son tan diferentes? No hay por
# qué responder ahora...

# A tener en cuenta: R es sensible a mayúsculas y minúsculas, por lo tanto, este
# comando da un error:
Print

# (Cuando escribimos mal el nombre de un objeto, R nos da un mensaje de error en
# el que declara no haber encontrado lo que le pedimos.)

# Además de funciones, como print, hay objetos que ya vienen con los paquetes de
# base de R. Generalmente son matrices o tablas de datos, incluidos para ser
# utilizados en ejemplos que ilustran comandos, funciones o sintaxis de R. Las
# siguientes son algunas tablas incluidas en el R base:
iris
cars

# El término genérico es "objeto". Algunos son funciones, otros son tablas
# (data.frames), otros matrices (matrix), y así... Lo interesante es que
# nosotros podemos crear nuevos objetos con el nombre que nos parezca más
# conveniente, utilizando la llamada "asignación":
a <- 6 # Este es un tipo de asignación (estilo exclusivo de R)
b = 3  # Esta también es una asignación, similar a otros lenguajes.
a * 2
a - 1
x <- a / b
x

# Los objetos creados se guardan en el ambiente o sesión, que ocupa memoria
# (R.A.M.) y están accesibles mientras dure la sesión. La forma básica de ver la
# lista de objetos es:
ls()

# Por otro lado RStudio tiene el panel 3, "Ambiente". Allí debería encontrar a
# "a" y "b" listados como objetos disponibles en el ambiente de trabajo.

# La creación de objetos es una piedra fundamental para trabajar con R, y para
# programar en general.

# Los objetos de nuestro espacio de trabajo se pueden guardar convenientemente
# con las funciones save o save.image:

save(a, b, file = "ab.RData")

save.image("sesion_20191007.RData")

# Lo escrito entre comillas son archivos que se guardaron en el disco duro (ver
# la carpeta del curso).
#
# Los objetos se pueden traer con el comando load. El siguiente ejemplo sirve
# para traer un modelo de regresión a nuestro espacio de trabajo:
load("salidas/modelo_regresion.RData")
ls() # Nuevos objetos: "modelo" y "p" 

p # Se trata de un gráfico del tipo ggplot

modelo # Se trata de una regresión ponderada con GLM

# Este modelo describe la relación entre los ingresos totales por hogar
# (incluyendo valor locativo y sin servicio doméstico: HT11) y el valor del
# alquiler (ht14), basado en los datos de la ECH 2018. La relación matemática es
# la siguiente:
#
# log10(y + 1) = s * log10(x + 1)
#
# En donde
#
# x = valor del alquiler (ht14)
#
# y = ingresos totales del hogar (HT11)
# 
# s = pendiente de la recta o coeficiente del modelo = 1.175017
modelo$coefficients

# * * Ejercicio 1 ----
# 
# * * * 1.a ----
# 
# Determimnar la cantidad de ingresos que el modelo predice para un hogar en
# el que el valor del alquiler es de 10 mil pesos... En otras palabras,
# encontrar el valor de y esperado para x = 1e4 (diez mil).
# 
# Obs. 1: va a necesitar conocer las siguientes expresiones:
#
# log10(x) es el logaritmo de base diez de x. Ej:
log10(100)

# En R, "a elevado a la b" (potencia) se escribe: a ^ b o a ** b. Ej:
10 ** 2
10 ^ 2

# Por último, es conviente saber que las operaciones matemáticas tienen una
# prioridad predefinida (en la mayoría de los casos). La siguiente lista
# (muy limitada) muestra operadores en orden de prioridad (de mayor a menor):
# 1. ^
# 2. - +
# 3. * / 

# Además el orden de las operaciones puede ser determinado por el usuario usando
# paréntesis:
(3 * 4) - 9
3 * (4 - 9)

# Para más detalles...
?Syntax

# Obs. 2: el resultado correcto es 50131.64, aunque se acepta un error de +- 15

# * * * 1.b ----
# 
# Considere el polinomio de 3er grado definido por esta ecuación:
# x^2 - 4x^2  + 2x + 1
 
# Podemos usar las flechas hacia arriba y hacia abajo para repetir el cálculo
# del valor del polinomio para distintos valores:
x <- 2
x ^ 3 - 4 * x ^ 2 + 2 * x + 1 # - 3

x <- 4
x ^ 3 - 4 * x ^ 2 + 2 * x + 1 # 9

# Los dos ejemplos anteriores nos muestran que existe al menos una raíz entre 
# x = 2 y x = 4.
# 
# Busque al menos una raíz del polinomio. Si puede, encuentre las 3.

# Ayuda: los siguientes comandos usan las funciones curve y abline para
# visualizar los puntos en que el polinomio tiene raíces reales:
curve(x ^ 3 - 4 * x ^ 2 + 2 * x + 1, from = -.5, to = 3.5)
abline(h = 0, col = "blue")

# También se pueden usar líneas verticales para ver si un valor corresponde a
# una raíz:
abline(v = 1, col = "red")


# # # # # # # # #

# * * Notas 1 -----
# 
# Algunas funcionalidades de la consola:
# 
# 1. El historial de comandos ejecutados anterioermente está disponible de dos
#    maneras: utilizando las flechas hacia arriba y hacia abajo y en la pestaña
#    historia, del panel 3 de RStudio (arriba a la derecha)
# 
# 2. La posibilidad de autocompletar: si escribimos las primeras letras del
#    nombre de un objeto cualquiera y apretamos la tecla tab, ocurrirá una 
#    magia... ejemplo (escribir lo siguiente observar...):
air
#    (en mi computadora aparecen al menos tres opciones: airmiles, airquality y 
#    AirPassengers)
#    Otro ejemplo:
mod 
#    (Acá deberían aparecer muchas opciones, incluyendo al objeto "modelo".)
# 
# 3. Cuando un comando no está completo, en la consola se sustituye el > inicial
#    por un +, el cual nos indica que hay que terminar el comando... En esos 
#    casos podemos usar la tecla Esc para cancelar (Ctrl+C en Unix). 
#    Ejemplo, escribir "print(1 + 1" en la consola...
#    (este es un típico ejemplo... olvidar un paréntesis!)
# 
# 4. La tecla Esc sirve para cancelar, tanto comandos sin completar como tareas
#    que R está ejecutando.


# I.b Código (panel 1) ----

# | 1. Código   | 3. Ambiente |
# +-------------+-------------+
# | 2. Consola  | 4. Gráficos |

# En esta parte de la clase abrimos este mismo archivo en panel en cuestión, que
# no es más que un editor de *texto plano* (le queda de deber investigar qué
# significa esto), similar a lo que es el "bloc de notas" de Windows.

# Primero que nada: chequear que esté bien la codificación de caracteres...

# Utilizando la interfaz gráfica de RStudio podemos tomar ventaja del sistema de
# marcadores: cualquier línea comentada que termina en 4+ guiones o numerales
# funciona como un marcador, el cual se puede visualizar de dos maneras:
# Ctrl+Shift+o y con el desplegable que aparece abajo a la izquierda (encima de
# la consola).

# Por cierto, todo lo que se escribe a la derecha de un numeral es un
# "comentario": no tiene efecto alguno (es ignorado por R). Todos los lenguajes
# de programación tienen algún sistema para hacer comentarios, como este.

# El código de R se escribe, generalmente, en archivos cuyo nombre termina en .R
# (la extensión), para indicar que contienen código en este lenguaje. En teoría
# se pueden guardar con otras extensiones, como txt o csv, pero sería bastante
# tonto hacerlo. Los archivos de código se denominan "scripts" (ie: guiones), y
# se utilizan para tener un registro de los comandos empleados, con el fin de
# que podamos reutilizarlos en el futuro.
#
# Nota: en Windows, por defecto, el explorador de archivos oculta las
# extensiones de los archivos, lo cual quita autonomía al usuario, directa e
# indirectamente. Esto se puede revertir en la configuración del propio
# explorador de windows.

# Una funcionalidad muy práctica de RStudio es la posibilidad de ejecutar un
# comando directamente desde el script, utilizando Ctrl+Enter. Probar con los
# siguientes comandos:
x <- 1:10
x = 1:10
x
z <- c(2, 6, 4:-2)
print(x) # esto hace ...
x ^ 2
y <- rnorm(1000)
plot(y)
plot(sort(y))
hist(y)
# (Observe y describa lo que realizan estos comandos.)

# Usualmente los scripts de R están en permanente cambio y se pueden utilizar de
# muchas maneras. Típicamente el usuario o la usuaria hacen, deshacen, prueban y
# tocan los scripts hasta que obtienen una secuencia de comandos que le
# satisfacen.

# I.c Ambiente / Sesión de R ----

# | 1. Código   | 3. Ambiente |
# +-------------+-------------+
# | 2. Consola  | 4. Gráficos |

# Cada vez que R se inicia, una nueva sesión de trabajo es inaugurada. En el
# caso más común, no habrán objetos a la vista en la pestaña Environment
# (Ambiente) del panel 3 (arriba a la izquierda). Esto no quiere decir que no
# existan objetos disponibles para ser usados. Un ejemplo evidente son las
# funciones básicas de R, algunas de las cuales ya vimos. Otro son algunas
# tablas, matrices u otros objetos con datos, disponibles para ejecutar ejemplos
# ilustrativos.

# La sesión de trabajo se modifica cada vez que:
# 
# I.c.1 Objetos ----
# 
# 1. Creamos un objeto mediante una asignación, tal como la siguiente:
impares <- 1:50 * 2 - 1
impares

# 2. Eliminamos un objeto de la sesión:
rm(impares)

# 3. Cargamos archivos RData:
load("datos/paquetes.RData")
ls() # Debería figurar el objeto pqts

# 4. Cargamos paquetes...
# 
# I.c.2 Paquetes ----
#
# Un paquete es una colección de funciones y datos que extienden o mejoran la
# funcionalidad de R.
#
# El R recién instalado no es más que, podríamos decir, un conjunto de paquetes
# que fucionan en conjunto. Cuando iniciamos una sesión nueva, se cargan
# automáticamente algunos de estos paquetes: aquellos que sirven para realizar
# las tareas más básicas (paquete base), o hacer gráficos estándar (graphics),
# estadística (stats) y más...
#
# El sistema de paquetes de R, por otro lado, se trata de una red de
# repositorios en las que se encuentran para descargar paquetes creados por
# usuarios de todo el mundo. Aquellos que se encuentran en el CRAN cumplen con
# requisitos mínimos de calidad.
# 
# Esta red de paquetes es uno de los  puntos fuertes más grandes de R:
require(ggplot2)
ggplot(pqts, aes(as.Date(first_release), index)) +
  geom_line(size = 1.5, col = "skyblue") +
  scale_x_date(doppate_breaks = '2 year', date_labels = '%Y') +
  scale_y_continuous(breaks = seq(0, 14000, 1000)) +
  xlab("Año") + ylab("") + theme_bw() +
  ggtitle("Número de paquetes de R alguna vez publicados en CRAN", 
          "Durante 20 se ha mantenido un crecimiento exponencial.")

# Volviendo a la sesión de R: cuando cargamos un paquete en la sesión, lo que
# hacemos es habilitar la capacidad de "llamar" funciones o conjuntos de datos
# de este paquete utilizando simplemente el nombre.
#
# Por ejemplo, el paquete "lubridate" nos sirve para manejar fácilmente los
# formatos de fechas y horas. Dicho paquete está *instalado* en el disco duro de
# la computadora, pero cargado en nuestra sesión de trabajo. Por esta razón es
# que aún no podemos utilizar las funciones del mismo:
ymd("2009-08-23") # Esto debería devolver un error

# Para cargar un paqute en R, se utiliza la función library (o la función
# require):
library(lubridate)
ymd("2009-08-23") # Esto debería funcionar sin errores

# Debe notarse también que las funciones incluidas en un paquete se pueden
# llamar sin haber cargado el paquete de antemano, utilizando el operador ::,
# como en este ejemplo:
lubridate::ymd("2019-03-28")

# Nota: este operador puede ser importante cuando ocurre que hay 2 paquetes
# activos en la sesión que contienen funciones con el mismo nombre. El :: nos
# permite desambiguar los comandos.

# En caso de no tener el paquete instalado, se puede instalar el mismo con el
# siguiente comando:
install.packages("lubridate") # Aquí las comillas son importantes.

# Pensando en un ejemplo relevante para este curso, instalemos del paquete
# haven (dar sí al cuadro de diálogo):
install.packages("haven")

# Nota: RStudio nos facilita la visualización de cuáles paquetes están
# instalados en el disco duro y cuales están *cargados* en la sesión actual, en
# el panel 4 (abajo a la derecha), bajo la pestaña Paquetes. Incluso tiene
# botones para la instalación, actualización y cargado de paquetes.

# En este punto es necesario asegurarnos de que hemos entendido correctamente la
# diferencia entre instalar y cargar un paquete:
#
# | Término   |  Función/es        |  Descripción                              |
# +-----------+--------------------+-------------------------------------------+
# | instalar  |  install.packages  |  Instala en el disco duro                 |
# | cargar    |  library, require  |  Carga el paquete en la sesión de trabajo |

# Los paquetes accesibles a través de install.packages son los que se encuentran
# en el CRAN (Comprehensive R Archive Network). Estos paquetes cumplen, en
# teoría, con un estándar de calidad establecido. De todas formas, hay más
# paquetes aún, y de calidad, en otros repositorios. Muchos de ellos se pueden
# acceder con el paquete devtools: github, bitbucket, gitorious...
browseURL("https://www.rstudio.com/products/rpackages/devtools/")

# Veremos algún ejemplo más adelante.

# I.c.3 Objetos y funciones ----

# Como ya dijimos, crear objetos y guardarlos con algún nombre (que nos parezca
# informativo) es útil cuando sabemos que serán usados en el futuro. Veamos
# estos datos tomados de la ECH:

#   Goteras en techos   SI    NO
# Humedades       SI  1722  4148
# en techos       NO  5067 31345

# Hagamos objetos que contengan estos números:
SS <- 1722
NS <- 5067
SN <- 4148
NN <- 31345

# Calculemos ahora el índice de Jaccard de similitud, el cual tiene la fórmula:
J <- NN / (SN + NS + NN)
J # 0.77

# Ahora, supongamos que tenemos que corregir algún valor, se modifica J
# automáticamente? Qué esperaría ud.? Por qué?
NS <- 2301
J
# En el caso de R, el valor J no será modificado automáticamente. Es una
# decisión de diseño (programación funcional), que implica que para modificar un
# objeto hay que sobreescribirlo explícitamente. Compare lo que ocurre en una
# planilla de excell, por ejemplo, cuando se modifica una celda que es utilizada
# para realizar calculos (como una suma de totales o promedios).
J <- NN / (SN + NS + NN)
J # 0.83

# Nota: cuando hablamos de nombres de objetos, es importante tener en cuenta que
# las siguientes no son equivalentes:
NS
"NS"

# Comparar las salidas de estos dos comandos. Cuál es la diferencia? Ahora
# veamos el resultado de esta multiplicación:
3 * NS
3 * "NS"

# Las comillas indican cadenas de caracteres! También conocidas como strings.

# Pasemos a conocer un poco más de las funciones. Ya vimos al menos un ejemplo
# de función en esta sesión. Comparemos estos dos comandos y sus salidas:
print("pepe")
print

# La sintaxis para usar una función en R es:
# 
# <nombre de la función>(<argumento(s)>)

# Algunos ejemplos:
c(3, 5, 23, 9:2)
x <- c(3, 5, 23, 9:2)
sqrt(9)
mean(-3:3)
mean(c(3, 5, 23, 9:2))
mean(x)
sum(c(3, 5, 23, 9:2))
sum(sqrt(
  c(3, 5, 23, 9:2)
  ))

dim(iris)

# II. Uso de la ayuda ----

# | 1. Código   | 3. Ambiente         |
# +-------------+---------------------+
# | 2. Consola  | 4. Gráficos / Ayuda |

# Conozcamos un poco más de cerca a la función rnorm:
# 
# Algunos ejemplos:
rnorm(10)
rnorm(10, 8, 6)
rnorm(10, sd = 6)
rnorm(10, sd = 6, mean = 8)

# En qué se diferencian estos tres comandos? Qué controla cada uno de estos
# números?

# II.a Ayuda estándar ----
# 
# Además de experimentar directamente, podemos consultar la documentación de R:
?rnorm

# Qué indican las diferentes secciones de la página de ayuda? Observar en
# particular Usage, Arguments, Value y Examples...
#
# Notar también esta función:
example(rnorm)

# Otro ejemplo: mean
# 
# Vamos a crearnos un problema de forma artificial y luego veremos 3 formas de
# buscarle la vuelta:
mean(c(3, 5, 23, 9:2, NA))

# Qué devuelve? Por qué?
#
# (1) Para entender cómo resolver este escollo, contamos con la ayuda de R:
?mean

# (Esta es la forma tradicional de usar la ayuda: con un comando. En RStudio
# también está el panel de ayuda, con su propio buscador, así como la tecla F1)

# Consultando la página de ayuda de la función mean, podemos buscar ("Find in
# topic" o Ctrl+F) la palabra NA y ver qué encontramos...
# 
# Bajo el título Usage, encontramos:
# mean(x, ...)
# # Default S3 method:
# mean(x, trim = 0, na.rm = FALSE, ...)

# Allí se destaca el argumento na.rm, cuyo significado podemos leer más abajo,
# en la sección Arguments:
#
# "a logical value indicating whether NA values should be stripped before the
# computation proceeds."
#
# Es decir, con na.rm podemos controlar si queremos que el NA sea tenido en
# cuenta o no. También dice que na.rm debe ser un "logical value", qué significa
# eso?
?logical

# Como vemos allí, se trata de los valores TRUE o FALSE... Perfecto. Ahora, cómo
# uso esta funcionalidad?
# *****************************************
# Llene con su respuesta aquí:

# *****************************************

# (2) Alternativamente, puede que nos interese saber más de estos NA:
?NA

# (Al leer esta definición, es claro que NA es un resultado perfectamente
# razonable para el cálculo del promedio de una serie de números que contiene
# NAs)
# 

# También es útil destacar que en la ayuda de NA se encuentra la función is.na,
# que es necesaria para determinar la ubicación de los NAs que tiene un
# determinado vector.

x <- c(3, 5, 23, 9:2, NA)

# Para un valor como 5, es fácil "encontrar" la posición en la que se encuentra,
# utilizando el operador == ("igual a"):
x == 5

# Pero cuando se trata de NA, este método deja de ser válido, por motivos
# enteramente razonables:
x == NA

# Es entonces cuando se is.na es relevante para la tarea:
is.na(x)

# El símbolo ? es una forma rápida de escribir help. Ejemplos:
help(mean)
help("datasets")
help("<-")
help(help)

# (3) Google: "R mean NA". Esta es otra forma de buscar ayuda...

# * * Ejercicio 2 ----
#
# Coloque correctamente los comentarios en cada línea:

c # Devuelve la cantidad de filas y columnas de una tabla o matriz
matrix # Genera números aleatorios con distribución normal
data.frame # Calcula el promedio de un vector
mean # Crea un vector repitiendo los elementos del primer argumento
rnorm # Devuelve la cantidad de elementos de un objeto
pnorm # Realiza muestreos aleatorios de vectores
dim # Crea una tabla de datos
sample # Grafica un histograma básico
which # Función de distribución acumulada de la distribución normal
hist # Crea una matriz de valores
length # Concatena valores para formar un vector de elementos
rep # Determina qué elementos de un vector cumplen con una condición determinada

# II.b Ayuda por aproximación ----

# La función help.search sirve para buscar documentación de R sin saber
# previamente qué es lo que necesitamos. Por ejemplo, si nos interesa buscar
# funciones o ejemplos relativos a modelos lineales, podemos escribir:
help.search("linear model")
??"linear model" # Equivalente al anterior

# Note que aquí usé las comillas, debido a que se trata de dos palabras. Pruebe
# sin las comillas e interprete el resultado.

# En la última versión de RStudio no funciona bien la función help.search, que
# permite buscar por aproximación (una suerte de google dentro de R, por decirlo
# de forma poco profesional). Para poder ver los ejemplos anteriores, será
# necesario usar el R sin RStudio...

# RESUMEN, del uso de la ayuda:
# 
# # Puntos clave para llevarse bien con R:
# - Utilizar la ayuda
# - Utilizar Google
# - Consultar la ayuda
# - Leer detenidamente los mensajes de error
# - Preguntar
# - Probar
# - Leer la ayuda

# No importa cuántos años de experiencia tengas usando R, estoy dispuesto a
# apostar que usás la ayuda todos los días. Algunas razones para que esto se así
# es que (1) hay muchas funciones, datasets o temas, etc, por lo que es
# básicamente imposible recordar todo, y (2) por otro lado, la ayuda de R es muy
# buena y sigue un esquema básico que facilita la lectura.
#
# Por otro lado, es 100% cierto que el lenguaje de la ayuda (o de los mensajes
# de error, ya que estamos), es difícil de entender, especialmente para quien
# empieza.
#
# El obstáculo del vocabulario es muy  real, pero por suerte es fácil acceder,
# hoy en día, a definiciones o ayuda por internet. Mi consejo es, para quien R
# (o programación en general) representa una herramienta de trabajo más o menos
# cotidiana, tomarse el tiempo de ir aprendiendo y familiarizándose con la
# terminología utilizada.
#

# TAREA:
# Buscar en internet el significado de "atomic vector", en el contexto de R.


# III. Errores y advertencias ----

# Hay dos tipos de menseajes:
# - Advertencias = Warnings: no impiden que se complete una tarea, pero hay
#   riesgo de que algo haya salido mal.
as.numeric(c("4", "2", "u"))
warnings()

# - Errores: hay algún problema que impide la ejecución del comando.
c("4", "2", "u") * 3

# Podemos categorizar los errores de R en tres tipos:
# a. errores de sintaxis,
# b. errores de objetos no encontrados y
# c. el resto.

# Ejemplo de a:
mean(c(2:5, NA) na.rm = TRUE)

# Ejemplo de b:
plot(sort(y), col = red)

# Versiones corregidas:
mean(c(2:5, NA), na.rm = TRUE)
plot(sort(y), col = "red")

# Ambos se tratan de casos típicos. En el primero, si bien R no nos dice "falta
# una coma" (porque no necesariamente ese tiene por qué ser el problema), nos
# trata de ayudar lo más posible, dado la información con la que cuenta. Note
# que en el mensaje de error se indica el momento exacto en que encuentra "un
# símbolo inesperado".
#
# En el segundo ejemplo, lo que ocurre es que quisimos indicar que el color
# deseado para el gráfico es rojo, pero olvidamos poner las comillas. Cuando
# escribimos un texto sin comillas, R interpeta que se trata de el nombre de un
# objeto que debe buscar en el ambiente de trabajo actual y es por eso que
# devuelve un "objeto no encontrado".

# Cuando se trata de un comando complejo, suele ser muy útil usar la función
# traceback:
traceback()

# Cuando obtenga un error o advertencia que no entiende, le puede resultar útil
# seguir estos pasos:
#
# 1. No entre en pánico. 
# 2. Intente averiguar por qué ocurre. 
# 3. Confirme que su sospecha es cierta. 
# 4. Repita los pasos 1 a 3 tantas veces como sea necesario.
#
# El arte de la depuración está en la habilidad para generar de buenas sospechas
# y confirmarlas. Y se obtiene con práctica.
#
# A esta lista también puede agregarse una opción más:
#
# Si realmente no tengo idea de para donde continuar, tal vez hacer una búsqueda
# de google me ayude.
#
# Es decir, copiar el mensaje de error y pegarlo en una búsqueda de google puede
# ser muy útil y de hecho lo he practicado infinidad de veces. En este sentido,
# es bueno también saber seleccionar qué partes del error son las más
# informativas y que vale la pena poner en el buscador.

# * * Ejercicio 3 ----
# Encontrar los errores en los siguientes comandos:
plot(sort(rnorm(60)), pch=8, col=red, xlab="Rank", ylab="Variable Gaussiana")

plot(sort(rnorm(60)), pch=8, col="red", xlab="Rank" ylab="Variable Gaussiana")

plot(sort(rnorm(60)), pch=8, col="red", xlab="Rank", xlab="Variable Gaussiana")

# IV. Rutas y Directorio de trabajo ----

# Directorio de trabajo = wd (siglas en inglés)

# Los archivos de una computadora se ubican en "Rutas", tales como:
# C:\Users\Admin\planilla.xlsx

# Se puede describir al sistema de archivos como un árbol invertido, cuyo tronco
# es la partición del disco duro (ej: C:) y cuyas hojas son los archivos
# propiamente dichos, con las carpetas haciendo las veces de ramificaciones.

# R trabaja en una carpeta del disco duro, la cual puede modificarse en
# cualquier momento. En RStudio se puede cambiar la carpeta de trabajo con el
# menú: 
# Session > Set Working Directory > Choose Directory...

# Observar que al ejecutar el comando (luego de elegir la carpeta de trabajo del
# curso), aparece en la consola un comando similar a este:
setwd("/home/juan/R/OPP_R_usuario/")

# 1. No será igual en todas las computadoras, por qué?
# 2. Si ejecuto el comando desde R, obtendré el mismo resultado? Quíen da más?
# 3. Las comillas son necesarias cada vez que deseamos indicar que se trata de
#    texto.
# 4. Se trata de una ruta *absoluta*, ya que va desde la base del tronco hasta
#    la rama.

# Qué ocurrió al ejecutar este comando? Ahora R está "parado" en la carpeta que
# elegimos. Esto afecta la forma en que interactúa con los archivos presentes en
# el disco duro. Al pararse en una carpeta X, será mucho más fácil "ver" los
# archivos que están ubicados allí. A su vez, los archivos generados por R se
# guardarán, *por defecto*, en el wd (pero no estamos restringidos a hacerlo
# así).

# Qué archivos estamos viendo ahora?
dir()

# Nos interesa leer "cdo.txt"
readLines("cdo.txt")

# Qué hace el argumento n de la función readLines? Y el argumento ok?
# *****************************************
# Llene con un ejemplo aquí:

# *****************************************


# El último verso no está completo. Podríamos arreglarlo y volver a guardarlo,
# desde R...

# Lo primero es asignarlo a un nombre que tenga sentido:
cdo <- readLines("cdo.txt")

# Sabemos que es el tercer elemento el que está mal:
cdo[3]

# Así que usamos este comando para sobreescribirlo:
cdo[3] <- "me devuelva lo perdido."

# A ver cómo quedó?
cdo

# Un truco para verlo más lindo...
cat(cdo, sep = "\n") # El \n = new line, indica cambio de renglón

# Ahora sí, lo podemos guardar corregido:
writeLines(cdo, "cdo.txt")

# (abrir con bloc de notas, o RStudio, para confirmar que está bien escrito)

# Hoy hablanos de rutas absolutas. Cómo sería una ruta que no sea absoluta? En
# el ejemplo anterior usamos una ruta relativa en dos ocasiones: para leer y
# para escribir el archivo cdo.txt.

# Las rutas relativas se escriben en relación al lugar en donde "estamos
# parados". Por ejemplo, ahora estamos parados en la carpeta OPP_R_usuario. Esa
# carpeta tiene otras subcarpetas, como "datos":
dir("datos/")
dir("R")

# Estos son ejemplos de rutas relativas. La utilidad de este formato es que la
# misma ruta se pude usar en diferentes computadoras.

# Probemos ahora cargar el archivo "hum_got.RData", presente en la carpeta datos (escrito en un formato nativo de R, que se parece a un comprimido zip). Para ello precisamos la función load:
load("datos/hum_got.RData")

# Nota de gran utilidad! Es posible utilizar el autocompletar para escribir
# rutas absolutas o relativas!

# Veamos el nuevo objeto cargado en la sesión:
hum_got

# (Se trata de una tabla de contingencia creada con datos de la ECH.)

# Combinando lo que hemos visto acerca de rutas y scripts de R, podemos utilizar
# la función source, que simplemente ejecuta todos los comandos contenidos en un
# archivo dado:
source("R/ej_ggplot_01.R", encoding = "UTF-8")

# (Nota: además de los gráficos, qué pasó en el ambiente de trabajo?)
# 
# Pregunta: para qué sirve el argumento encoding usado en el comando anterior?
# *****************************************
# Llene con su respuesta aquí:
# 
# *****************************************

# Con esto damos por conluido el tema de las rutas y directorios de trabajo.
# Téngase en cuenta que siempre se puede acceder a cualquier archivo del disco
# duro desde cualquier wd, ya sea con rutas relativas o absolutas. Para las
# primeras, a veces es necesario utilizar el "..", que apunta siempre hacia una
# carpeta "más arriba" en el sistema de archivos:
dir("..")
dir("../..")

# Dicho esto, vamos a crear un proyecto de RStudio en la carpeta del curso. Para
# esto se debe usar la interfaz gráfica del programa. La próxima vez que se abra
# este proyecto, R se abrirá en la carpeta principal del mismo, RStudio
# recordará los archivos abiertos, las configuraciones personales elegidas y
# más. Es una forma de organizarse, separando diferentes proyectos de R.

# En la carpeta podrán observar que aparece el archivo .Rproj, que no es más que
# texto en donde se anotan las configuraciones del proyecto:
readLines("OPP_R_usuario.Rproj")

# (Pueden probar abrilo con bloc de notas...)

### Materiales creados en el pasado ----

# Lista completa de videos del curso IMSER (2013):
browseURL("https://www.youtube.com/watch?v=b-y3-7wMeco&list=PL41C5vgvqV_PA-e634Q4wn5MKbubqv6P9&index=1")

# Códigos de R y más, curso IMSER:
browseURL("https://github.com/jumanbar/Curso-R")

# Clases del curso camtrapR:
browseURL("https://github.com/jumanbar/curso_camtrapR")

# FIN ------

# Respuestas:

# Ejercicio 1:
# 
# 1.a
s <- 1.175017 # Pendiente del modelo lineal
x <- 1e4      # Valor de alquiler (variable independiente)
10 ** (s * log10(x + 1)) - 1 # Predicción de ingresos para el hogar

# 1.b
# Raíces: 
# -.3018 aprox.
# 1
# 3.30277 aprox.

# Ejercicio 2:
c # Concatena valores para formar un vector de elementos
matrix # Crea una matriz de valores
data.frame # Crea una tabla de datos
mean # Calcula el promedio de un vector
rnorm # Genera números aleatorios con distribución normal
pnorm # Función de distribución acumulada de la distribución normal
dim # Devuelve la cantidad de filas y columnas de una tabla o matriz
sample # Realiza muestreos aleatorios de vectores
which # Determina qué elementos de un vector cumplen con una condición det.
hist # Grafica un histograma básico
length # Devuelve la cantidad de elementos de un objeto
rep # Crea un vector repitiendo los elementos del primer argumento
