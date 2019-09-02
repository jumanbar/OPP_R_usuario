# Fuente:
# http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html#Histogram
library(ggplot2)
theme_set(theme_classic())

mpg$class <- dplyr::recode(mpg$class, 
                    compact = "compacto", midsize = "mediano", suv = "vud",
                    `2seater` = "2asientos",  subcompact = "subcompacto")

# Histograma en una variable continua numérica:
g <- 
  ggplot(mpg) + 
  aes(displ, fill = class) +
  scale_fill_brewer(palette = "Spectral") +
  xlab("Desplazamiento")

g1 <- g + geom_histogram(binwidth = .1, col="black", size=.1) +  # change binwidth
  labs(
    title="Histograma con segmentación automática", 
    subtitle="Desplazamiento de motor para diferentes categorías de vehículos",
    tag="(fig. 1)")
g2 <- g + geom_histogram(bins=5, col="black", size=.1) +   # change number of bins
  labs(
    title="Histograma con segmentación fija", 
    subtitle="Desplazamiento de motor para diferentes categorías de vehículos",
    tag = "(fig. 2)") 

print(g1)
print(g2)