rm(list=ls())

# libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(factoextra)

# set working directory
setwd("/home/ikanx101/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/Unsupervised/k means")

# import data
df = read.csv("compact disks.csv") %>% janitor::clean_names() %>%
     select(-x) %>%
     rename(x = x_2)

# kita bikin visualisasinya terlebih dahulu
plt = 
  df %>%
  ggplot(aes(x,y)) +
  geom_point()
plt
# ggsave(plt,file = "cluster.png")

elbow = fviz_nbclust(df, kmeans, method = "wss")
# png("elbow.png")
plot(elbow)
# dev.off()

# sillhouette method dan plotnya
siluet = fviz_nbclust(df, kmeans, method = "silhouette")
# png("siluet.png")
plot(siluet)
# dev.off()

# k-means clustering
final = kmeans(df, 4, nstart = 25)

# center dari masing-masing cluster
final$centers

# save hasil cluster ke data awal
data_kmeans = df
data_kmeans$cluster = final$cluster

# berapa banyak isi dari cluster
table(data_kmeans$cluster)

plt = 
  data_kmeans %>%
  ggplot(aes(x,y)) +
  geom_point(aes(color = as.factor(cluster)))
plt
# ggsave(plt,file = "4 means cluster.png")

data_validasi = 
  data_kmeans %>% 
  arrange(cluster) %>% 
  select(-cluster)

matriks = dist(data_validasi,diag = T,upper = T)

df <- melt(as.matrix(matriks), varnames = c("row", "col"))
df %>% ggplot(aes(x = row,y = col)) + geom_tile(aes(fill = value)) 
