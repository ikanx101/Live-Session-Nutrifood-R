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

# ====================================
# memulai Selenium
# saat baris perintah ini dijalankan, akan muncul window chrome baru di desktop
driver = RSelenium::rsDriver(browser = "chrome",
                             chromever = "99.0.4844.35" )
remote_driver = driver[["client"]] 

# ====================================
# function untuk mengubah menjadi api shopee
apifier = function(url){
  t1 = strsplit(url,split = "-i.",fixed = T) %>% unlist() # perubahan ada di penambahan fixed = TRUE
  t2 = strsplit(t1[2],split = "\\?") %>% unlist()
  t2 = strsplit(t2[1],split = "\\.") %>% unlist()
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
  # jeda tunggu
  Sys.sleep(runif(1,3,6))
  
  # tahap II
  # membuka situs asli utk mendapatkan toko
  remote_driver$navigate(link)
  # jeda tunggu
  Sys.sleep(runif(1,3,6))
  nama_toko = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html %>% 
    html_nodes("._1wVLAc") %>% 
    html_text()
  # jika nama toko kosong
  nama_toko = ifelse(length(nama_toko) == 0,NA,nama_toko)
  
  # jika nama brand tidak ada alias NULL
  brand = data_produk$data$brand
  brand = ifelse(is.null(brand),"NA",brand)
  
  # tahap III
  # agregasi data
  output = data.frame(
    nama_produk = data_produk$data$name,
    terjual = data_produk$data$historical_sold,
    harga = data_produk$data$price/100000,
    harga_min = data_produk$data$price_min/100000,
    harga_max = data_produk$data$price_max/100000,
    brand = brand,
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
# scraper_shopee(url_produk)

link_txt = readLines("Shopee/List Shopee Vegan.txt")
link_txt = link_txt[1] # ini saya hapus yang tidak perlu ya

temporary = vector("list",length(link_txt))
for(i in 1:length(link_txt)){
  temporary[[i]] = scraper_shopee(link_txt[i])
  print(paste0("Produk ke-",i," DONE"))
}

