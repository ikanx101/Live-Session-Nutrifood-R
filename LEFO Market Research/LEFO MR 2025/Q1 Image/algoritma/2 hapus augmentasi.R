# hapus kepalsuan
rm(list=ls())

library(dplyr)

setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2025/Q1 Image/image_data")

folders = list.dirs()
folders = folders[2:3]

target = list.files(folders,full.names = T)
target = target[grepl("augmentasi",target)]
unlink(target)