# Materi training hari PERTAMA

# TUJUAN
  # 1. membuat tabulasi frekuensi
  # 2. membuat cross tabulasi
  # 3. membuat uji signifikansi dari cross tabulasi
  # 4. export tabulasi ke format excel

# ====================================
# PENTING
# sebelumnya, pastikan working directory kita berada di directory yang tepat
setwd("~/Documents/Live-Session-Nutrifood-R/LEFO Market Research/EXPSS")
# ====================================


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

# buatlah tabel_6 berisi alasan kesukaan dari c3a1 sampai c3a4!
tabel_6 = 
  data %>% 
  tab_cells(mrset(c3a1 %to% c3a4)) %>% 
  tab_stat_cpct() %>% 
  tab_sort_desc() %>% 
  tab_pivot() %>% 
  set_caption("Minuman buah yang diketahui responden")

  # kita lihat hasilnya:
tabel_6

# ====================================
# ====================================

# Selanjutnya kita akan membuat tabel dari cross tabulasi!

# buatlah tabel_7 crosstab antara usia dan gender!
tabel_7 = 
  data %>% 
  tab_cells(a1) %>% 
  tab_cols(jk) %>% 
  tab_stat_cpct() %>% 
  tab_pivot() %>% 
  set_caption("Crosstab antara usia dan gender")

  # kita lihat hasilnya:
tabel_7

# ============================
# MODIFIKASI DARI CROSS TAB

# Penambahan kolom total
tabel_8 = 
  data %>% 
  tab_cells(a1) %>% 
  tab_cols(total(),jk) %>% 
  tab_stat_cpct() %>% 
  tab_pivot() %>% 
  set_caption("Crosstab antara usia dan gender DENGAN TOTAL")

# kita lihat hasilnya:
tabel_8

# kita buat tabel_9 yang berupa cross tab antara gender, usia, dan SES
tabel_9 = 
  data %>% 
  tab_cells(a1) %>% 
  tab_rows(a19) %>% 
  tab_cols(total(),jk) %>% 
  tab_stat_cpct() %>% 
  tab_pivot() %>% 
  set_caption("Crosstab antara usia, SES, dan gender DENGAN TOTAL")

  # kita lihat hasilnya:
tabel_9

# buat tabel_10 isinya crosstab usia dan gender tapi pake signifikansi
tabel_10 = 
  data %>% 
  tab_cells(a1) %>% 
  tab_cols(jk) %>% 
  tab_stat_cpct() %>% 
  tab_last_sig_cpct() %>% 
  tab_pivot() %>% 
  set_caption("Crosstab antara usia dan gender")

  # kita lihat hasilnya:
tabel_10

# buatlah tabel_11 berisi crosstab gender vs merek minuman buah 
# yang diketahui oleh responden!
tabel_11 = 
  data %>% 
  tab_cells(mrset(b1a1 %to% b1a5)) %>% 
  tab_cols(jk,total()) %>% 
  tab_stat_cpct() %>% 
  tab_sort_desc() %>% 
  tab_last_sig_cpct() %>% 
  tab_pivot() %>% 
  set_caption("Gender vs Minuman buah yang diketahui responden")

  # kita lihat hasilnya:
tabel_11

# ============================
# Materi training hari KEDUA

# TUJUAN
  # 1. melakukan filtering
  # 2. melakukan recode
  # 3. Custom function:
      # 1. Uji 2 proporsi
      # 2. Lain-lain

# training hari kedua kita mulai dari baris ini:

# FILTERING
# buat tabel_12 berisi tabulasi SES dari responden dengan gender laki-laki
tabel_12 = 
  data %>% 
  filter(jk == "Pria") %>% 
  tab_cells(a19) %>% 
  tab_stat_cpct() %>% 
  tab_pivot() %>% 
  set_caption("Tabel SES Responden utk Laki-Laki")

  # kita lihat hasilnya yah:
tabel_12

# buat tabel_13 berisi tabulasi merek-merek yang diketahui dari responden 
  # dengan SES Upper I
tabel_13 = 
  data %>% 
  filter(a19 == "Upper 1") %>% 
  tab_cells(mrset(b1a1 %to% b1a5)) %>% 
  tab_stat_cpct() %>% 
  tab_sort_desc() %>% 
  tab_pivot() %>% 
  set_caption("Minuman buah yang diketahui responden base resp Upper 1")

  # kita lihat hasilnya yah:
tabel_13

# buat tabel_13b berisi tabulasi merek-merek yang diketahui dari responden
  # Wanita dengan SES Middle 1

    # Cara pertama dengan membuat filter bertingkat
