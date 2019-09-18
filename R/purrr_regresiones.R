library(tidyverse)
library(haven)
library(srvyr)
hog <- read_sav("datos/ECH2018/H_2018_TERCEROS.sav") %>% as_factor

# Evaluar ingreso en función de cantidad de personas en el hogar.
# 
# Sacar los R cuadrado de regresiones por departamento:
hog %>% 
  split(.$nomdpto) %>% 
  map(~ lm(HT11 ~ d25 + 0, data = .)) %>% 
  map(summary) %>% 
  map_dbl("r.squared")
  
# Crear datos anidados:
hog %>% 
  group_by(nomdpto) %>% 
  nest()

# Hacer regresiones por departamento y localidad agrupada:
hog %>% 
  group_by(nomdpto, nom_locagr) %>% 
  nest() %>% 
  mutate(model = map(data, ~ lm(HT11 ~ d25 + 0, data = .)))

# Ver las columnas creadas...  

# Hacer regresiones por departamento y localidad agrupada, y finalmente crear
# columnas con coeficientes y R cuadrados:
hogreg <- 
  hog %>% 
  group_by(nomdpto, nom_locagr) %>% 
  nest() %>% 
  mutate(model = map(data, ~ lm(HT11 ~ d25 + 0, data = .)),
         n = map_int(data, ~ nrow(.)),
         coe = map_dbl(model, ~ .$coefficients),
         rsq = map_dbl(model, ~ summary(.)$r.squared))

# Vistazo a la tabla (anidada) completa:
hogreg

# Vistazo, empezando por los valores más altos de R cuadrado:
hogreg %>% 
  select(-data, -model) %>% 
  arrange(desc(rsq))

# En un par de casos el R cuadrado equivale a 1
which(hogreg$rsq == 1)

filter(hogreg, rsq == 1)

filter(hogreg, n > 30) %>%   
  select(-data, -model) %>% 
  arrange(desc(rsq))

hog %>% 
  ggplot() +
  aes(d25, HT11, col = nomdpto) +
  geom_point() + 
  scale_y_log10() + 
  geom_jitter()


dish <- as_survey_design(hog, strata = c(nomdpto, estred13), weights = pesoano)
dptos <- levels(hog$dpto)

nfinal <- hog %>% distinct(dpto, nom_locagr) %>% nrow

modelos <- vector("list")

for (i in 1:length(dptos)) {
  cat("Departamento:", dptos[i], "\n")
  hogdpto <- dish %>% filter(dpto == dptos[i]) 
  
  lagr <- hogdpto$variables %>% pull(nom_locagr) %>% unique
  
  for (j in 1:length(lagr)) {
    print(lagr[j])
    
    modelos[[i + j - 1]] <- 
      svyglm(HT11 ~ d25, design = filter(hogdpto, nom_locagr == lagr[j]))
  }
}
  

dish %>% 
  split(.$nomdpto)
  group_by(nomdpto, nom_locagr) %>% 
  nest() %>%
  mutate(model = map(data, ~ svyglm(HT11 ~ d25 + 0, design = .)),
         n = map_int(data, ~ nrow(.)),
         coe = map_dbl(model, ~ .$coefficients),
         rsq = map_dbl(model, ~ summary(.)$r.squared))
