library(dplyr)
library(rvest)
library(RSelenium)

rm(list=ls())

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

# halaman depan 
url = "https://www.yogyaonline.co.id/"
situs_all = expand_search(url)

# memulai selenium
driver <- RSelenium::rsDriver(browser = "chrome",
                              chromever = "99.0.4844.35" )
remote_driver <- driver[["client"]] 

# uji coba
i = 2
link_tes = situs_all[i]

# membuka situs 
remote_driver$navigate(link_tes)

url_detail = 
  remote_driver$getPageSource()[[1]] %>% 
  read_html() %>%
  html_nodes("a") %>% 
  html_attr("href") %>% 
  unique()
url_detail = url_detail[!grepl("catalog",url_detail,ignore.case = T)]
url_detail = url_detail[grepl("tropic",url_detail,ignore.case = T)]
n_produk = length(url_detail)



Sys.sleep(4)
remote_driver$navigate(url_detail[2])
rekap_hasil = 
  remote_driver$getPageSource()[[1]] %>% 
  read_html() %>% {
    tibble(
      nama_produk = html_nodes(.,".base") %>% html_text(),
      harga = html_nodes(.,".weee") %>% html_text()
    )
  } %>% distinct()

rekap_hasil
