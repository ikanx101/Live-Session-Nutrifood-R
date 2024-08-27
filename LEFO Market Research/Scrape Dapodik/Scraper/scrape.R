rm(list=ls())
library(dplyr)
library(rvest)
library(parallel)

n_core = detectCores()

# bikin function buat scrape tabel sekolah
scrape_sekolah = function(url){
  tabel = 
    url %>% # import url
    read_html() %>% # baca url
    html_table(fill = T) # parsing tabel
  
  tabel = tabel[[1]] # ambil tabel dari list pertama
  tabel$sumber = url # kasih keterangan nama kecamatan
  
  prov = 
    url %>% 
    read_html() %>% 
    html_nodes(".breadcrumb li:nth-child(3) a") %>% 
    html_text()
  
  kota_kab = 
    url %>% 
    read_html() %>% 
    html_nodes(".breadcrumb li:nth-child(4) a") %>% 
    html_text()
  
  tabel = 
    tabel %>% 
    mutate(sumber = gsub("Data Peserta Didik ","",sumber),
           sumber = gsub("- Dapodikdasmen.html","",sumber)) %>% 
    rename(kecamatan = sumber) %>% 
    mutate(prov     = prov,
           kota_kab = kota_kab)
  return(tabel)
}

# set path ambil data dulu
setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/Scrape Dapodik/input")

# ambil semua file html
urls = list.files(pattern = "html")

# kita rapihin hanya ambil yang kec
urls = urls[grepl("Kec.",urls)]

# proses web scraping
hasil = mclapply(urls,scrape_sekolah,mc.cores = n_core)
hasil = data.table::rbindlist(hasil) %>% as.data.frame()

# kasih nama files
nama_file = Sys.time() %>% as.character()
nama_file = paste0(nama_file,".csv")

# hapus filesnya
urls = list.files(pattern = "html")
unlink(urls)

# set path untuk save
setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/Scrape Dapodik/output")
write.csv(hasil,nama_file)



# [1] "Prov. Papua Tengah"     "Prov. Papua Barat"     
# [3] "Prov. Papua Barat Daya" 



