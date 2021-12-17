# UJI COBA SCRAPING PAKE VIRTUAL MACHINE
# by: ikanx101.com

# ============================================
# panggil libraries
library(rvest) # web scraping
library(dplyr) # buat data manipulation

# hapus environment
rm(list=ls())

# ====================================
# Contoh
url = "https://shopee.co.id/Zwitsal-Eau-De-Toilette-100-Ml-Parfum-Eau-De-Toilette-Parfum-Pakaian-Aroma-Bayi-i.14318452.4132994147"

url %>%
  read_html() %>%
  html_nodes(".attM6y span") %>%
  html_text()

# langkah ketiga
scrape_shopee = function(link){
  # navigate
  b$Page$navigate(link)
  Sys.sleep(15)
  
 
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



