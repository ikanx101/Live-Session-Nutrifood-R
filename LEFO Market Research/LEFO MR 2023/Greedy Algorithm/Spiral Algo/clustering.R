rm(list=ls())
setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/Greedy Algorithm/Spiral Algo")

# ==============================================================================
# libraries
library(dplyr)
library(tidyr)
library(parallel)
library(ggplot2)

# kita ambil dulu function-nya
source("rotator.R")

# kita set corenya berapa
numcore = 7

# banyaknya calon solusi yang hendak di-generate
n_calon_solusi = 7*100

# berapa banyak SDOA dilakukan
n_SDOA  = 25
# ==============================================================================


# ==============================================================================
# kita masukin soalnya
df           = mtcars[1:5]
rownames(df) = NULL



# kita buat function untuk generate calon solusi dulu
generate_solusi = function(dummy){
  sample(1:8,nrow(df),replace = T)
}

# kita akan hitung objective function
obj_function = function(list){
  # masukin clusternya
  list       = round(list,0)
  df$cluster = list
  # kita pecah per cluster
  df_temp    = df %>% group_split(cluster)
  
  # bikin rumah jarak cluster
  jarak_cluster  = rep(0,length(df_temp))
  for(i in 1:length(df_temp)){
    mat                = dist(df_temp[[i]])
    hasil              = TSP::as.TSP(mat)
    output             = TSP::solve_TSP(hasil)
    jarak_cluster[i]   = TSP::tour_length(output) %>% as.numeric()
  }
  # kita akan hukum kalau ada cluster yang hanya berisi 1 titik saja
  hukuman              = table(list) %>% as.data.frame()
  hukuman              = length(hukuman$Freq[hukuman$Freq == 1]) * 10        
  # menghitung total jarak cluster
  output_final         = sum(jarak_cluster) + hukuman
  return(output_final)
}

# ==============================================================================


# ==============================================================================
# kita mulai dari sini

# kita generate calon solusi
# dengan menggunakan parallel computing
calon_solusi = mclapply(1:n_calon_solusi,
                        generate_solusi,
                        mc.cores = numcore)

# kita akan hitung objective function
f_hit        = mcmapply(obj_function,calon_solusi,mc.cores = numcore)

# kita buat matriks rotasi
mat_rotasi   = buat_rot_mat(2*pi/30,
                            # dimensinya sebanyak baris df
                            nrow(df))

# dengan cara memulai SDOAnya
for(iter in 1:n_SDOA){
  # mencari pusat gravitasi
  center_1   = calon_solusi[[which.min(f_hit)]]
  center_1   = round(center_1,0)
  
  # kita lakukan rotasi dan kontraksi
  calon_solusi_new = mcmapply(ro_kon,calon_solusi,mc.cores = numcore)
  calon_solusi     = lapply(seq_len(ncol(calon_solusi_new)), function(i) calon_solusi_new[,i])
  
  # kita akan hitung objective function
  f_hit            = mcmapply(obj_function,calon_solusi,mc.cores = numcore)
  
  # kita print terlebih dahulu
  print(paste0("Jarak cluster ",f_hit[which.min(f_hit)],"..."))
}

center_1   = calon_solusi[[which.min(f_hit)]]
center_1   = round(center_1,0)
df$cluster = center_1
obj_function(center_1)
length(unique(df$cluster))
