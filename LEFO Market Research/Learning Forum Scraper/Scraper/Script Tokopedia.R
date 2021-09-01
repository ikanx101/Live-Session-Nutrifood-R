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
url = "https://www.tokopedia.com/pikowa/klem-klip-kabel-rapi-dinding-5set-tempel-manejemen-wire-bonus-ties-klem-5set-besar?whid=0"

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
      scrape_tokopedia = function(link){
        # navigate
        b$Page$navigate(link)
        Sys.sleep(10)
        
        # digunakan untuk extract nama produk
        x <- b$Runtime$evaluate('document.querySelector(".css-1wtrxts").innerText')
        nama = x$result$value
        nama = ifelse(is.null(nama),NA,nama)
        
        # digunakan untuk extract informasi terjual
        x <- b$Runtime$evaluate('document.querySelector(".items div:nth-child(1)").innerText')
        terjual = x$result$value
        terjual = ifelse(is.null(terjual),NA,terjual)
        
        # digunakan untuk extract harga
        x <- b$Runtime$evaluate('document.querySelector(".price").innerText')
        harga = x$result$value
        harga = ifelse(is.null(harga),NA,harga)
        
        # digunakan untuk extract rating
        x <- b$Runtime$evaluate('document.querySelector("span .main").innerText')
        rating = x$result$value
        rating = ifelse(is.null(rating),NA,rating)
        
        # digunakan untuk extract nama toko
        x <- b$Runtime$evaluate('document.querySelector("#pdp_comp-shop_credibility h2").innerText')
        toko = x$result$value
        toko = ifelse(is.null(toko),NA,toko)
        
        # digunakan untuk extract alamat toko
        x <- b$Runtime$evaluate('document.querySelector("#pdp_comp-shipment b").innerText')
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
      data_hasil_scrape = scrape_tokopedia(url)
      
      
# ==================================================================
# kita akan melakukan scraping utk semua urls nutrimart festive 7-7

# langkah pertama
  # import list url yang sudah dalam sudah disave dalam bentuk txt
  link_nutrimart = readLines("link produk diabetasol.txt")

# langkah kedua
  # hapus kata-kata: etalase, product, page, dan review dari kumpulan list url yang sudah kita import
  link_nutrimart_clean = link_nutrimart[!grepl("page|etalase|product|review",link_nutrimart,ignore.case = T)] 

# langkah ketiga
  # bikin aja iterasi dari 1 sampai 45: seberapa banyak link_nutrimart_clean
  
      # hitung berapa banyak link yang ada di link_nutrimart_clean
        n = length(link_nutrimart_clean)
      
      # bikin data frame kosong
        data_hasil_scrape_baru = data.frame()

      # iterasi
        for(i in 1:n){
          temp = scrape_tokopedia(link_nutrimart_clean[i])
          data_hasil_scrape_baru = rbind(data_hasil_scrape_baru,temp)
          print(paste0("Link ke-",i," sudah selesai..."))
        }


# ==========================================================
# sekarang bagiannya data carpentry
# tujuan kita ada dua, yakni:
  # benerin angka terjual
  # benerin angka harga
        
# terjual
  # masalah: "terjual", "berhasil terjual"
  # yang dibutuhkan angkanya saja
  # terjual 3.300 --> kita hapus titik
        
# harga
  # masalah: "Rp"
  # penggunaan titik

# misal saya akan membuat function sendiri
  # butuh library stringr
    # cara install stringr:
    # install.packages("stringr")

# custom function
ekstrak_angka = function(var){
  var = gsub("[A-z]|\\.","",var,ignore.case = T)
  var = stringr::str_squish(var)
  var = terjual = as.numeric(var)
  return(var)
}
        
# tinggal bebersih
clean = 
  data_hasil_scrape_baru %>% 
  mutate(harga = ekstrak_angka(harga),
         terjual = ekstrak_angka(terjual))

# ===========================================================
# kita sudah selesai scrape datanya
# sekarang bagian kita save hasilnya

# save ke csv
write.csv(clean,"Scrape data Nutrimart 8 Juli.csv")

# save ke excel
  # utk satu sheet
openxlsx::write.xlsx(clean, file = "Scrape Data Nutrimart.xlsx")

# save ke data format R
save(data_hasil_scrape_baru,clean,
     file = "Scrape Nutrimart.rda")