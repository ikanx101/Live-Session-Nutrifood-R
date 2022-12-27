rm(list=ls())

# kita akan membahas terkait paralelisasi di R
# komputasi paralel adalah proses komputasi yang dikerjakan secara 
  # serentak bersama di beberapa cores komputer
  # hal ini hanya dimungkinkan di komputer atau PC berbasis UNIX
  # seperti Linux atau Mac OS (cmiiw ya)

# saya tidak akan menggunakan library(parallel)
# kali ini saya ingin menggabungkan paralel dengan dplyr
# sehingga library yang akan saya pakai adalah library(multidplyr)

# kita mulai

# ===========================================================
# instalasi library terlebih dahulu
# install.packages("multidplyr")

# kita panggil library-nya
library(dplyr)
library(multidplyr)
library(tictoc)

# ===========================================================
# data yang akan digunakan adalah data yang simpel saja
# contoh data iris
df = iris %>% janitor::clean_names()

# pada part ini, saya akan gunakan data yang jumlah barisnya
  # sangat besar untuk mencari tahu apakah ada perbedaan antara
  # paralel dan biasa
for(i in 1:4){
  df = rbind(df,df)
}

# terlihat ada 78 jutaan baris

# kita lakukan hal yang simpel dulu yakni menghitung rata-rata dari 
  # satu variabel yakni: sepal_length

# jika dilakukan dengan teknik yang biasa
tic()

df %>% 
  group_by(species) %>% 
  summarise(mean(sepal_length)) %>% 
  ungroup()

toc()

# selesai dalam waktu 2.017 detik

# sekarang kita akan coba paralelkan
  # bisa jadi hasilnya gak signifikan karena itu sudah cepat
  # tapi who knows kan?

# langkah 1: kita buat cluster terlebih dahulu
cluster = new_cluster(3) # saya pakai 3 cores saja ya
cluster

# langkah pertama, saya akan buat csv utk masing2 cluster
df %>%
  group_by(species) %>%
  group_walk(~ write.csv(.x, paste0(.y$species, "test.csv"),
                         row.names = F))

files = list.files(pattern = "*.csv",full.names = T)
cluster_assign_partition(cluster,files = files)
cluster_send(cluster, 
             df_pisah <- read.csv(files))

df_pisah = party_df(cluster,"df_pisah")

tic()

df_pisah %>% 
  summarise(mean(sepal_length)) %>%
  collect()

toc()

# surprisingly justru hasilnya lebih lama dibandingkan teknik biasa
  # hal ini biasanya wajar terjadi jika dataset yang digunakan sedikit

# saat datanya banyak, maka akan lebih cepat lagi komputasinya.