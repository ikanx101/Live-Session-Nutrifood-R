setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/Unsupervised/data kodepos dan longlat")

rm(list=ls())

library(dplyr)
library(cluster)
library(factoextra)
library(ggplot2)
library(readxl)

df = read_excel("hasil cluster.xlsx")

colnames(df)

data_validasi = 
  df %>% 
  select(lat,lng,cluster) %>% 
  arrange(cluster) %>% 
  select(-cluster)

matriks = dist(data_validasi,diag = T,upper = T)

df <- melt(as.matrix(matriks), varnames = c("row", "col"))
df %>% ggplot(aes(x = row,y = col)) + 
       geom_tile(aes(fill = value)) + 
       scale_fill_gradient(low = "blue",high = "darkred") +
       theme_void() +
       theme(legend.position = "none") + coord_equal()
