# Contexto ----
# Basado en el documento publicado por INE con la ECH 2018:
# browseURL("http://www.ine.gub.uy/c/document_library/get_file?uuid=beb740f9-4da4-4f57-9b24-519d7bf72faa&groupId=10181")

# CODAC: clasifica la población en 4 grandes grupos:
# 0: menores de 14 años
# 1: ocupados
# 2: desocupados
# 3: inactivos

# Para realizar la tabla la estrategia es:
# 
# 1. Crear 3 tablas (total país, mvd+interior, resto de los dptos)
# 
# 2. Pegar las tablas con bind_rows
# 
# 3. Darle formato de publicación a la tabla (con el paquete kableExtra)

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
per <- 
  per %>% 
  mutate(
    codac = ifelse(e27 < 14, 0, NA),
    codac = case_when(
      e27 < 14 ~ "Menores de 14 años",
      ((e27 >= 14) & ((f66 == 1) | 
                        (f67 == 1 & (f261 == 3 | f261 == 1)) | 
                        (f68 == 1))) ~ "Ocupados",
      ((e27 >= 14 & is.na(codac)) &
         ((f106 == 1 & (f107 == 1 | f109 == 1) &
             (f110 > 0 & f110 <= 6)) | 
            (f106 == 1 & (f108 == 2 | f108 == 3)))) ~ "Desocupados",
      TRUE ~ "Inactivos"
    ),
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
