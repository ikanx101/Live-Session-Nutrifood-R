# bebersih global environment
rm(list=ls())

# set working directory
setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/GrabFood")

# panggil libraries
library(dplyr)
library(rvest)
library(httr)

# kita akan scrape informasi dari satu link di grab food
url = "https://food.grab.com/id/id/restaurant/mcdonald-s-summarecon-bekasi-delivery/IDGFSTI00002wer"

# ==================================================================
# cara kerja induksi
  # bikin satu-satu trus kalau berhasil tinggal digabung

# kita mau ambil nama resto
# nama_resto = read_html(url) %>% html_nodes(".name___1Ls94") %>% html_text()

# kita mau ambil kategori resto
# kategori_resto = read_html(url) %>% html_nodes(".cuisine___3sorn") %>% html_text()

# kita mau ambil rating resto
# rating_resto = read_html(url) %>% html_nodes(".ratingText___1Q08c") %>% html_text()

# kita mau ambil menu resto
# menu_resto = read_html(url) %>% html_nodes("h3") %>% html_text()

# semua functions di atas punya masalah efisiensi
  # ada kecenderungan ketauan bot grab food
  # kita bisa modify function-nya agar hanya sekali saja read_html


# ==================================================================
# function final utk scrape data dari grab food
scrape_grab = function(url){
  rekap_hasil = read_html(url) %>% {
    tibble(
      nama_resto = html_nodes(.,".name___1Ls94") %>% html_text(),
      kategori_resto = html_nodes(.,".cuisine___3sorn") %>% html_text(),
      rating_resto = html_nodes(.,".ratingText___1Q08c") %>% html_text(),
      menu_resto = html_nodes(.,"h3") %>% html_text()
    )
  }
  return(rekap_hasil)
}

# contoh restoran yang lain
url_2 = "https://food.grab.com/id/id/restaurant/ichiban-sushi-summarecon-mall-bekasi-delivery/6-CY2EJ633E6M1TT"

# scrape data restoran
hasil = scrape_grab(url_2)

# cara kerja
  # input: url
  # proses: scrape
  # output: dataframe

# untuk melakukan scraping ke banyak restoran, kita butuh semua link/url dari restoran itu sebagai input
  # kita akan buat si R untuk baca semua links yang ada di file .txt yang tadi
  # lalu kita looping untuk scrape semuanya

# kita akan ambil semua link dari file .txt nya
links = readLines("link restoran.txt")


# ini saya ambil copy paste dari blog saya di:
  # https://ikanx101.com/blog/error-post/

# alih-alih data frame, saya akan simpan sebagai list
hasil = vector("list", length(links))

# untuk looping
  # cara kerja:
# menentukan batas percobaan
batas = 3

for (i in 1:length(links)) {
  if (!(links[i] %in% names(hasil))) {
    cat(paste("Scraping", links[i], "..."))
    ok = FALSE
    counter = 0
    while (ok == FALSE & counter <= batas) {
      counter = counter + 1
      out = tryCatch({                  
        scrape_grab(links[i])
      },
      error = function(e) {
        Sys.sleep(2)
        e
      }
      )
      if ("error" %in% class(out)) {
        cat(".")
      } else {
        ok = TRUE
        cat(" Done.")
      }
    }
    cat("\n")
    hasil[[i]] = out
    names(hasil)[i] = links[i]
  }
} 

# Gabung semua hasil scrape menjadi satu data frame saja
hasil_scrape = data.frame()
for(i in 1:length(hasil)){
  if(is.data.frame(hasil[[i]])){
    hasil_scrape = rbind(hasil[[i]],hasil_scrape)
  }
}

# ini utk remove duplikasi yang muncul di kemudian hari
hasil_scrape = 
  hasil_scrape %>% 
  filter(kategori_resto != menu_resto) %>% 
  distinct()
  
# save hasil scrape dalam bentuk .rda
save(hasil_scrape,
     file = "hasil scrape.rda")
  
# =================================================================
# e n d