tabel_13b = 
  data %>% 
  filter(jk == "Wanita") %>% 
  filter(a19 == "Middle 1") %>% 
  tab_cells(mrset(b1a1 %to% b1a5)) %>% 
  tab_stat_cpct() %>% 
  tab_sort_desc() %>% 
  tab_pivot() %>% 
  set_caption("Minuman buah yang diketahui responden base resp Wanita Middle 1")

tabel_13b

    # Cara kedua dengan menggunakan operator AND
tabel_13c = 
  data %>% 
  filter(jk == "Wanita" & a19 == "Middle 1") %>% 
  tab_cells(mrset(b1a1 %to% b1a5)) %>% 
  tab_stat_cpct() %>% 
  tab_sort_desc() %>% 
  tab_pivot() %>% 
  set_caption("Minuman buah yang diketahui responden base resp Wanita Middle 1")

tabel_13c

# Kesimpulannya: 13_b dan 13_c sama

# RECODE
# buat kategori B2B, Netral, dan T2B dari pertanyaan tingkat kesetujuan!
  # lalu buat tabel_14 berisi tabulasi frekuensinya!

# recode cara 1
data = 
  data %>% 
  mutate(
    c2_kategori_cara1 = case_when(
      c2 == "[ 2 ] Tidak puas" ~ "B2B",
      c2 == "[ 3 ] Agak tidak puas" ~ "Netral",
      c2 == "[ 4 ] Agak puas" ~ "Netral",
      c2 == "[ 5 ] Puas" ~ "T2B",
      c2 == "[ 6 ] Sangat puas" ~ "T2B"
    )
  )

# recode cara 2
  # kita akan memanfaatkan pattern recognition
data = 
  data %>% 
  mutate(
    c2_kategori_cara2 = case_when(
      grepl("2",c2) ~ "B2B",
      grepl("3|4",c2) ~ "Netral",
      grepl("5|6",c2) ~ "T2B"
    )
  )

tabel_14 = 
  data %>% 
  tab_cells(c2,c2_kategori_cara1) %>% 
  tab_stat_cpct() %>% 
  tab_pivot() %>% 
  set_caption("Tingkat Kepuasan")

tabel_14

# Cobain Recode Alasan ke Parent Alasan
  # misalkan kalau ada kata "rasa" masuk ke parent "RASA"
  # kita akan memanfaatkan pattern recognition
data = 
  data %>% 
  mutate(
    parent_c3a1 = case_when(
      grepl("rasa|asam|manis",c3a1,ignore.case = T) ~ "Alasan Rasa"
    ),
    parent_c3a2 = case_when(
      grepl("rasa|asam|manis",c3a2,ignore.case = T) ~ "Alasan Rasa"
    ),
    parent_c3a3 = case_when(
      grepl("rasa|asam|manis",c3a3,ignore.case = T) ~ "Alasan Rasa"
    ),
    parent_c3a4 = case_when(
      grepl("rasa|asam|manis",c3a4,ignore.case = T) ~ "Alasan Rasa"
    )
  )


# CUSTOM FUNCTION
# saya telah membuat beberapa custom function yang biasa dipakai untuk 
# membuat report MR
# silakan dipanggil:
source("https://raw.githubusercontent.com/ikanx101/belajaR/master/All%20Func.R")

# Uji proporsi untuk tabel_1 
tabel_1

# cara pakai base R
prop.test(c(128,134),
          c(262,262))

# pakai custom function
cek.dua.proporsi.donk(128,262,134,262)

# Contoh untuk membuat pie chart
bikinin.pie.chart.dari.data.saya.donk(data,
                                      data$jk,
                                      "Jenis Kelamin Responden",
                                      "Base: All Responden")


# ============================
# EXPORT KE EXCEL
# untuk melakukan export ke Excel, saya akan membuatnya lebih simpel dengan melakukan looping
# apa itu looping?
  # pengulangan yang kita perintahkan agar dilakukan secara otomatis

# bagaimana caranya?
# pertama
# kita bikin workbook-nya
wb = createWorkbook()

# lalu saya buat variabel bernama tabel_all
# berisi list dari semua tabel yang telah kita buat bersama-sama
tabel_all = list(tabel_1,
                 tabel_2,
                 tabel_3,
                 tabel_4,
                 tabel_5,
                 tabel_6,
                 tabel_7,
                 tabel_8,
                 tabel_9,
                 tabel_10,
                 tabel_11,
                 tabel_12,
                 tabel_13,
                 tabel_13b,
                 tabel_13c,
                 tabel_14)

# bikin sheet
nama_sheet = paste0("tabulasi all")
sh = addWorksheet(wb, nama_sheet)

# masukin semua tabel ke sheet tersebut
xl_write(tabel_all, wb, sh)

# export ke Excel
saveWorkbook(wb, "hasil tabulasi new.xlsx", overwrite = TRUE)
