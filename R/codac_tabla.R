# Contexto ----
# Basado en el documento publicado por INE con la ECH 2018:
# browseURL("http://www.ine.gub.uy/c/document_library/get_file?uuid=beb740f9-4da4-4f57-9b24-519d7bf72faa&groupId=10181")

# CODAC: clasifica la población en 4 grandes grupos:
# 0: menores de 14 años
# 1: ocupados
# 2: desocupados
# 3: inactivos

# Pasos
# 
# 1. Importar tabla personas de la ECH 2018 (per)
# 
# 2. Agregar a per la variable codac, en base a las columnas:
#    e27 f66 f67 f261 f68 f106 f107 f108 f109 f110.
#    (Nota: class(per$codac) debe ser factor o character)
# 
# 3. Crear objeto con especificaciones del diseño de muestreo (disp):
#    Estratos : nomdepto y estred13
#    Pesos    : pesoano
# 
# 4. Crear 3 tablas (total país, mvd+interior, resto de los dptos):
#    a. Total país: 
#      a.1 group_by: agrupar por codac
#      a.2 summarise + survey_total: hacer suma ponderada de casos por categoría
#      a.3 mutate: con las sumas y el total de casos, calcular porcentajes
#      a.4 select y mutate: eliminar columnas sobrantes y agregar "nomdpto"
#      a.5 spread: ensanchar la tabla, dejando nomdpto en filas y codac en 
#                  columnas (key = codac, value = p)
#      a.6 mutate: agregar columnas de Total de activos y Total global

#    b. mvd+interior: 
#      b.0 mutate + if_else: recodificar dpto --> MVD vs. Interior
#      b.1 group_by: agrupar por mvd y codac
#      b.2 summarise + survey_total: hacer suma ponderada de casos por categoría
#      b.2.1 group_by: agrupar por mvd, preparando el siguiente paso... 
#      b.3 mutate: con las sumas y el total de casos (por grupo), calcular
#                  porcentajes
#      b.4 select: eliminar columnas sobrantes y renombrar (nomdpto = mvd)
#      a.5 spread: ensanchar la tabla, dejando nomdpto en filas y codac en 
#                  columnas (key = codac, value = p)
#      b.6 mutate: agregar columnas de Total de activos y Total global
# 
#    c. resto dptos: 
#      c.0 filter: eliminar el caso nomdpto == "MONTEVIDEO"
#      c.1 group_by: agrupar por nomdpto y codac
#      c.2 summarise + survey_total: hacer suma ponderada de casos por categoría
#      c.2.1 group_by: agrupar por nomdpto, preparando el siguiente paso... 
#      c.3 mutate: con las sumas y el total de casos (por grupo), calcular
#                  porcentajes
#      c.4 select y mutate: eliminar columnas sobrantes
#      c.5 spread: ensanchar la tabla, dejando nomdpto en filas y codac en 
#                  columnas (key = codac, value = p)
#      c.6 mutate: agregar columnas de Total de activos y Total global
#      
# 5. Pegar las tablas con bind_rows, ordenar las columnas con select
# 
# 6. Darle formato de publicación a la tabla (con el paquete kableExtra)

# Importación ----
library(haven)
library(tidyverse)
library(srvyr)
library(kableExtra)
per <- read_sav("datos/ECH2018/P_2018_TERCEROS.sav")
# El archivo P_2018_TERCEROS.sav se puede descargar de la página de la ECH del
# INE:
# http://www.ine.gub.uy/c/document_library/get_file?uuid=b63b566f-8d11-443d-bcd8-944f137c5aaf&groupId=10181

# Recodificación: ----
# 
# Elegí cambiar los números por texto, y luego convertirlo en un factor ordenado
# (ver la línea con el comando fct_relevel), de forma que las categorías
# figuren en el mismo orden que el original.
per <- # Asignación para actualizar tabla per
  per %>% 
  mutate(
    codac = ifelse(e27 < 14, 0, NA), # Codificar menores de 14 años
    codac = case_when(
      e27 < 14 ~ "Menores de 14 años", # case_when debe cubrir todos los casos
      ((e27 >= 14) & ((f66 == 1) | 
                        (f67 == 1 & (f261 == 3 | f261 == 1)) | 
                        (f68 == 1))) ~ "Ocupados",
      ((e27 >= 14 & is.na(codac)) &
         ((f106 == 1 & (f107 == 1 | f109 == 1) &
             (f110 > 0 & f110 <= 6)) | 
            (f106 == 1 & (f108 == 2 | f108 == 3)))) ~ "Desocupados",
      TRUE ~ "Inactivos" # Todo lo que no entró en las categorías anteriores
    ),
    # Convertir a codac en factor ordenado (para coherencia en el orden):
    codac = fct_relevel(codac, 
                        c("Menores de 14 años", "Ocupados", 
                          "Desocupados", "Inactivos"))
  )

