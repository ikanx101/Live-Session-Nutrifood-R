# Materi training hari ini

# TUJUAN
  # 1. membuat tabulasi frekuensi
  # 2. membuat cross tabulasi
  # 3. membuat uji signifikansi dari cross tabulasi
  # 4. melakukan recode
  # 5. export tabulasi ke format excel

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

# buatlah tabel_3 berisi umur, pekerjaan, dan SES responden

  # tabulasi frekuensi persentase
tabel_3 = 
  data %>% 
  tab_cells(a1,
            a3kat,
            a19) %>% 
  tab_stat_cpct() %>% 
  tab_pivot() %>% 
  set_caption("Tabel Umur, Pekerjaan, dan SES Responden")
  
  # kita lihat hasilnya:
tabel_3

# buatlah tabel_4 berisi real number dan persentase dari variabel C1
tabel_4 = 
  data %>% 
  tab_cells(c1) %>% 
  tab_stat_cases() %>% 
  tab_stat_cpct() %>% 
  tab_pivot() %>% 
  set_caption("Tabel C1: Real Number dan Persentase")

  # kita lihat hasilnya:
tabel_4

# ====================================
# ====================================

# Selanjutnya kita akan membuat tabel dari multiple responses!

# buatlah tabel_5 berisi merek minuman buah yang diketahui oleh responden!
tabel_5 = 
  data %>% 
  tab_cells(mrset(b1a1 %to% b1a5)) %>% 
  tab_stat_cpct() %>% 
  tab_sort_desc() %>% 
  tab_pivot() %>% 
  set_caption("Minuman buah yang diketahui responden")

  # kita lihat hasilnya:
tabel_5
