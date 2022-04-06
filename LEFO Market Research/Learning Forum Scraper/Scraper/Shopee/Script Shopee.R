# set working directory
setwd("~/Documents/Live-Session-Nutrifood-R/LEFO Market Research/Learning Forum Scraper/Scraper")

# wajib!
# instalasi libraries
# cukup sekali seumur hidup
# untuk bisa menjalankan skrip, butuh Google Chrome yang terinstall di laptop masing-masing

# silakan ikuti (ketik) mulai dari baris ini ke bawah!
# panggil libraries
library(RSelenium)  # web scraping
library(rvest)      # web scraping
library(dplyr)      # buat data manipulation
library(jsonlite)   # buat membaca JSON

# hapus environment
rm(list=ls())

# pastikan koneksi internet stabil

# ====================================
# contoh url produk
url_produk = "https://shopee.co.id/Zwitsal-Eau-De-Toilette-100-Ml-Parfum-Eau-De-Toilette-Parfum-Pakaian-Aroma-Bayi-i.14318452.4132994147"


# ====================================
# memulai Selenium
# saat baris perintah ini dijalankan, akan muncul window chrome baru di desktop
driver = RSelenium::rsDriver(browser = "chrome",
                             chromever = "99.0.4844.35" )
remote_driver = driver[["client"]] 


# ====================================
# function untuk mengubah menjadi api shopee
apifier = function(url){
  t1 = strsplit(url,split = "-i.") %>% unlist()
  t2 = strsplit(t1[2],split = "\\.") %>% unlist
  api = paste0("https://shopee.co.id/api/v4/item/get?itemid=",t2[2],"&shopid=",t2[1])
  return(api)
}


# ====================================
# function scraper shopee
scraper_shopee = function(link){
  # tahap I
  # membuka situs yang sudah dijadikan api
  api_new = apifier(link)
  remote_driver$navigate(api_new)
  
  # json parser
  data_produk = 
    remote_driver$getPageSource()[[1]] %>% 
    gsub('<html><head></head><body><pre style=\"word-wrap: break-word; white-space: pre-wrap;\">',"",.) %>% 
    gsub("</pre></body></html>","",.) %>% 
    fromJSON()
  
  # tahap II
  # membuka situs asli utk mendapatkan toko
  remote_driver$navigate(link)
  nama_toko = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html %>% 
    html_nodes("._1wVLAc") %>% 
    html_text()
  
  # tahap III
  # agregasi data
  output = data.frame(
    nama_produk = data_produk$data$name,
    terjual = data_produk$data$sold,
    harga = data_produk$data$price,
    brand = data_produk$data$brand,
    kategori = data_produk$data$categories$display_name %>% paste0(collapse = ", "),
    rating = data_produk$data$item_rating$rating_star,
    id_toko = data_produk$data$shopid,
    nama_toko = nama_toko,
    lokasi_toko = data_produk$data$shop_location,
    official_y_n = data_produk$data$is_official_shop
    )
  return(output)
}
  

# ====================================
# contoh penggunaan function scraper ini
scraper_shopee(url_produk)



