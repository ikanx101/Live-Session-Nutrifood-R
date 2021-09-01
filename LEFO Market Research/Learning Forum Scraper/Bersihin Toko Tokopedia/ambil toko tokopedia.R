# clear
rm(list=ls())
library(dplyr)

# sebagai contoh saya akan ambil data link produk ya mbak pebs
# link produk tokopedia saya masukin ke file .txt
# nama filenya "link tokopedia.txt"
  # saya lampirkan juga ya filenya

# kita baca dulu filenya
link = readLines("link tokopedia.txt")

# ini adalah fungsi untuk mengambil nama toko
cariin_nama_toko = function(tes){
  new = strsplit(tes,
                 split = "\\/")
  new = unlist(new)[4]
  nama_toko = paste0("https://www.tokopedia.com/",new)
  return(nama_toko)
}

# proses pengambilan nama toko
temp = c()
for(i in 1:length(link)){
  temp[i] = cariin_nama_toko(link[i])
}
final_url = unique(sort(temp))

# ini kita export hasilnya ke dalam file txt
# nama filenya
  # Link Toko di Tokopedia.txt
writeLines(final_url,"Link Toko di Tokopedia.txt")