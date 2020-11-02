# Materi training hari ini

# TUJUAN
  # 1. membuat tabulasi frekuensi
  # 2. membuat cross tabulasi
  # 3. membuat uji signifikansi dari cross tabulasi
  # 4. melakukan recode
  # 5. Export tabulasi ke format excel

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


# ====================================
# ====================================

# sekarang kita akan membuat tabulasi frekuensi

  # tabulasi frekuensi real number
tabel_1 = 
  data %>% 
  tab_cells(jk) %>% 
  tab_stat_cases() %>% 
  tab_pivot() %>% 
  set_caption("Real Number Jenis Kelamin")

  # bagaimana cara melihat tabel_1?
    # kita panggil saja
tabel_1

  # tabulasi frekuensi persentase
tabel_2 = 
  data %>% 
  tab_cells(jk) %>% 
  tab_stat_cpct() %>% 
  tab_pivot() %>% 
  set_caption("Percentage Jenis Kelamin")

  # bagaimana cara melihat tabel_2?
    # kita panggil saja
tabel_2

# gimana?
# mudah kan?
