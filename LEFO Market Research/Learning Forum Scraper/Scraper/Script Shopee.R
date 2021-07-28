# set working directory
# setwd("~/Documents/Live-Session-Nutrifood-R/LEFO Market Research/Learning Forum Scraper")

# kode ini saya gunakan untuk live sharing
# tidak dibutuhkan untuk web scraper
# library(remotes)
# s <- livecode::serve_file()

# wajib!
# instalasi libraries
# cukup sekali seumur hidup
# dplyr
# install.packages("dplyr")
# chromote
# untuk bisa menjalankan skrip, butuh Google Chrome yang terinstall di laptop masing-masing
# install.packages("remotes")
# remotes::install_github("rstudio/chromote")

# silakan ikuti (ketik) mulai dari baris ini ke bawah!
# panggil libraries
library(chromote) # web scraping
library(dplyr) # buat data manipulation

# hapus environment
rm(list=ls())

# cara scrape-nya simpel
# bumbu
# 1. link / url produknya
# shopee
# tokopedia
# 2. skrip R
# fungsi scraper --> fungsi untuk mengambil data yang terlihat di web
# elemen CSS dari webnya
# CSS adalah pembangun dari web
# alat
# 1. R
# 2. koneksi internet yang stabil

# ====================================
# Contoh
url = "https://shopee.co.id/Zwitsal-Eau-De-Toilette-100-Ml-Parfum-Eau-De-Toilette-Parfum-Pakaian-Aroma-Bayi-i.14318452.4132994147"

# bikin skrip utk scraping

# langkah pertama
# set user agent
uastring = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Safari/537.36"

# langkah kedua
# setting untuk mengaktifkan chromote
b = ChromoteSession$new()
b$Network$setUserAgentOverride(userAgent = uastring)
b$view()
cookies = b$Network$getCookies()
b$Network$setCookies(cookies = cookies$cookies)

# langkah ketiga
scrape_shopee = function(link){
  # navigate
  b$Page$navigate(link)
  Sys.sleep(5)
  
  # digunakan untuk extract nama produk
  x <- b$Runtime$evaluate('document.querySelector(".attM6y span").innerText')
  nama = x$result$value
  nama = ifelse(is.null(nama),NA,nama)
  
  # digunakan untuk extract informasi terjual
  x <- b$Runtime$evaluate('document.querySelector(".aca9MM").innerText')
  terjual = x$result$value
  terjual = ifelse(is.null(terjual),NA,terjual)
  
  # digunakan untuk extract harga
  x <- b$Runtime$evaluate('document.querySelector("._1HEBVl").innerText')
  harga = x$result$value
  harga = ifelse(is.null(harga),NA,harga)
  
  # digunakan untuk extract rating
  x <- b$Runtime$evaluate('document.querySelector("._1mYa1t").innerText')
  rating = x$result$value
  rating = ifelse(is.null(rating),NA,rating)
  
  # digunakan untuk extract nama toko
  x <- b$Runtime$evaluate('document.querySelector("._3uf2ae").innerText')
  toko = x$result$value
  toko = ifelse(is.null(toko),NA,toko)
  
  # time stamp aja, kapan kita melakukan ini
  waktu_scrape = Sys.time()
  
  # digunakan untuk membuat tabel
  data = data.frame(link,nama,terjual,rating,harga,toko,waktu_scrape)
  return(data)
}


# langkah keempat
# saatnya kita scrape
data_hasil_scrape = scrape_shopee(url)



