rm(list=ls())
setwd("~/Live-Session-Nutrifood-R/Chart Challenge/ErrorBar")
library(dplyr)
library(rvest)
library(ggplot2)

url = paste0("https://top-1000-sekolah.ltmpt.ac.id/?page=",1:7,"&per-page=100")

scrap = function(url){
  hasil = read_html(url) %>% html_table(fill = T)
  hasil = hasil[[1]]
  return(hasil)
}

data = scrap(url[1])

for(i in 2:7){
  temp = scrap(url[i])
  data = rbind(temp,data)
  print(i)
}

plot = 
  data %>% 
  janitor::clean_names() %>% 
  mutate(nilai_total = gsub("\\,",".",nilai_total),
         nilai_total = as.numeric(nilai_total)) %>% 
  filter(!is.na(nilai_total)) %>% 
  ggplot(aes(x = nilai_total)) +
  geom_density(color="darkblue", fill="lightblue",alpha = .2,size = 2) +
  labs(title = "Sebaran Nilai TPS UTBK dari Top 700 SMA di Indonesia",
       caption = "Scraped and Visualized\nUsing R\n27 Oktober 2021 21:01 WIB",
       subtitle = "Sumber data: ltmpt.ac.id",
       x = "Nilai TPS UTBK") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = .5, size = 25),
        plot.subtitle = element_text(hjust = .5, size = 20),
        plot.caption = element_text(hjust = .5,size = 15),
        legend.position = "none",
        axis.text.y = element_blank(),
        axis.title.y = element_blank())

ggsave("Sekolah.png", width = 14, height = 9, dpi = 450)
