# Materi training hari ini

# TUJUAN
#   1. membuat tabulasi frekuensi
#   2. membuat cross tabulasi
#   3. membuat uji signifikansi dari cross tabulasi

# sebelumnya, pastikan working directory kita berada di directory yang tepat

# mari kita mulai ya

# ====================================

# bersih-bersih global environment
rm(list = ls())

# panggil libraries
library(readxl)
library(dplyr)
library(expss)
library(openxlsx)

# panggil dataset latihan
  # salah satu keuntungan mengolah data entry hasil survey dengan R adalah kita
  # tidak perlu membuat koding jawaban text ke dalam numerik.
  # biarkan saja data hasil entry di excel memiliki bentuk teks.

data = read_excel("dataset latihan.xlsx")

# cek struktur data
  # sebelum bekerja lebih lanjut, mari kita lihat struktur data tersebut!

str(data)

  # terlihat ada 262 baris (responden)
  # dan ada 17 kolom (pertanyaan atau variabel)

# sekarang kita akan membuat tabulasi frekuensi

  # tabulasi frekuensi real number
data %>% 
  tab_cells(jk) %>% 
  tab_stat_cpct() %>% 
  tab_pivot()

  # tabulasi frekuensi persentase
data %>% 
  tab_cells(jk) %>% 
  tab_stat_cpct() %>% 
  tab_pivot()

# gimana?
# mudah kan?
