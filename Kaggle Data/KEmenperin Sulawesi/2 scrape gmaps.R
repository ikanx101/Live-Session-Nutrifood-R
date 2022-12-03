
library(dplyr)
library(rvest)
library(readxl)
library(RSelenium)  # web scraping


rm(list=ls())

df_plan = read.csv("kantor.csv")
df_plan$url = NA
keyword = df_plan$perusahaan

# version chrome
version = "106.0.5249.61"

# cara check chrome driver https://sites.google.com/chromium.org/driver/

# ====================================
# memulai Selenium
# saat baris perintah ini dijalankan, akan muncul window chrome baru di desktop
driver = RSelenium::rsDriver(browser = "chrome",
                             chromever = version )
remote_driver = driver[["client"]] 

# ================================================================================
# website utama
website_utama = "https://www.google.co.id/maps"

# kita search terlebih dahulu
scrape_url = function(keyword_pencarian){
  remote_driver$navigate(website_utama)
  Sys.sleep(runif(1,4,5))
  search_box = "#searchboxinput"
  cari_produk = remote_driver$findElement(using = 'css', value = search_box)
  Sys.sleep(runif(1,4,5))
  cari_produk$sendKeysToElement(list(keyword_pencarian,key = "enter"))
  Sys.sleep(runif(1,3,4))
  save_url = remote_driver$getCurrentUrl()[[1]]
  return(save_url)
  Sys.sleep(runif(1,2,3))
}

i = 1
for(ix in keyword){
  temp = scrape_url(ix)
  df_plan$url[i] = temp
  print(i)
  i = i + 1
  }

save(df_plan,file = "save data.rda")