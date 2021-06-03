setwd("~/Live-Session-Nutrifood-R/Chart Challenge/Circular")

library(dplyr)
library(ggplot2)
library(tidyr)

rm(list=ls())

data = "1. SMAN 1 Bekasi, rerata nilai TPS 567,88
2. SMAN 5 Bekasi, rerata nilai TPS 553,304
3. SMAN 1 Tambun Selatan, rerata nilai TPS 547,96
4. SMAN 4 Bekasi, rerata nilai TPS 544,441
5. SMAN 2 Bekasi, rerata nilai TPS 532,216
6. SMAN 3 Bekasi, rerata nilai TPS 531,557
7. SMAN 6 Bekasi, rerata nilai TPS 528,259
8. SMAN 2 Tambun Selatan, rerata nilai TPS 525,347
9. SMAN 9 Bekasi, rerata nilai TPS 524,318
10. SMAN 11 Bekasi, rerata nilai TPS 521,454
1. SMAS Don Bosco III, rerata nilai TPS 569,568
2. SMA Kristen Penabur Kota Jababeka, rerata nilai TPS 560,911
3. SMAS Penabur, rerata nilai TPS 558,512
4. SMAS Kristen Penabur Summarecon Bekasi, rerata nilai TPS 554,072
5. SMAS Marsudirini, rerata nilai TPS 539,281
6. SMAS Labschool Cibubur, rerata nilai TPS 535,808
7. SMAS IT Al Bina, rerata nilai TPS 535,808
8. SMAS Global Prestasi, TPS 533,627
9. SMAS Islam Al-Azhar 4, TPS 532,884
10. SMAS Future Gate, TPS 532,001"

data = unlist(strsplit(data,split = "\n"))

data = data.frame(raw = data)
data = 
  data %>% 
  separate(raw,
           into = c("raw","nilai"),
           sep = "TPS") %>% 
  mutate(nilai = stringr::str_trim(nilai),
         nilai = gsub("\\,",".",nilai),
         nilai = as.numeric(nilai)) %>% 
  separate(raw,
           into = c("sma","dummy"),
           sep = "\\,") %>% 
  select(-dummy) %>% 
  separate(sma,
           into = c("dummy","sma"),
           sep = "\\.") %>% 
  select(-dummy) %>% 
  mutate(sma = stringr::str_trim(sma))


data %>% 
  arrange(desc(nilai)) %>% 
  mutate(label = 1:20,
         label = ifelse(label <= 6, nilai,NA)) %>% 
  ggplot(aes(x = reorder(sma,nilai),
             y = nilai - 400)) +
  geom_col(color = "black",
           fill = "steelblue",
           alpha = .7,
           width = .5) +
  coord_polar(theta = "y") +
  geom_label(aes(label = label),
             size = 3) +
  theme_minimal() +
  labs(title = "INI BUKAN RINNEGAN!",
       subtitle = "20 SMA Terbaik se-Bekasi Versi Rerata Nilai UTBK",
       caption = "Sumber data: detik.com\nVisualized using R\nikanx101.com") +
  theme(axis.title = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 10,face = "bold"),
        plot.title = element_text(size = 25,face = "bold",hjust = .5),
        plot.subtitle = element_text(size = 15,hjust = .5),
        plot.caption = element_text(size = 10,face = "italic",hjust = .5))

ggsave("info.png",
       width = 12,
       height = 11,
       dpi = 350)
