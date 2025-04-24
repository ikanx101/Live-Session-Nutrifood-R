# https://www.rpubs.com/afrian/742904
# skrip untuk melakukan image augmentation
# dimulai dari nol
rm(list=ls())
gc()

# libraries yang diperlukan
library(dplyr)
library(tidyr)
library(EBImage)
library(parallel)

# berapa banyak cores
ncore = detectCores()

# list semua folders yang terlibat
folder_all    = list.dirs("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2025/Q1 Image/image_data")

# function untuk augmentasi
augmentasikan = function(target_foto){
  # baca image nya dulu
  gambar = readImage(target_foto)
  
  # kita ubah kontrasnya
  randomin = runif(1)
  gambar_1 = gambar + randomin
  
  # ubah lagi
  randomin = runif(1)
  gambar_2 = gambar + randomin
  
  # ubah lagi
  randomin = runif(1)
  gambar_3 = gambar ^ randomin
  
  # kita puter
  gambar_4 = transpose(gambar)
  
  # kita rotate
  randomin = runif(1) * 100
  gambar_5 = rotate(gambar, randomin, bg.col = "white")
  
  # kita flip dan flop
  gambar_6 = flip(gambar)
  gambar_7 = flop(gambar)
  
  # kita blur
  randomin = sample(c(9,11,13,15,17,19,21),1)
  w        = makeBrush(size = randomin, shape = 'gaussian', sigma = 4)
  gambar_8 = filter2(gambar, w)
  
  # kita rotate lagi
  randomin = runif(1) * 100
  gambar_9 = rotate(gambar, randomin, bg.col = "white")
  
  nama_file = gsub(".png","",target_foto)
  nama_file = paste0(nama_file," augmentasi ",1:9,".png")
  
  writeImage(gambar_1,nama_file[1], quality = 100)
  writeImage(gambar_2,nama_file[2], quality = 100)
  writeImage(gambar_3,nama_file[3], quality = 100)
  writeImage(gambar_4,nama_file[4], quality = 100)
  writeImage(gambar_5,nama_file[5], quality = 100)
  writeImage(gambar_6,nama_file[6], quality = 100)
  writeImage(gambar_7,nama_file[7], quality = 100)
  writeImage(gambar_8,nama_file[8], quality = 100)
  writeImage(gambar_9,nama_file[9], quality = 100)
  
  print("DONE")
}

# lakukan
for(i in 2:length(folder_all)){
  folder_target = folder_all[i]
  setwd(folder_target)
  jpegs = list.files()
  mcmapply(augmentasikan,jpegs,mc.cores = ncore)
}


