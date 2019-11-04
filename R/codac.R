# Basado en el documento publicado por INE con la ECH 2018:
# http://www.ine.gub.uy/c/document_library/get_file?uuid=beb740f9-4da4-4f57-9b24-519d7bf72faa&groupId=10181

# Recodificación: CODAC ----
# 
# # CODAC: clasifica la población en 4 grandes grupos:
# 0: menores de 14 años
# 1: ocupados
# 2: desocupados
# 3: inactivos
# 
# Elegí cambiar los números por texto, y luego convertirlo en un factor ordenado
# (ver la línea con el comando fct_relevel), de forma que las categorías
# figuren en el mismo orden que el original.

# Importación ----
require(haven)
require(tidyverse)
require(srvyr)
# require(kableExtra)
unzip("datos/ECH2018/P_2018_TERCEROS.zip", exdir = "datos/ECH2018/")

# Es necesario *NO* aplicar as_factor para que funcione la recodificación:
per <- read_sav("datos/ECH2018/P_2018_TERCEROS.sav") 

# El archivo P_2018_TERCEROS.sav se puede descargar de la página de la ECH del
# INE:
# http://www.ine.gub.uy/c/document_library/get_file?uuid=b63b566f-8d11-443d-bcd8-944f137c5aaf&groupId=10181

per <- # Asignación para actualizar tabla per
  per %>% 
  select(anio:nper, e27, f66, f67, f261, f68, f106, f107, f108, f109, f110) %>% 
  mutate(
    # Codificar menores de 14 años (EL NA es necesario más tarde):
    codac = ifelse(e27 < 14, 0, NA),
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

# Ejercicio: -----
# 
# Una comparación útil son los conteos ponderados, ya que nos permite ver si: la
# suma total de personas es coerente o si los cálculos publicados por el INE son
# similares (ver archivo PDF con microdatos en datos/ECH2018).
# 
# Por qué la columna p obtenida (de porcentaje) da siempre 100?:
per %>% 
  group_by(codac) %>% 
  summarise(n = sum(pesoano), 
            p = 100 * n / sum(n))

# Cómo hay que hacer para que esto no pase?

# Respuesta: ─────────────────


# ────────────────────────────


# Solución:
per %>% 
  group_by(codac) %>% 
  summarise(n = sum(pesoano)) %>% 
  mutate(p = 100 * n / sum(n))
