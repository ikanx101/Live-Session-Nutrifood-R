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

dbscan::kNNdistplot(data_cl, k = 30)
abline(h = .35, lty = 2, col = "red")

# membuat clustering DBScan
# set sed agar reproducible
set.seed(20921004)
Dbscan_cl = dbscan(data_cl, eps = 0.35, minPts = 5)

# menambahkan cluster ke dalam dataset
data_cl$cluster = Dbscan_cl$cluster

# menghitung ada berapa banyak cluster yang ada
data_cl$cluster %>% unique() %>% length()