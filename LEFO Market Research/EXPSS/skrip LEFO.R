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
# ============================

# untuk melakukan export ke Excel, kita akan memanfaatkan library(openxlsx)
# caranya:

# pertama
# kita bikin workbook-nya
wb = createWorkbook()

# cara panjang:
  # kita akan masukin satu-persatu 11 tabel ke dalam satu file excel
  # sekarang kita tambahin sheet-nya
  # sheet kosong dengan nama yang kita mau
sh = addWorksheet(wb,"tabel 1 JK")

  # selanjutnya kita masukin tabel_1 kedalam sheet yang sudah kita siapkan!
xl_write(tabel_1,wb,sh)

# kita lakukan untuk semua tabel
sh = addWorksheet(wb,"tabel 2")
xl_write(tabel_2,wb,sh)
sh = addWorksheet(wb,"tabel 3")
xl_write(tabel_3,wb,sh)
sh = addWorksheet(wb,"tabel 4")
xl_write(tabel_4,wb,sh)
sh = addWorksheet(wb,"tabel 5")
xl_write(tabel_5,wb,sh)
sh = addWorksheet(wb,"tabel 6")
xl_write(tabel_6,wb,sh)
sh = addWorksheet(wb,"tabel 7")
xl_write(tabel_7,wb,sh)
sh = addWorksheet(wb,"tabel 8")
xl_write(tabel_8,wb,sh)
sh = addWorksheet(wb,"tabel 9")
xl_write(tabel_9,wb,sh)
sh = addWorksheet(wb,"tabel 10")
xl_write(tabel_10,wb,sh)
sh = addWorksheet(wb,"tabel 11")
xl_write(tabel_11,wb,sh)

saveWorkbook(wb,"tabulasi LEFO.xlsx",overwrite = T)
