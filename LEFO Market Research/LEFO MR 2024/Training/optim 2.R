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
df   = df %>% select(nik,nama,golongan,divisi,work_location) 

# kita bagi dua deh
bagi_dua = sample(2,nrow(df),replace = T)
df       = df %>% mutate(bagi = bagi_dua)

df = 
  df %>% 
  mutate(bagi = case_when(
    divisi == "Sales and Distribution Division" ~ 1,
    grepl("strategic|media|development|plant",divisi,ignore.case = T) ~ 1,
    grepl("finance|human|area|audit|integration",divisi,ignore.case = T) ~ 2,
    grepl("affair|komisaris|procurement|sustain|nutrifood|office|information",divisi,ignore.case = T) ~ 3
  )) 

# kita bagi berdasarkan work location
df_split = df %>% group_split(bagi) #group_split(golongan,divisi,work_location)

df_1 = df_split[[1]]
df_2 = df_split[[2]]
df_3 = df_split[[3]]
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
mat_rotasi = buat_rot_mat(2*pi / 25,nrow(df_1))


# kita akan lakukan soa ke work location ini
big_bang = function(dummy){
  sample(1:5,nrow(df_1),replace = T)
}

# objective function
obj_func = function(solusi){
  # ambil kelompok 1 hinggal 11
  kelompok_1 = which(solusi == 1)
  kelompok_1 = df_1[kelompok_1,]
  
  kelompok_2 = which(solusi == 2)
  kelompok_2 = df_1[kelompok_2,]
  
  kelompok_3 = which(solusi == 3)
  kelompok_3 = df_1[kelompok_3,]
  
  kelompok_4 = which(solusi == 4)
  kelompok_4 = df_1[kelompok_4,]

  kelompok_5 = which(solusi == 5)
  kelompok_5 = df_1[kelompok_5,]
  
  if(is.null(kelompok_1)){kelompok_1 = data.frame()}
  if(is.null(kelompok_2)){kelompok_2 = data.frame()}
  if(is.null(kelompok_3)){kelompok_3 = data.frame()}
  if(is.null(kelompok_4)){kelompok_4 = data.frame()}
  if(is.null(kelompok_5)){kelompok_5 = data.frame()}
  
  # hitung nilai skor
  bts    = 34
  skor_1 = sum(c(max(nrow(kelompok_1) - bts,0),
                 max(nrow(kelompok_2) - bts,0),
                 max(nrow(kelompok_3) - bts,0),
                 max(nrow(kelompok_4) - bts,0),
                 max(nrow(kelompok_5) - bts,0))
                )
  
  bts_2 = .37
  proporsi_mgr_1 = 
    kelompok_1 %>% 
    filter(golongan %in% c("MGR","SPC")) %>% 
    summarise(length(nik) / nrow(kelompok_1)) %>% 
    as.numeric()
  
  proporsi_mgr_2 = 
    kelompok_2 %>% 
    filter(golongan %in% c("MGR","SPC")) %>% 
    summarise(length(nik) / nrow(kelompok_2)) %>% 
    as.numeric()
  
  proporsi_mgr_3 = 
    kelompok_3 %>% 
    filter(golongan %in% c("MGR","SPC")) %>% 
    summarise(length(nik) / nrow(kelompok_3)) %>% 
    as.numeric()
  
  proporsi_mgr_4 = 
    kelompok_4 %>% 
    filter(golongan %in% c("MGR","SPC")) %>% 
    summarise(length(nik) / nrow(kelompok_4)) %>% 
    as.numeric()
  
  proporsi_mgr_5 = 
    kelompok_5 %>% 
    filter(golongan %in% c("MGR","SPC")) %>% 
    summarise(length(nik) / nrow(kelompok_5)) %>% 
    as.numeric()
  
  skor_2 = sum(c(max(proporsi_mgr_1 - bts_2,0),
                 max(proporsi_mgr_2 - bts_2,0),
                 max(proporsi_mgr_3 - bts_2,0),
                 max(proporsi_mgr_4 - bts_2,0),
                 max(proporsi_mgr_5 - bts_2,0)
                 )
               )
  
  # kembalikan skornya
  return(skor_1 + (skor_2 * 100))
}

# ==============================================================================


# ==============================================================================
# berapa banyak calon solusi
N     = n_core * 60
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
    X  = bhole + (.45 * X)
    X  = round(X)
    X[X > 5] = 1
    X[X < 1] = 5
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
kelompok_1 = df_1[kelompok_1,]

kelompok_2 = which(solusi == 2)
kelompok_2 = df_1[kelompok_2,]

kelompok_3 = which(solusi == 3)
kelompok_3 = df_1[kelompok_3,]

kelompok_4 = which(solusi == 4)
kelompok_4 = df_1[kelompok_4,]

kelompok_5 = which(solusi == 5)
kelompok_5 = df_1[kelompok_5,]

table(kelompok_1$golongan)
table(kelompok_2$golongan)
table(kelompok_3$golongan)
table(kelompok_4$golongan)
table(kelompok_5$golongan)

save(kelompok_1,kelompok_2,kelompok_3,kelompok_4,kelompok_5,file = "batch 1.rda")
