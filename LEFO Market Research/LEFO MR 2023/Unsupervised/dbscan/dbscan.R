# membersihkan global environment
rm(list=ls())
setwd("/home/ikanx101/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/Unsupervised/dbscan")

# memanggil semua libraries pada komputasi ini
library(dplyr)
library(ggplot2)
library(fpc)
library(dbscan)

# ambil data
df = read.csv("donat density.csv") %>% janitor::clean_names() %>% 
     select(-x) %>% rename(x = x_2)

colnames(df)

df |>
  ggplot(aes(x,y)) +
  geom_point()

dbscan::kNNdistplot(df, k = 30)
abline(h = .25, lty = 2, col = "red")

# membuat clustering DBScan
# set sed agar reproducible
set.seed(20921004)
Dbscan_cl = dbscan(df, eps = 0.25, minPts = 5)

# menambahkan cluster ke dalam dataset
df$cluster_new = Dbscan_cl$cluster

# menghitung ada berapa banyak cluster yang ada
df$cluster_new %>% unique() %>% length()

df |>
  ggplot(aes(x,y)) +
  geom_point(aes(color = as.factor(cluster_new)),
             size = 2)
