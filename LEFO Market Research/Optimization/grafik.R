setwd("~/Documents/Live-Session-Nutrifood-R/LEFO Market Research/Optimization")

library(dplyr)
library(ggforce)
library(reshape2)

rm(list=ls())

jadwal = readxl::read_excel("ppic.xlsx", sheet = "jadwal all")

jadwal %>% 
  ggplot(aes(x = minggu, label = label, fill = minggu)) +
  
  annotate("segment", x = 0, xend = 1, y = 0, yend = 0, size = 1, color = "lightblue") +
  annotate("segment", x = 1, xend = 2, y = 0, yend = 0, size = 1, color = "blue") +
  annotate("segment", x = 2, xend = 3, y = 0, yend = 0, size = 1, color = "darkblue") +
  annotate("segment", x = 3, xend = 4, y = 0, yend = 0, size = 1, color = "steelblue") +
  annotate("segment", x = 4, xend = 5, y = 0, yend = 0, size = 1, color = "green") +
  annotate("segment", x = 5, xend = 6, y = 0, yend = 0, size = 1, color = "black") +
  annotate("segment", x = 6, xend = 7, y = 0, yend = 0, size = 1, color = "darkred") +
  
  geom_point(aes(y = -.1), size = 2, shape = 21, stroke = 1.5, fill = "white") +
  
  geom_label(aes(y = 0, label = label_minggu),
             fill = "black",
             color = "white") +
  
  geom_mark_circle(aes(y = 0, label = NA, description = label, fill = event), 
                   con.cap = -1, fill = NA, color = NA, label.fontsize = 10, label.hjust = 0,
                   label.fill = NA,
                   con.size = 0.5, con.border = "one",
                   con.type = "elbow") +

  labs(title = "Timeline Pengadaan Bahan Baku Gula",
       subtitle = "Garis horizontal menandakan minggu",
       caption = "Produksi sebenarnya dimulai pada saat minggu III. Namun, sejak gula mulai dikirim pada minggu I, kita harus mulai memperhitungkan kapasitas gudang.\nDemikian juga saat pengiriman gula di minggu II. Oleh karena itu pemakaian pada minggu I dan II akan dijadikan parameter dalam model matematika.\n Tim Optimis Nutrifood\ndibuat dengan R")+
  
  theme_void() +
  
  theme(legend.position = "none",
        plot.background = element_rect(fill = "#e1f7e7", color = NA),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 25, family = "Patua"),
        plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 22),
        plot.caption = element_text(hjust = 0.5, face = "bold", size = 10, color = "grey50", family = "Lato")) +
  xlim(0,7)+ ylim(-35,35)

ggsave("gula_new.png", width = 15, height = 8)
