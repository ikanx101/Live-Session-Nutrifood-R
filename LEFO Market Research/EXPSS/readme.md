Penjelasan
================
Ikang Fadhli
Update 3 November 2020

# *Learning Forum Market Research*

## *Dear All,*

Kita telah menyelesaikan *training* `expss` hari pertama. Kita telah
mempelajari bagaimana:

1.  Membuat tabulasi frekuensi.
2.  Membuat cross tabulasi.
3.  Melakukan uji signifkansi dari cross tabulasi.
4.  Mengekspor tabulasi dari **R** ke *Excel file* (`.xlsx`).

Sekarang pada sesi kedua, kita akan membahas `2` hal, yakni:

1.  *Filter*.
2.  *Recode*.

Untuk melakukannya, saya akan menggunakan prinsip `tidy` di **R** dengan
perintah *pipe* (`%>%`).

## *Dataset* untuk *training*

*Dataset* training akan tetap menggunakan data yang sama, yakni:
`dataset latihan.xlsx`.

-----

# Materi *Training*

## Prinsip dasar `library(expss)`

Skrip pada `library(expss)` selalu menggunakan *pipe* pada `tidyverse`
(`%>%`).

Berikut adalah alur pengerjaannya:

1.  Tabulasi dimulai dengan memanggil dataset.
2.  Memanggil variabel yang hendak dihitung dengan
    `tab_cells(nama_variabel)`.
3.  Jika hendak melakukan *cross tabulasi*, tambahkan perintah
    `tab_cols(nama_variabel)` sesuai dengan variabel yang hendak
    disilangkan.
4.  Jika hendak melakukan *drill down* pada baris, tambahkan perintah
    `tab_rows(nama_variabel)` sesuai dengan variabel yang hendak
    disilangkan.
5.  Panggil perintah untuk menghitung persentase atau *real number*.
    Untuk persentase, bisa menggunakan perintah `tab_stat_cpct()`. Untuk
    *real number*, bisa menggunakan perintah `tab_stat_cases()`.
6.  Jika hendak melakukan uji beda dua proporsi pada *cross tabulasi*,
    `tambahkan tab_last_sig_cpct()` atau `tab_last_sig_cases()`.
7.  Akhiri dengan `tab_pivot()`.

## Prinsip dasar *filter*

Untuk melakukan *filtering data*, kita akan menggunakan perintah
`filter()` berisi variabel dan kondisi yang kita inginkan.

Beberapa *conditional* yang perlu diketahui dan biasa digunakan untuk
data *survey* antara lain:

  - `==` digunakan pada saat mewajibkan kondisi yang **sama**.
  - `!=` digunakan pada saat mewajibkan kondisi yang **tidak sama**.
  - `|` digunakan untuk **OR**.
  - `&` digunakan untuk **AND**.

## Prinsip dasar *recode*

Untuk melakukan *recode* dari variabel yang ada, kita akan menggunakan
perintah `mutate()` berisi formula yang akan ita hitung. Biasanya proses
*recode* berasal dari *conditional* dari variabel lain.

Contohnya adalah membuat kategori `T2B`, `Netral`, dan `B2B` dari
pertanyaan berskala `1` sampai `6`. Untuk melakukannya, kita bisa
menggunakan perintah `case_when()`.

## **R** *Script*

Semua *script* yang dibutuhkan bisa di-*download* di *folder* ini dengan
judul `skrip LEFO.R`.

**Silakan di-*download* terlebih dahulu skripnya *yah*. Kita akan
melanjutkan dari sana.**
