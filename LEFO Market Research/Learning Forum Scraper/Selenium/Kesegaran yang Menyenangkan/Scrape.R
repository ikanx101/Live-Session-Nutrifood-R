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
# digunakan untuk membuka situs happyfresh
openizer = function(url){
  remote_driver$navigate(url)
  Sys.sleep(3)
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
cari_ts = function(url_depan){
  openizer(url_depan)
  cari_produk = remote_driver$findElement(using = 'css', value = '#searchbar-input')
  cari_produk$sendKeysToElement(list("tropicana slim",key = "enter"))
  Sys.sleep(2)
}

# function IV
cari_ns = function(url_depan){
  openizer(url_depan)
  cari_produk = remote_driver$findElement(using = 'css', value = '#searchbar-input')
  cari_produk$sendKeysToElement(list("nutrisari",key = "enter"))
  Sys.sleep(2)
}

# function V
cari_lmen = function(url_depan){
  openizer(url_depan)
  cari_produk = remote_driver$findElement(using = 'css', value = '#searchbar-input')
  cari_produk$sendKeysToElement(list("l-men",key = "enter"))
  Sys.sleep(2)
}

# function VI
cari_hilo = function(url_depan){
  openizer(url_depan)
  cari_produk = remote_driver$findElement(using = 'css', value = '#searchbar-input')
  cari_produk$sendKeysToElement(list("hilo",key = "enter"))
  Sys.sleep(2)
}

# function VII
cari_lokalate = function(url_depan){
  openizer(url_depan)
  cari_produk = remote_driver$findElement(using = 'css', value = '#searchbar-input')
  cari_produk$sendKeysToElement(list("lokalate",key = "enter"))
  Sys.sleep(2)
}

# function VIII
next_page_2 = function(){
  # next page
  next_page = remote_driver$findElement(using = 'css', value = '#__next > div.jsx-3148673454.body > div > div:nth-child(2) > div.jsx-2435173250.col-md-9 > div > div > div:nth-child(5) > div > div > ul > li:nth-child(2) > a')
  next_page$clickElement()
  Sys.sleep(2)
}

# function IX
next_page_3 = function(){
  # next page
  next_page = remote_driver$findElement(using = 'css', value = '#__next > div.jsx-3148673454.body > div > div:nth-child(2) > div.jsx-2435173250.col-md-9 > div > div > div:nth-child(5) > div > div > ul > li:nth-child(4) > a')
  next_page$clickElement()
  Sys.sleep(2)
}

# function X
breaker = function(){
  break_ = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>%
    html_nodes("a") %>% 
    html_attr("href")
  break_ = break_[grepl("page",break_)] %>% unique()
  if(identical(break_, character(0))){
    break_new = break_
  } else if(!identical(break_, character(0))){
    break_new = paste0("https://www.happyfresh.id",break_)
  }
  return(length(break_new))
}

# ==============================================================================
# set rumah untuk datanya kelak
temp = vector("list")
ikang = 1
# import url happyfresh dari amel
list_url = readLines("list_url.txt")
# uji coba dulu untuk situs pertama
i = 1

# ==============================================================================
# cari TS
cari_ts(list_url[i])
# scrape katalog halaman pertama
temp[[ikang]] = katalogizer()
# set counter
ikang = ikang + 1
# how many page?
page = breaker()
# jika hanya ada dua page
if(page == 1){
  # next page
  next_page_2()
  # scrape katalog halaman berikutnya
  temp[[ikang]] = katalogizer()
  # set counter
  ikang = ikang + 1
}
# jika hanya ada tiga page
if(page == 2){
  # next page
  next_page_2()
  # scrape katalog halaman berikutnya
  temp[[ikang]] = katalogizer()
  # set counter
  ikang = ikang + 1
  # next page
  next_page_3()
  # scrape katalog halaman berikutnya
  temp[[ikang]] = katalogizer()
  # set counter
  ikang = ikang + 1
}


# summary
data_final = 
  do.call(rbind,temp) %>% 
  filter(grepl("hilo|slim|l men|lmen|l-men|nutrisari|lokalate",
               nama_produk,
               ignore.case = T)) %>% 
  filter(!grepl("oreal",
                nama_produk,
                ignore.case = T))

data_final %>% write.csv("Produk NFI.csv")