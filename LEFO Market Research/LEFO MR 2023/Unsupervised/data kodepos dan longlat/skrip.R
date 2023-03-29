# =======================================================================
# bebersih global environment
rm(list=ls())
setwd("/cloud/project/LEFO Market Research/LEFO MR 2023/Unsupervised/data kodepos dan longlat")

# libraries
library(dplyr)
library(tidyr)
library(cluster)
library(caret)
library(factoextra)
library(ggplot2)
# =======================================================================


# =======================================================================
# mengambil data
df      = 
  read.csv("dbase kodepos longlat.csv") %>%
  janitor::clean_names() %>%
  select(-x,-url,-kode_pos) %>% 
  distinct() %>% 
  arrange(provinsi,kota_kab,kecamatan) %>% 
  filter(grepl("jawa|banten|karta|bogor",provinsi,ignore.case = T))

# reserve lat dan long
data_n2 = df %>% select(lat,lng)

# Finding distance matrix
distance_mat = dist(data_n2, method = 'euclidean')

# Fitting Hierarchical clustering Model
set.seed(10104074)  # Setting seed
Hierar_cl = hclust(distance_mat, method = "complete")
Hierar_cl
plot(Hierar_cl)

# Pemecahan menjadi k cluster
# banyak cluster
n_cluster = 13

# kita fit ke modelnya
fit = cutree(Hierar_cl, k = n_cluster)
plot(Hierar_cl)
rect.hclust(Hierar_cl, k = n_cluster, border = "steelblue")
table(fit)

# save hasil cluster ke data awal
df$cluster_metode_1 = fit

# kita arrange dulu
df %>% 
  ggplot(aes(lat,lng)) +
  geom_point(aes(color = as.factor(cluster_metode_1))) +
  ggrepel::geom_text_repel(aes(label = cluster_metode_1),
                           size = 2) +
  theme(legend.position = "none")