# Para comprobar que hizo algo coherente:
count(per, codac)

# Diseño de muestreo ----
#
# Necesario para "expandir" los valores a la población total del país. La
# función clave para realizar el contedo *ponderado* de casos es:
#
#     survey_total
#
# Funciona como un sustituto de n(): la conteos agrupados que se usa en
# combinación con las funciones de dplyr: group_by (opcional) y summarise.
# También sustituye a count, ya que es un wrapper de las anteriores.
disp <- per %>% 
  as_survey_design(ids = 1, 
                   strata = c(nomdpto, estred13),
                   weights = pesoano, 
                   variables = c(dpto, nomdpto, codac))

# Observación: utilizando la tabla per podemos obtener conteos de las 
# categorías:
per %>% group_by(codac) %>% summarise(n = n()) # = count(per, codac)

# Pero esta no es una suma ponderada. Para ello es necesario usar survey_total:
disp %>% group_by(codac) %>% summarise(n = survey_total())

# Observación 2: el mismo resultado se obtiene sumando los pesos:
per %>% group_by(codac) %>% summarise(n = sum(pesoano))

# Totales para el país: ----
totpais <- 
  disp %>% 
  group_by(codac) %>% 
  summarise(n = survey_total()) %>% 
  mutate(p = 100 * n / sum(n)) %>% 
  mutate(nomdpto = "Total país") %>% 
  select(nomdpto, codac, p) %>% 
  spread(codac, p) %>% # Ensanchar la tabla
  mutate(`Total activos` = Ocupados + Desocupados,
         Total = `Menores de 14 años` + Ocupados + Desocupados + Inactivos)

# Nota: si no hiciera conteos ponderados, las líneas de group_by y summarise se
# podrían sustituir por:
#     group_by(codac) %>% 
#     summarise(n = n()) %>%
# o
#     count(codac)

# Totales por departamentos: ----
#
# A diferencia del comando anterior, aquí es necesario usar group_by dos veces,
# para que el sum(n) que figura en la línea siguiente (para calcular el
# porcentaje) haga la sumatoria por departamento y no sobre el total de la
# tabla:
codac_dpto <- 
  disp %>% 
  group_by(nomdpto, codac) %>% 
  summarise(n = survey_total()) %>% 
  group_by(nomdpto) %>% 
  mutate(p = 100 * n / sum(n)) %>% 
  select(-n_se, -n) %>% 
  spread(codac, p) %>% 
  mutate(`Total activos` = Ocupados + Desocupados,
         Total = `Menores de 14 años` + Ocupados + Desocupados + Inactivos)

# Montevideo - Interior: ----
#
# El group_by aparece 2 veces aquí, también. Notar que hago una recodificación
# simple al principio.
mvdint <- 
  disp %>%
  filter(nomdpto == "MONTEVIDEO") %>% 
  mutate(mvd = if_else(dpto == 1, "Montevideo", "Total Interior")) %>% 
  group_by(mvd, codac) %>% 
  summarise(n = survey_total()) %>%
  group_by(mvd) %>% 
  mutate(p = 100 * n / sum(n)) %>% 
  select(nomdpto = mvd, codac, p) %>% 
  spread(codac, p) %>% 
  mutate(`Total activos` = Ocupados + Desocupados,
         Total = `Menores de 14 años` + Ocupados + Desocupados + Inactivos)

# Tabla final: ----
#
# Pegar las 3 tablas con el comando bind_rows. El comando select es usado aquí
# para reordenar las columnas.
codac_final <- 
  bind_rows(totpais, mvdint, codac_dpto) %>% 
  select(1, 7:5, 3:4, 2) %>% 
  rename(Departamento = nomdpto) %>% 
  filter(Departamento != "MONTEVIDEO")


# Tabla en formato de publicación ----
# install.packages("kableExtra")

tabla_public <- 
  codac_final %>% 
  kable(digits = 1, format.args = list(decimal.mark = ",")) %>%
  kable_styling(
    bootstrap_options = "striped", 
    full_width = F, 
    position = "center",
    fixed_thead = T
  ) %>% 
  add_header_above(c(" " = 2, "Activos" = 3, " " = 2)) %>% 
  add_header_above(c("Distribución porcentual de la población total, por condición de actividad,  según departamento" = 7),
                   align = "l", font_size = "medium") %>% 
  add_header_above(c("Cuadro 9" = 7), align = "l", 
                   font_size = "medium", line = FALSE) %>% 
  add_indent(c(4:21)) %>% 
  # pack_rows(" ", 1, 3) %>% 
  # pack_rows("Interior", 4, 21)
  footnote(general = "La adición de subtotales puede no reproducir exactamente el total debido a los procesos computacionales de redondeo", 
           general_title = "Nota: ", 
           title_format = "bold") %>% 
  footnote(general = "INE - ECH 2018", 
           general_title = "Fuente: ", 
           title_format = "bold")

print(tabla_public)
