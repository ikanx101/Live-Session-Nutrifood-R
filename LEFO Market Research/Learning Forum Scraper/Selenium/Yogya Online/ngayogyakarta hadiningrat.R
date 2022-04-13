rm(list=ls())
setwd("~/Documents/Live-Session-Nutrifood-R/LEFO Market Research/Learning Forum Scraper/Selenium/Yogya Online")

# load libraries 
library(dplyr)
library(tidyr)
library(rvest)
library(RSelenium)

# ===============================================================================
# memulai selenium
driver = RSelenium::rsDriver(browser = "chrome",
                             chromever = "99.0.4844.35" )
remote_driver = driver[["client"]] 

# ===============================================================================
# definisi functions dulu
# expand
expand_search = function(url){
  paste0(url,
         c("/catalogsearch/result/?q=nutrisari",
           "/catalogsearch/result/?q=tropicana+slim",
           "/catalogsearch/result/?q=l+men",
           "/catalogsearch/result/?q=hilo",
           "/catalogsearch/result/?q=lokalate")
         )
}
# istirahat
sabar = function(detik){
  detik = 1 + detik
  Sys.sleep(runif(1,1,detik))
}
# ambil semua produk dalam katalog
ambil_katalog = function(){
  url_detail = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>%
    html_nodes("a") %>% 
    html_attr("href") %>% 
    unique()
  url_detail = url_detail[!grepl("catalog",url_detail,ignore.case = T)]
  url_detail = url_detail[grepl("tropic|nutri|hilo|lokalate|l-men",url_detail,ignore.case = T)]
  n_produk = length(url_detail)
  output = list(url = url_detail,
                n_produk = n_produk)
  return(output)
}
# ambil semua informasi dalam page produk
ambil_produk = function(url_pr){
  remote_driver$navigate(url_pr)
  sabar(0.5)
  RSelenium::selKeys %>% names()
  rekap_hasil = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>% {
      tibble(
        nama_produk = html_nodes(.,".base") %>% html_text(),
        harga = html_nodes(.,".weee") %>% html_text()
      )
    } %>% distinct()
  return(rekap_hasil)
}


# ===============================================================================
# halaman depan 
url = "https://www.yogyaonline.co.id/"
# mencari semua produk nutrifood
situs_all = expand_search(url)
n_nfi = length(situs_all)


# ===============================================================================
# persiapkan rumah utk datanya
data_yogya = vector("list",1)
ikanx = 1
# kita mulai looping yang pertama
for(nfi in 3:n_nfi){
  # mencari semua produk yang ada di katalog
    # membuka situs 
    remote_driver$navigate(situs_all[nfi])
    # biarkan loading dulu
    sabar(5)
    # ambil semua produk
    katalog_list = ambil_katalog()
    # print keterangan
    print(paste0("Katalog ",nfi," sudah diambil dari total ",n_nfi," katalog."))
  # sekarang kita ambil semua produk dalam katalog tersebut
  for(p in 1:katalog_list$n_produk){
    data_yogya[[ikanx]] = ambil_produk(katalog_list$url[p])
    ikanx = ikanx + 1
    print(paste0("Produk ke-",p," dari katalog ke-",nfi," DONE"))
  }  
    }

# bebersih data hasil scrape
df_yogya = 
  do.call(rbind,data_yogya) %>% 
  mutate(nama_produk = stringr::str_squish(nama_produk),
         harga = stringr::str_squish(harga)) %>% 
  separate(harga,
           into = c("jenis_harga","harga"),
           sep = "Rp") %>% 
  mutate(harga = gsub(" ","",harga),
         harga = gsub("\\.","",harga),
         harga = as.numeric(harga),
         jenis_harga = stringr::str_squish(jenis_harga),
         jenis_harga = ifelse(jenis_harga == "",
                              "Regular Price",
                              jenis_harga))
  
# save dulu
save(df_yogya,file = "sample_data.rda")
write.csv(df_yogya,"yogya_online.csv",row.names = F)
