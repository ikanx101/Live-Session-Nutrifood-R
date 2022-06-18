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
# kita beberes biar nanti langsung tempel
colnames(utama)[1:2] = c("prod_code","prod_desc")
utama = utama %>% select(-id) %>% group_split(grup)

# lihat hasilnya
utama

# ini file yang ada isi raw mat nya
lainnya = 
  df %>%
  filter(!is.na(raw_mat_3))
# kita buat pengelompokan dengan cara yang sama dengan sebelumnya
lainnya$grup = 1
for(i in 2:nrow(lainnya)){
  if(lainnya$id[i] - lainnya$id[i-1] == 1){lainnya$grup[i] = lainnya$grup[i-1]}
  else if(lainnya$id[i] - lainnya$id[i-1] != 1){lainnya$grup[i] = lainnya$grup[i-1] + 1}
  }
# kita beberes lagi agar nanti tinggal dimatching-kan
colnames(lainnya)[1:2] = c("form_code","form_desc")
lainnya = lainnya %>% select(-id) %>% group_split(grup)

# lihat hasilnya
lainnya

# =======================================================
# saatnya kita gabung

# siapin rumah untuk menampungnya
n = length(utama)
hasil = vector("list",n)

# mulai iterasinya
for(i in 1:n){
  # ambil data per grup
  temp_1 = utama[[i]] %>% select(-grup)
  temp_2 = lainnya[[i]] %>% select(-grup)
  
  # hitung baris
  n1 = nrow(temp_1)
  n2 = nrow(temp_2)
  # jika barisnya kurang, maka diisi dulu
  if(n1 < n2){
   for(j in (n1+1):n2){
    temp_1[j,] = list(NA,NA)
    }
  }
  # gabung
  hasil[[i]] =  cbind(temp_1,temp_2)
}

# gabung hasilnya
final = do.call(rbind,hasil)

# ini hasilnya yaa
final

# export ke csv
write.csv(final,"hasil_akhir.csv")
