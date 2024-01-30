# ==============================================================================
rm(list=ls())
setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2024/Training")

library(readxl)
library(dplyr)
library(tidyr)
library(parallel)
n_core = detectCores() 

path = "Workshop_Participants_Groups(1).xlsx"
df   = read_excel(path) %>% janitor::clean_names()
df   = df %>% select(nik,golongan,divisi,work_location) 

# kita bagi dua deh
bagi_dua = sample(2,nrow(df),replace = T)
df       = df %>% mutate(bagi = bagi_dua)

# kita bagi berdasarkan work location
df_split = df %>% group_split(bagi) #group_split(golongan,divisi,work_location)
# ==============================================================================


# ==============================================================================
# the functions

# function matriks rotasi
buat_rot_mat = function(theta,n){
  # buat template sebuah matriks identitas
  temp_mat = matrix(0,ncol = n,nrow = n)
  diag(temp_mat) = 1
  
  # buat matriks identitas terlebih dahulu
  mat_rot = temp_mat
  
  for(i in 1:(n-1)){
    for(j in 1:i){
      temp = temp_mat
      idx = n-i
      idy = n+1-j
      # print(paste0("Matriks rotasi untuk ",idx," - ",idy,": DONE"))
      temp[idx,idx] = cos(theta)
      temp[idx,idy] = -sin(theta)
      temp[idy,idx] = sin(theta)
      temp[idy,idy] = cos(theta)
      # assign(paste0("M",idx,idy),temp)
      mat_rot = mat_rot %*% temp
      mat_rot = mat_rot 
    }
  }
  return(mat_rot)
}

# kita bat matriks rotasi
mat_rotasi = buat_rot_mat(2*pi / 25,length(df_split))


# kita akan lakukan soa ke work location ini
big_bang = function(dummy){
  sample(1:11,length(df_split),replace = T)
}

# objective function
obj_func = function(solusi){
  # ambil kelompok 1 hinggal 11
  kelompok_1 = which(solusi == 1)
  kelompok_1 = do.call(rbind,df_split[kelompok_1])
  kelompok_2 = which(solusi == 2)
  kelompok_2 = do.call(rbind,df_split[kelompok_2])
  kelompok_3 = which(solusi == 3)
  kelompok_3 = do.call(rbind,df_split[kelompok_3])
  kelompok_4 = which(solusi == 4)
  kelompok_4 = do.call(rbind,df_split[kelompok_4])
  kelompok_5 = which(solusi == 5)
  kelompok_5 = do.call(rbind,df_split[kelompok_5])
  kelompok_6 = which(solusi == 6)
  kelompok_6 = do.call(rbind,df_split[kelompok_6])
  kelompok_7 = which(solusi == 7)
  kelompok_7 = do.call(rbind,df_split[kelompok_7])
  kelompok_8 = which(solusi == 8)
  kelompok_8 = do.call(rbind,df_split[kelompok_8])
  kelompok_9 = which(solusi == 9)
  kelompok_9 = do.call(rbind,df_split[kelompok_9])
  kelompok_10 = which(solusi == 10)
  kelompok_10 = do.call(rbind,df_split[kelompok_10])
  kelompok_11 = which(solusi == 11)
  kelompok_11 = do.call(rbind,df_split[kelompok_11])
  
  if(is.null(kelompok_1)){kelompok_1 = data.frame()}
  if(is.null(kelompok_2)){kelompok_2 = data.frame()}
  if(is.null(kelompok_3)){kelompok_3 = data.frame()}
  if(is.null(kelompok_4)){kelompok_4 = data.frame()}
  if(is.null(kelompok_5)){kelompok_5 = data.frame()}
  if(is.null(kelompok_6)){kelompok_6 = data.frame()}
  if(is.null(kelompok_7)){kelompok_7 = data.frame()}
  if(is.null(kelompok_8)){kelompok_8 = data.frame()}
  if(is.null(kelompok_9)){kelompok_9 = data.frame()}
  if(is.null(kelompok_10)){kelompok_10 = data.frame()}
  if(is.null(kelompok_11)){kelompok_11 = data.frame()}
  
  # hitung nilai skor
  bts  = 27
  skor = sum(c(abs(nrow(kelompok_1) - bts),
                abs(nrow(kelompok_2) - bts),
                abs(nrow(kelompok_3) - bts),
                abs(nrow(kelompok_4) - bts),
                abs(nrow(kelompok_5) - bts),
                abs(nrow(kelompok_6) - bts),
                abs(nrow(kelompok_7) - bts),
                abs(nrow(kelompok_8) - bts),
                abs(nrow(kelompok_9) - bts),
                abs(nrow(kelompok_10) - bts),
                abs(nrow(kelompok_11) - bts))
              )
  # kembalikan skornya
  return(skor)
}

# ==============================================================================


# ==============================================================================
# berapa banyak calon solusi
N     = n_core * 150
N_lis = 1:N
star  = mclapply(N_lis,big_bang,mc.cores = n_core)

f_hit = mclapply(star,obj_func,mc.cores = n_core) %>% unlist()

# mulai part serunya
for(ikanx in 1:20){
  # penentuan black hole
  n_bhole = which.min(f_hit)
  bhole   = star[[n_bhole]]
  
  for(i in 1:N){
    Xt = star[[i]]
    X  = mat_rotasi %*% (Xt - bhole)
    X  = bhole + (.65 * X)
    X  = round(X)
    X[X > 11] = 11
    X[X < 1] = 1
    star[[i]] = X
  }
  
  # perhitungan obj function
  f_hit = mclapply(star,obj_func,mc.cores = n_core) %>% unlist()
  
  # print dulu
  cat(" - obj fun: ")
  print(obj_func(bhole))
  cat("- f_tot: ")
  print(min(f_hit))
  print(ikanx)
}

print(which.min(f_hit))
hasil = which.min(f_hit)
solusi = star[[hasil]] %>% round() %>% abs()

# ambil kelompok 1 hinggal 11
kelompok_1 = which(solusi == 1)
kelompok_1 = do.call(rbind,df_split[kelompok_1])
kelompok_2 = which(solusi == 2)
kelompok_2 = do.call(rbind,df_split[kelompok_2])
kelompok_3 = which(solusi == 3)
kelompok_3 = do.call(rbind,df_split[kelompok_3])
kelompok_4 = which(solusi == 4)
kelompok_4 = do.call(rbind,df_split[kelompok_4])
kelompok_5 = which(solusi == 5)
kelompok_5 = do.call(rbind,df_split[kelompok_5])
kelompok_6 = which(solusi == 6)
kelompok_6 = do.call(rbind,df_split[kelompok_6])
kelompok_7 = which(solusi == 7)
kelompok_7 = do.call(rbind,df_split[kelompok_7])
kelompok_8 = which(solusi == 8)
kelompok_8 = do.call(rbind,df_split[kelompok_8])
kelompok_9 = which(solusi == 9)
kelompok_9 = do.call(rbind,df_split[kelompok_9])
kelompok_10 = which(solusi == 10)
kelompok_10 = do.call(rbind,df_split[kelompok_10])
kelompok_11 = which(solusi == 11)
kelompok_11 = do.call(rbind,df_split[kelompok_11])



