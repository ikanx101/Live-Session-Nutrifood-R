rm(list=ls())

library(dplyr)
library(cluster)
library(factoextra)
library(ggplot2)

setwd("/home/ikanx101/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/Unsupervised/hierarchical")

df = read.csv("hi.csv") %>% janitor::clean_names() %>%
     select(x_2,y) %>%
     rename(x = x_2)

# Finding distance matrix
distance_mat = dist(df, method = 'euclidean')

# Fitting Hierarchical clustering Model
set.seed(240)  # Setting seed
Hierar_cl = hclust(distance_mat, method = "single")
# pake single ini
 
# Plotting dendrogram
# png('hie.png')
plot(Hierar_cl)
# dev.off()

# Pemecahan menjadi 3 cluster
fit = cutree(Hierar_cl, k = 2)
table(fit)
# png('hie final.png')
plot(Hierar_cl)
rect.hclust(Hierar_cl, k = 2, border = "red")
# dev.off()

# save hasil cluster ke data awal
data_hc = df
data_hc$cluster = fit

# berapa banyak isi dari cluster
hie_plot = 
  data_hc %>%
  ggplot(aes(x,y,color = as.factor(cluster))) +
  geom_point()
hie_plot
# ggsave(hie_plot,file = "hierarki final.png")


data_validasi = 
  data_hc %>% 
  arrange(cluster) %>% 
  select(-cluster)

matriks = dist(data_validasi,diag = T,upper = T)

df <- melt(as.matrix(matriks), varnames = c("row", "col"))
df %>% ggplot(aes(x = row,y = col)) + geom_tile(aes(fill = value)) 
