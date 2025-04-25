# https://keras3.posit.co/articles/examples/index.html

# Kita bersihkan hati dan pikiran dulu
rm(list=ls())
gc()

# panggil package yang akan digunakan
library(keras3)
library(tensorflow)
library(EBImage)
library(dplyr)
library(tidyr)
library(parallel)
library(janitor)

# berapa banyak cores
ncore = detectCores()

# set working directory
setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2025/Q1 Image/image_check")

# ambil semua nama folder
folder_all = list.dirs() %>% .[2:4]

# semua list files
al  = list.files(folder_all[1],full.names = T)
el  = list.files(folder_all[3],full.names = T)
dul = list.files(folder_all[2],full.names = T)

# kita akan buat function untuk melakukan pembacaan dan resize image
# definisikan dulu width dan height
w = 50
h = 50

bacain = function(nama_gambar){
  gambar = readImage(nama_gambar)
  gambar = resize(gambar,w,h)
  # karena bentuk imagenya png jadi ada 4 layer ya
  output = array_reshape(gambar,c(w,h,4))
  return(output)
}

# kita baca semua images dari al el dan dul
al_img  = mclapply(al,bacain,mc.cores = ncore)
el_img  = mclapply(el,bacain,mc.cores = ncore)
dul_img = mclapply(dul,bacain,mc.cores = ncore)

# Nah, kita buat matriks al
X_al = NULL
for (i in 1:10){
  X_al = rbind(X_al, al_img[[i]])
} 

# Nah, kita buat matriks al
X_el = NULL
for (i in 1:10){
  X_el = rbind(X_el, el_img[[i]])
} 

# Nah, kita buat matriks al
X_dul = NULL
for (i in 1:10){
  X_dul = rbind(X_dul, dul_img[[i]])
} 

# sekarang kita load model yang sudah dibuat
setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2025/Q1 Image/image_data")
model <- load_model("model_belajar_lagi_lagi_lagi.keras")

# sekarang kita hitung peluang masing-masing anaknya
al_result = 
  model %>% predict(X_al) %>% as.data.frame() %>% 
  mutate(result = ifelse(V1 > V2,"Dhani","Maia")) %>% 
  tabyl(result) %>% 
  adorn_totals() %>% 
  adorn_pct_formatting()
  
el_result = 
  model %>% predict(X_el) %>% as.data.frame() %>% 
  mutate(result = ifelse(V1 > V2,"Dhani","Maia")) %>% 
  tabyl(result) %>% 
  adorn_totals() %>% 
  adorn_pct_formatting()

dul_result = 
  model %>% predict(X_dul) %>% as.data.frame() %>% 
  mutate(result = ifelse(V1 > V2,"Dhani","Maia")) %>% 
  tabyl(result) %>% 
  adorn_totals() %>% 
  adorn_pct_formatting()

al_result
el_result
dul_result

setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2025/Q1 Image/image_check")
# plot(readImage(dul[3]))

