rm(list=ls())

setwd("~/Live-Session-Nutrifood-R/Chart Challenge/Alluvial")

library(readxl)
library(dplyr)
library(tidyr)
library(reshape2)
library(ggplot2)
library(ggalluvial)

data = read_excel("data rekap.xlsx")

data = 
  data %>% 
  melt(id.vars = c("Bandara","Tahun")) %>% 
  janitor::clean_names() %>% 
  rename(bulan = variable,
         penumpang = value) %>% 
  mutate(penumpang = gsub(" ","",penumpang),
         penumpang = as.numeric(penumpang)) %>% 
  mutate(bulan = factor(bulan,
                        levels = c("Januari",
                                   "Februari",
                                   "Maret",
                                   "April",
                                   "Mei",
                                   "Juni",
                                   "Juli",
                                   "Agustus",
                                   "September",
                                   "Oktober",
                                   "November",
                                   "Desember")
                        )
         ) %>% 
  group_by(tahun,bulan) %>% 
  summarise(total = sum(penumpang))

data$pandemi = "Pra Pandemi"
data$pandemi[40:60] = "Pandemi"

data %>% 
  mutate(label = ifelse(!is.na(total),paste0(round(total/1000000,2),"jt"),""),
         label = ifelse(tahun == 2017,NA,label),
         total = ifelse(!is.na(total),total,1)) %>% 
  filter(tahun > 2017) %>%
  ggplot(aes(x = bulan,
             y = tahun)) +
  geom_point(aes(
    size = total,
    color = pandemi),
             alpha = .7) + 
  scale_fill_manual(values = c("darkred","steelblue")) +
  geom_text(aes(label = label),
            size = 4
            ) + 
  scale_size_area(max_size = 20) +
  coord_fixed() +
  coord_polar(theta = "x") +
  theme_minimal() +
  guides(size = F) +
  ylim(2017,2021) +
  labs(title = "Total Penumpang Pesawat Penerbangan Domestik\ndi 5 Bandara Utama Indonesia 2018 - 2021",
       subtitle = "Polonia, Soekarno-Hatta, Juanda, Ngurah Rai, dan Hasanudin",
       caption = "Pandemi menurunkan banyaknya penumpang pesawat tujuan domestik di 5 bandara besar di Indonesia.\nSumber: BPS - Visualized using R\nikanx101.com",
       color = "Kondisi") +
  theme(legend.position = "left",
        plot.background = element_rect(fill = "#edf4ff", color = NA),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 25),
        plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 18),
        plot.caption = element_text(hjust = 0.5, face = "bold", size = 12),
        axis.title = element_blank(),
        axis.text.x = element_text(size = 12,face = "bold"),
        axis.text.y = element_blank()) +
  annotate("label",
           x = "Januari",
           y = 2017,
           label = "2018",
           size = 5,
           fill = "#0255d6",
           color = "white") +
  annotate("label",
           x = "Desember",
           y = 2021,
           label = "2021 dimulai dari -->",
           size = 5,
           fill = "#0255d6",
           color = "white")
  
ggsave("info.png",
       width = 12,
       height = 12,
       dpi = 650)
