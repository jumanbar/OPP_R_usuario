library(tidyverse)
library(haven)
hog <- read_sav("datos/ECH2018/H_2018_TERCEROS.sav")
hog %>% dim
object.size(hog) %>% print(units = "Mb") # 55.7 Mb

per <- read_sav("datos/ECH2018/P_2018_TERCEROS.sav")
per %>% dim
object.size(per) %>% print(units = "Mb") # 356.4

names(per) %>% str_subset("^e51_") %>% dput

names(hog) %>% str_subset("^h[0-9]") %>% dput


# Personas
colsp <- c(names(per)[1:19], "e30", "e26", "e51_2", "e51_3", "e51_4", "e51_5", 
           "e51_6", "e51_7", "e51_7_1", "e51_8", "e51_9", "e51_10", "e51_11")

# Hogares
colsh <- c(names(hog)[1:18], "d23", "d24", "d25", "HT11", "ht19", "h155", "h155_1",
           "h156", "h156_1", "h252", "h252_1", "h158_1", "h158_2", "h159",
           "h160", "h160_1", "h160_2", "h161", "h162",   "h163_1", "h163_2",
           "h164", "h165", "h227", "h166", "h269", "h269_1", "h167_1",
           "h167_1_1", "h167_1_2", "h167_2", "h167_2_1", "h167_2_2", "h167_3",
           "h167_3_1", "h167_3_2", "h167_4", "h167_4_1", "h167_4_2", "h169",
           "h170_1", "h170_2", "h271", "h271_1", "h171", "h171_1", "h171_2",
           "h172", "h172_1", "h173", "h173_1")

per <- select(per, colsp)
object.size(per) %>% print(units = "Mb")
per %>% dim

hog <- select(hog, colsh)
object.size(hog) %>% print(units = "Mb")
hog %>% dim

save(hog, per, file = "datos/ECH2018/HP_seleccion.RData")

write_delim(hog, "datos/ECH2018/H_2018_Terceros_seleccion.dat", delim = "\t")

write_sav(hog, "datos/ECH2018/H_2018_Terceros_seleccion.sav", compress = TRUE)

# Ejemplo de cómo crear una columna (y un vector), con factores del tipo haven
# (etiquetados):
tibble(x = labelled(
  sample(5, 10, replace = TRUE), 
  c("Muy malo" = 1, "Malo" = 2, "Normal" = 3, "Bueno" = 4, "Muy Bueno" = 5)))


