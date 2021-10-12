# set working directory
setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/Learning Forum Scraper/Scraper")

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
url = "https://www.blibli.com/p/nutrisari-american-sweet-orange-14-gr-x-10-sachet-1-renceng/ps--SAK-60050-00438?ds=SAK-60050-00438-00001&source=SEARCH&sid=3d6f1bef739ad7b0&cnc=false&pickupPointCode=PP-3209980&pid=SAK-60050-00438&tag=trending"

# bikin skrip utk scraping

  # langkah pertama
    # set user agent
      uastring = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36"

  # langkah kedua
    # setting untuk mengaktifkan chromote
      b = ChromoteSession$new()
      b$Network$setUserAgentOverride(userAgent = uastring)
      b$view()
      cookies = b$Network$getCookies()
      b$Network$setCookies(cookies = cookies$cookies)

  # langkah ketiga
      scrape_blibli = function(link){
        # navigate
        b$Page$navigate(link)
        Sys.sleep(10)
        
        # digunakan untuk extract nama produk
        x <- b$Runtime$evaluate('document.querySelector(".product-name").innerText')
        nama = x$result$value
        nama = ifelse(is.null(nama),NA,nama)
        
        # digunakan untuk extract informasi terjual
        x <- b$Runtime$evaluate('document.querySelector(".product-statistics__sold-seen").innerText')
        terjual = x$result$value
        terjual = ifelse(is.null(terjual),NA,terjual)
        
        # digunakan untuk extract harga
        x <- b$Runtime$evaluate('document.querySelector(".product-price__after").innerText')
        harga = x$result$value
        harga = ifelse(is.null(harga),NA,harga)
        
        # digunakan untuk extract rating
        x <- b$Runtime$evaluate('document.querySelector(".product-statistics__rating").innerText')
        rating = x$result$value
        rating = ifelse(is.null(rating),NA,rating)
        
        # digunakan untuk extract nama toko
        x <- b$Runtime$evaluate('document.querySelector(".seller__name .text").innerText')
        toko = x$result$value
        toko = ifelse(is.null(toko),NA,toko)
        
        # digunakan untuk extract alamat toko
        x <- b$Runtime$evaluate('document.querySelector(".seller-info__location").innerText')
        alamat = x$result$value
        alamat = ifelse(is.null(alamat),NA,alamat)
        
        # time stamp aja, kapan kita melakukan ini
        waktu_scrape = Sys.time()
        
        # digunakan untuk membuat tabel
        data = data.frame(link,nama,terjual,harga,rating,alamat,toko,waktu_scrape)
        return(data)
      }
      
      
  # langkah keempat
      # saatnya kita scrape
      data_hasil_scrape = scrape_blibli(url)
      
      
