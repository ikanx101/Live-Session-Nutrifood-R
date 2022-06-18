rm(list=ls())

library(readxl)
library(dplyr)

# ambil data yang dibutuhkan
df = read_excel("contoh.xlsx") %>% janitor::clean_names()
df = df[1:3]

# bikin dummy variabel utk kebutuhan pisah2
df$id = 1:nrow(df)

# pisah file utama
utama = 
  df %>%
  filter(is.na(raw_mat_3)) %>%
  select(-raw_mat_3)
# kita buat pengelompokan dulu
utama$grup = 1
for(i in 2:nrow(utama)){
  if(utama$id[i] - utama$id[i-1] == 1){utama$grup[i] = utama$grup[i-1]}
  else if(utama$id[i] - utama$id[i-1] != 1){utama$grup[i] = utama$grup[i-1] + 1}
  }


# lihat hasilnya
utama

# ini file yang ada isi raw mat nya
lainnya = 
  df %>%
  filter(!is.na(raw_mat_3))

lainnya$grup = 1
for(i in 2:nrow(lainnya)){
  if(lainnya$id[i] - lainnya$id[i-1] == 1){lainnya$grup[i] = lainnya$grup[i-1]}
  else if(lainnya$id[i] - lainnya$id[i-1] != 1){lainnya$grup[i] = lainnya$grup[i-1] + 1}
  }

# lihat hasilnya
lainnya
