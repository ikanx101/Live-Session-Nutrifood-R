# ==============================================================================
# HAPPY FRESH SCRAPER
# use it wisely
# ==============================================================================

# ==============================================================================
# persiapan-persiapan
# set working directory
setwd("~/Documents/Live-Session-Nutrifood-R/LEFO Market Research/Learning Forum Scraper/Selenium/Kesegaran yang Menyenangkan")

# dimulai dari hati yang bersih
rm(list=ls())

# load all libraries needed
library(dplyr)
library(rvest)
library(RSelenium)

# open selenium web driver
driver = RSelenium::rsDriver(browser = "chrome",
                             chromever = "99.0.4844.35" )
remote_driver = driver[["client"]] 

# ==============================================================================
# kita buat function yang berguna terlebih dahulu
# function I
# digunakan untuk mencari break page
breaker = function(){
  break_ = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>%
    html_nodes("a") %>% 
    html_attr("href")
  break_ = break_[grepl("page",break_)] %>% unique()
  break_ = ifelse(identical(break_, character(0)),
                  break_,
                  paste0("https://www.happyfresh.id",break_))
  return(break_)
}
# function II
# digunakan untuk ekstrak informasi katalog
katalogizer = function(){
  output = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>% {tibble(
      nama_produk = html_nodes(.,"h2.jsx-717190455") %>% html_text(),
      harga_final = html_nodes(.,".PLP-Search-discount-price") %>% html_text(),
      unit = html_nodes(.,".unit") %>% html_text()
    )
    } 
  return(output)
}
# function III
# digunakan untuk membuka situs happyfresh
openizer = function(url){
  remote_driver$navigate(url)
  Sys.sleep(3)
}
# function IV
# digunakan untuk mencari produk nutrifood
cari_brand = function(url){
  final_url = paste0(url,
                     c("/search?q=tropicana%20slim",
                       "/search?q=nutrisari",
                       "/search?q=l-men",
                       "/search?q=hilo",
                       "/search?q=lokalate")
                     )
  return(final_url)
}

# ==============================================================================
# set rumah untuk datanya kelak
temp = vector("list")
ikang = 1
# import url happyfresh dari amel
list_url = readLines("list_url.txt")
# uji coba dulu dengan url grand lucky scbd
tes_url = list_url[5]
tes_url

# ==============================================================================
# kita cari dulu semua produk nutrifood di sana
url_cari = cari_brand(tes_url)

for(i in 1:length(url_cari)){
  # selenium mulai dari sini
  openizer(url_cari[i])
  print("Page utama done")
  # ambil katalog pertama
  temp[[ikang]] = katalogizer()
  # set counter
  ikang = ikang + 1
  # mencari break
  next_page = breaker()
  
  if(length(next_page > 0)){
    for(j in 1:length(next_page)){
      openizer(next_page[j])
      print("Page child done")
      temp[[ikang]] = katalogizer()
      ikang = ikang + 1
    }
  }
}

# summary
data_final = 
  do.call(rbind,temp) %>% 
  filter(grepl("hilo|slim|l men|lmen|l-men|nutrisari",
               nama_produk,
               ignore.case = T)) %>% 
  filter(!grepl("oreal",
                nama_produk,
                ignore.case = T))

data_final %>% write.csv("Produk NFI Grand Lucky SCBD.csv")
