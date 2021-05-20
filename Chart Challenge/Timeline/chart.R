# set working directory
setwd("~/Live-Session-Nutrifood-R/Chart Challenge/Timeline")

#sucikan diri
rm(list=ls())

# libraries
library(dplyr)
library(ggforce)
library(reshape2)

# data
data = data.frame(
  tahun = seq(1,2,by = 1/14),
  label_tahun = c(1998,1999,2000,NA,2001,2004,2005,2006,2007,2008,2009,2010,2011,2012,2016),
  event = c("Both","Both","Both","Both","Both","Ikang","Santi","Both","Both","Ikang","Santi","Both","Both","Both","Both"),
  label = c("Kisah dimulai saat kami berdua masuk ke SMP 1 Bekasi.",
            "Pertama kali saya bertemu Santi adalah pada kelas II. Saya duduk paling kiri, baris ke tiga dari belakang. Sementara Santi duduk paling kanan, baris ke dua dari depan.",
            "Pada kelas 3, saya memberanikan diri untuk mengutarakan cinta monyet kepadanya.\nPacaran pertama.",
            "Namanya juga cinta monyet, hubungan ini hanya bertahan beberapa bulan saja.\nPutus.\nKami melanjutkan kehidupan masing-masing.",
            "Saya dan Santi masuk SMA 1 Bekasi.\nDi kelas 3, kami pernah sekelas.",
            "Hasil SPMB: Saya diterima di ITB.\nMulai kuliah di Bandung.",
            "Hasil SPMB: Santi diterima di UNPAD.\nMulai kuliah di Jatinangor.",
            "Saya mulai menyadari Santi ada di Bandung Raya. Kami mulai bertemu kembali di Bandung-Jatinangor. Beberapa kali kami berjanjian untuk pulang bareng naik bus Leuwi Panjang - Bekasi.",
            "Cinta lama bersemi kembali. Pacaran fase kedua.",
            "Saya lulus kuliah. Diterima kerja di Jakarta dan kembali ke Bekasi.\nLDR dimulai.",
            "Santi lulus kuliah. Diterima kerja diJakarta dan kembali ke Bekasi.",
            "Lamaran, persiapan pernikahan.\nSanti resign dari pekerjaannya.",
            "14 May\nBahtera pernikahan dimulai",
            "14 Feb\nAhnaf lahir",
            "5 Agustus\nCeisya lahir")
)


data %>% 
  ggplot(aes(x = tahun, label = label, color = event)) +
  
  annotate("segment", x = 1, xend = 2, y = 0, yend = 0, size = 1.25, color = "steelblue") +
  
  geom_point(aes(y = 0),size = 1, shape = 3) +
  
  geom_label(aes(y = 0, label = label_tahun, fill = event),
             color = "white") +
  
  scale_fill_manual(values = c("brown","darkgreen","steelblue")) +
  
  geom_mark_circle(aes(y = 0, label = NA, description = label, fill = event), 
                   con.cap = -2, fill = NA, color = NA, label.fontsize = 12, label.hjust = 0,
                   label.fill = NA,
                   con.size = .5, con.border = "one",
                   con.type = "elbow") +
  
  labs(title = "Our Love Story",
       subtitle = "14 Mei 2021 menandai #SatuDekade pernikahan saya dan Santi",
       caption = "Visualized using R\nikanx101.com")+
  
  theme_void() +
  
  coord_flip() +
  
  theme(legend.position = "none",
        plot.background = element_rect(fill = "#facae8", color = NA),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 30),
        plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 20),
        plot.caption = element_text(hjust = 0.5, face = "bold", size = 12)) #xlim(0,7)+ ylim(-35,35)

ggsave("Timeline.png", width = 14, height = 12, dpi = 450)
