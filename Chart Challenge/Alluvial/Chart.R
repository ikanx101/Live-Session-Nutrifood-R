rm(list=ls())

setwd("~/Live-Session-Nutrifood-R/Chart Challenge/Alluvial")

library(dplyr)
library(tidyr)
library(ggplot2)
library(ggalluvial)

data_lbt %>% 
  mutate(meaning = gsub("LBT-","",meaning)) %>% 
  group_by(bulan,meaning) %>% 
  tally() %>% 
  ungroup() %>% 
  ggplot(aes(x = bulan,
             y = n,
             alluvium = meaning)) +
  geom_alluvium(aes(fill = meaning),
                color = "black") +
  labs(title = "Alasan Barang Tidak Terkirim",
       subtitle = "Banyaknya transaksi barang yang tidak bisa dikirim oleh Nutrifood",
       caption = "Sumber: data LBT tim sales Jan-Apr 2021",
       x = "Bulan",
       y = "Banyak Transaksi",
       fill = "Keterangan") +
  theme_minimal() +
  theme(plot.title = element_text(size = 15,
                                  hjust = .5,
                                  face = "bold"),
        plot.subtitle = element_text(size = 12,
                                     hjust = .5),
        plot.caption = element_text(size = 10,
                                    hjust = .5),
        legend.position = "bottom") +
  scale_y_continuous(breaks=seq(0,3000,500),limits = c(0,3000))

