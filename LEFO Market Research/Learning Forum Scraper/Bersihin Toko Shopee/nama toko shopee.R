# clean environment
rm(list=ls())

# libraries
library(dplyr)
library(jsonlite)
library(openxlsx)

# ambil semua link produk
url = readLines("link produk shopee.txt")

# ini function utk ambil data
info_toko_shopee = function(link){
  link = strsplit(link,
                  split = "-i.")
  link = unlist(link)[length(unlist(link))]
  link = strsplit(link,split = "\\.")
  link = unlist(link)[[1]]
  api = paste0("https://shopee.co.id/api/v4/product/get_shop_info?shopid=",link)
  
  data_toko = read_json(api)
  
  nama_seller = data_toko$data$name
  rating = data_toko$data$rating_star
  user_name = data_toko$data$account$username
  link = paste0("https://shopee.co.id/",user_name)
  hasil = data.frame(nama_seller,rating,link_toko = link)
  return(hasil)
}

# kita mulai mengambil informasi toko
hasil = data.frame()
for(i in 1:length(url)){
  temp = info_toko_shopee(url[i])
  hasil = rbind(temp,hasil)
  print(paste0(i," done"))
}
hasil = hasil %>% distinct()

# ini sabar yah
# gak secepat tokopedia yang ini kerjanya karena butuh koneksi itnernet

write.xlsx(hasil,
           file = "detail toko shopee.xlsx")
