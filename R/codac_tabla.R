# Contexto ----
# Basado en el documento publicado por INE con la ECH 2018:
# browseURL("http://www.ine.gub.uy/c/document_library/get_file?uuid=beb740f9-4da4-4f57-9b24-519d7bf72faa&groupId=10181")

# CODAC: clasifica la población en 4 grandes grupos:
# 0: menores de 14 años
# 1: ocupados
# 2: desocupados
# 3: inactivos

# Importación ----
library(haven)
library(tidyverse)
per <- read_sav("datos/ECH2018/P_2018_TERCEROS.sav")

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

count(per, codac)

disp <- 
  per %>% 
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
  spread(codac, p) %>% 
  mutate(`Total activos` = Ocupados + Desocupados,
         Total = `Menores de 14 años` + Ocupados + Desocupados + Inactivos)
totpais

# Totales por departamentos: ----
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

codac_dpto

# Montevideo - Interior: ----
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

mvdint  

# Tabla final: ----
codac_final <- 
  bind_rows(totpais, mvdint, codac_dpto) %>% 
  select(1, 7:5, 3:4, 2) %>% 
  filter(nomdpto != "MONTEVIDEO")


# Tabla en formato de publicación ----
# install.packages("kableExtra")

library(kableExtra)

codac_final %>% 
  rename(Departamento = nomdpto) %>% 
  kable() %>%
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
