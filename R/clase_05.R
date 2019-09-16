# ECH


# Recodificación usando factores:
f <- hog$dpto %>% as_factor()

fct_count(f)

f1 <- f %>% 
  fct_collapse(Montevideo = "Montevideo",
               group_other = TRUE) %>% 
  fct_recode(Otros = "Other")

fct_count(f1)

# Tablas de contingencia:
table(hog$nomdpto, hog$c1)
table(hog$nomdpto, hog$c1, hog$nom_locagr)

# Usando funciones de dplyr:
hog %>% 
  as_factor %>% # función del paquete haven
  count(nomdpto, c1) %>% 
  pivot_wider(nomdpto, c1, values_from = n,
              values_fill = list(region_4 = 0)) %>% 
  View

# En porcentajes:
hog %>% 
  as_factor %>% # función del paquete haven
  count(nomdpto, c1) %>% 
  group_by(nomdpto) %>% 
  mutate(p = 100 * n / sum(n)) %>% 
  pivot_wider(nomdpto, c1, values_from = c(n, p),
              values_fill = list(region_4 = 0)) %>% 
  select(1, 5, 2, 6, 3, 7, 4, 8) %>% 
  View

# La función complementaria de pivot_wider es pivot_longer y ambas son versiones
# más nuevas de spread y gather (ver tidyr) o cast y melt (de reshape2).
# Ejemplo:
browseURL("https://twitter.com/WeAreRLadies/status/1059520693857996800")

# Paquete que parece prometerdor:
browseURL("https://cran.r-project.org/web/packages/janitor/vignettes/tabyls.html")

# Cuáles es el asunto con las muestras ponderadas?
browseURL("https://en.wikipedia.org/wiki/Stratified_sampling#Mean_and_standard_error")

# Un problema con el SPSS básico:
browseURL("https://ljzigerell.wordpress.com/2014/04/13/problems-with-spss-survey-weights/")

# La extensión Complex Samples se encargaría de esos problemas, aparentemente.

# Estratificación
#
# Para la selección de la muestra la población es particionada en estratos. Los
# estratos reconocen varios niveles de información.
#
# 1. El primer nivel es geográfico y corresponde a los diecinueve departamentos
# del país y a la zona metropolitana.
#
# 2. En un segundo nivel, cada una de las localidades dentro del departamento es
# clasificada en cuatro categorías: 
#   
#   i.  20000 < hab 
#   
#   ii.  5000 < hab < 20000 
#   
#   iii.  200 < hab < 5000 
#   
#   iv. rural o hab < 200


# Si Maldonado o Rocha: v. Zonas balnearias
#
# En el departamento de Montevideo y zona metropolitana se conforman cinco y
# tres estratos socioeconómicos, respectivamente.

hog %>% 
  distinct(nomdpto, nom_locagr, estred13) %>% 
  arrange(nomdpto, nom_locagr, estred13) %>% View

hog %>% 
  distinct(nomdpto, nom_locagr, estred13, secc, segm) %>% 
  arrange(nomdpto, nom_locagr, estred13, secc, segm) %>% View
hog %>% count(nomdpto, nom_locagr, estred13) %>% View

hog %>% pull(segm) %>% unique %>% sort
hog %>% pull(secc) %>% unique %>% sort

hog %>% 
  distinct(nomdpto, estred13, secc, segm) %>% 
  arrange(nomdpto, estred13, secc, segm) %>% View

hog %>% 
  distinct(nomdpto, estred13, secc, segm, pesoano) %>% 
  arrange(nomdpto, estred13, secc, segm) %>% View


dis <- svydesign(data = hog, ids = ~secc+segm, strata = ~nomdpto + estred13, 
                 weights = ~pesoano, nest = TRUE)

dis <- svydesign(data = hog, ids = ~1, strata = ~nomdpto + estred13, 
                 weights = ~pesoano)

svymean(~HT11, dis)

weighted.mean(hog$HT11, hog$pesoano)

mean(hog$HT11)

hog %>% summarise(ingprom = weighted.mean(HT11))

hog %>% 
  group_by(nomdpto) %>%
  # summarise(ingprom = weighted.mean(HT11)) %>%
  summarise(ingprom = weighted.mean(HT11, pesoano)) %>%
  arrange(ingprom) %>% 
  mutate(nomdpto = fct_inorder(nomdpto)) %>% 
  ggplot() +
  aes(nomdpto, ingprom) +
  geom_col() +
  coord_flip()

# Usando el paquete srvyr: survey versión tidyverse 
library(srvyr)

hog <- as_factor(hog)

dis <- hog %>% 
  as_survey_design(ids = 1, strata = c(nomdpto, estred13), weights = pesoano)

dis1 <- hog %>% 
  as_survey_design(ids = 1, strata = c(nomdpto, estred13), weights = pesoano,
                   variables = starts_with("h"))

# Con survey sería:
#   variables = ~h155 + h155_1 + h156 ...

# Acepta rename también:
dis1 <- dis1 %>% rename(ayudaDinero = h155)

dis %>% 
  summarise(ingprom = survey_mean(HT11))

dis %>% 
  summarise(ingprom = survey_mean(HT11, vartype = "ci"))

?survey_mean

dis %>% 
  group_by(nomdpto) %>% 
  summarise(ingprom = survey_mean(HT11, vartype = "ci")) %>% 
  arrange(desc(ingprom))

dis %>% 
  group_by(region_4) %>% 
  summarise(unw_n = unweighted(n()),
            Media = unweighted(mean(HT11)),
            MedPond = survey_mean(HT11),
            total = survey_total()) %>% 
  arrange(desc(total))


dis %>% 
  group_by(region_4) %>% 
  summarise(Media = unweighted(mean(HT11)),
            MedPond = survey_mean(HT11),) %>% 
  arrange(desc(Media)) %>% 
  select(-MedPond_se) %>% 
  pivot_longer(cols = c(Media, MedPond)) %>% 
  ggplot() +
  aes(region_4, value, fill = name, group = name) +
  geom_col(position = "dodge") 
  # theme(axis.text.x=element_text(angle=90,hjust=1))

