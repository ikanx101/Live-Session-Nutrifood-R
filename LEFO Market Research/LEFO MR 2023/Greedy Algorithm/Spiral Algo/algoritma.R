rm(list=ls())


# ==============================================================================
# libraries
library(dplyr)
library(tidyr)
library(parallel)

# kita ambil dulu function-nya
source("rotator.R")

# kita set corenya berapa
numcore = 2

# banyaknya calon solusi yang hendak di-generate
n_calon_solusi = 200

# berapa banyak SDOA dilakukan
n_SDOA  = 50

# kita buat rumahnya terlebih dahulu

# ==============================================================================


# ==============================================================================
# kita masukin soalnya
df = mtcars %>% select(mpg,wt)
row.names(df) = NULL
df
# ==============================================================================


# ==============================================================================
# kita buat function untuk generate calon solusi dulu
generate_solusi = function(dummy){
  runif(2,min = -100,max = 100)
}

# kita akan buat juga function untuk menghitung obj function
# yakni dengan mencari pasangan x dan y yang meminimumkan MAE
obj_func = function(list){
  # kita buat dulu data framenya
  temp         = df
  temp$x       = list[1]
  temp$y       = list[2]
  temp$mpg_hit = (temp$x * temp$wt) + temp$y 
  Metrics::mae(temp$mpg,temp$mpg_hit)
}
# ==============================================================================


# ==============================================================================
# kita generate calon solusi
# dengan menggunakan parallel computing
calon_solusi = mclapply(1:n_calon_solusi,
                        generate_solusi,
                        mc.cores = numcore)

# kita akan hitung objective function
f_hit        = mcmapply(obj_func,calon_solusi,mc.cores = numcore)

# kita buat matriks rotasi
mat_rotasi   = buat_rot_mat(2*pi/30,2)

# dengan cara memulai SDOAnya
for(iter in 1:n_SDOA){
  # mencari pusat gravitasi
  center_1   = calon_solusi[[which.min(f_hit)]]
  
  # kita lakukan rotasi dan kontraksi
  calon_solusi_new = mcmapply(ro_kon,calon_solusi,mc.cores = numcore)
  calon_solusi     = lapply(seq_len(ncol(calon_solusi_new)), function(i) calon_solusi_new[,i])
  
  # kita akan hitung objective function
  f_hit            = mcmapply(obj_func,calon_solusi,mc.cores = numcore)
  
  # kita print terlebih dahulu
  print(paste0("MAE: ",f_hit[which.min(f_hit)],"..."))
}

# ini adalah hasil akhirnya
solusi = calon_solusi[[which.min(f_hit)]]
solusi











