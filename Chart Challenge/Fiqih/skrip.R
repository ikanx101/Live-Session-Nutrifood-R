# hapus environment
rm(list=ls())
setwd("~/Live-Session-Nutrifood-R/Chart Challenge/Fiqih")

# libraries
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

# ambil file
file = "1678089633756_Produktivitas%202018-2022.xlsx"
df   = read_excel(file,skip = 3) %>% janitor::clean_names()

# bebersih colnames
colnames(df) = c("provinsi",
                 paste0("pdb_",2018:2022),
                 paste0("pdd_",2018:2022),
                 paste0("pdv_",2018:2022)
                 )

# data carpentry
df = 
  df %>% 
  filter(!is.na(pdb_2018)) %>% 
  filter(!grepl("indonesia",provinsi,ignore.case = T))

df %>% 
  select(!contains(c("pdb","pdd"))) %>% 
  reshape2::melt(id.vars = "provinsi") %>% 
  filter(grepl("jakarta|jawa|banten|yogya",provinsi,ignore.case = T)) %>% 
  mutate(variable = gsub("pdv_","",variable),
         variable = as.numeric(variable)) %>% 
  mutate(label = round(value,1),
         label = ifelse(variable == 2022,
                        paste(label,provinsi,sep = "\n"),
                        label)
         ) %>% 
  ggplot(aes(x     = variable,
             y     = value,
             color = provinsi)) +
  geom_line(aes(group = provinsi),size = 1.15,alpha = .7) +
  geom_point(color = "black",alpha = .6,size = 5) + 
  scale_color_manual(values = c("grey","grey","red","darkgreen","steelblue","blue")) +
  ggrepel::geom_text_repel(aes(label = label)) +
  ggthemes::theme_stata() +
  theme(legend.position = "none") +
  xlim(2018,2022.2) +
  labs(x = "Tahun",
       y = "Produktivitas (Juta Rp / tk)") +
  theme(axis.title = element_text(size = 15),
        axis.text.x = element_text(size = 14),
        axis.text.y = element_blank(),
        plot.caption = element_text(size = 17,face = "bold"),
        plot.title = element_text(size = 27,face = "bold"),
        plot.subtitle = element_text(size = 17)) +
  labs(title    = "Produktivitas per Provinsi",
       caption  = "Sumber data: satudata.kemnaker.go.id",
       subtitle = "Tingkat Produktivitas Tenaga Kerja adalah rasio antara produk berupa barang dan jasa\ndengan tenaga kerja yang digunakan, baik individu maupun kelompok dalam satuan waktu tertentu\nyang merupakan besaran kontribusi tenaga kerja dalam pembentukan nilai tambah suatu produk dalam proses kegiatan ekonomi")
  
ggsave("plot.png",width = 16,height = 9,dpi = 900)
