# Basado en el documento publicado por INE con la ECH 2018:
# http://www.ine.gub.uy/c/document_library/get_file?uuid=beb740f9-4da4-4f57-9b24-519d7bf72faa&groupId=10181

library(haven)
library(tidyverse)
per <- read_sav("datos/ECH2018/P_2018_TERCEROS.sav")

per <- 
  per %>% 
  mutate(
    codac = ifelse(e27 < 14, 0, NA),
    codac = case_when(
      e27 < 14 ~ 0,
      ((e27 >= 14) & ((f66 == 1) | 
                        (f67 == 1 & (f261 == 3 | f261 == 1)) | 
                        (f68 == 1))) ~ 1,
      ((e27 >= 14 & is.na(codac)) &
         ((f106 == 1 & (f107 == 1 | f109 == 1) &
             (f110 > 0 & f110 <= 6)) | 
            (f106 == 1 & (f108 == 2 | f108 == 3)))) ~ 2,
      TRUE ~ 3
    )
  )

count(per, codac)
