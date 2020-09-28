Read Me First
================

# *Dear Trainees*

## *Preface*

Selamat datang pada *live session* **training R**. Pada sesi ini tim
*trainer* akan memfasilitasi *training* ini pada tema **Data
Visualization** dan **Prediction**.

Semua materi *training* dan **R Markdown** yang dikerjakan saat *live*
ini dapat dipantau juga melalui halaman `github` ini secara *realtime*.

## Materi *Training*

Materi *training* telah disiapkan oleh `Sigit`, `Teguh` dan `Lenny`.
Sebagian di antaranya telah dikerjakan pada saat sesi di
**Nutriversity**.

Oleh karena itu, *trainee* yang diperbolehkan mengikuti sesi ini adalah
*trainee* yang telah menyelesaikan minimum *progress* di
**Nutriversity**.

Berikut adalah *rundown training*:

<img src="readme_files/figure-gfm/unnamed-chunk-1-1.png" width="672" />

## Hari I

### Sesi 1

Pada sesi 1 ini, saya akan melakukan *review* singkat terhadap materi
dari *file* `pdf` yang telah dibaca dan dilakukan. Fokus pada materi
tersebut adalah penggunaan `library(tidyverse)` yakni *function pipe*:
`%>%` untuk melakukan *data carpentry* atau *data manipulation*.

Selain itu, konsep dasar *importing* data dan *setting working
directory* juga akan diingatkan kembali.

Oh iya, mengenai jawaban terkait perubahan *habit* belanja, kalian bisa
melihatnya di [sini](https://ikanx101.com/blog/minimarket-bekasi/).

### Sesi 2

Pada sesi ini kita akan melakukan praktek langsung melanjutkan video
dari `Sigit`. Diharapkan rekan-rekan *trainee* telah melakukan *workout*
dan melengkapi *R Markdown* yang telah diberikan.

> Jika ternyata belum sempat dilengkapi, rekan-rekan bisa mengambilnya
> di halaman *github* ini.

Selama *training* *data visualization*, ada tiga komponen yang harus
masuk ke dalam *working directory*:

1.  Data `USvideos.csv`.
2.  *R Markdown* `Materi Data Viz Day 1.Rmd` (*file* `.Rmd` ini akan
    selalu *update*).
3.  *Folder* `asset`.

Pastikan juga bahwa *libraries* sudah dipanggil di awal kita melakukan
analisa\!

-----

## **Ground Rules**

Berkaca dari pengalaman di *training batch* sebelumnya, maka pada *live
session* kali ini akan ada beberapa peraturan, yakni:

1.  *Trainees* akan dibagi menjadi `3` buah kelompok. Masing-masing
    kelompok akan dibuatkan grup **QnA** terpisah dari grup *live
    session*. Di dalam setiap grup tersebut, akan ada *trainer
    fasilitator* yang sudah siap membantu.
2.  Jika ada permasalahan terkait *R markdown*, rekan-rekan bisa
    memanfaatkan grup **QnA** untuk menyelesaikannya dengan cara
    bertanya dan mengirimkan *file* `.Rmd` ke grup masing-masing.
    *Trainer fasilitator* akan mengecek file `.Rmd` rekan-rekan dan
    menginformasikan letak kesalahan yang terjadi.
3.  Jangan takut tertinggal materi, *file* `.Rmd` secara live akan
    terupdate di halaman *github* ini.

### Pembagian Kelompok

Berikut adalah pembagian kelompok untuk hari ini:

#### Kelompok I

Fasilitator: Ikang - Lenny

  - <rindy.agassi@nutrifood.co.id>
  - <ganis.ginanjar@nutrifood.co.id>
  - <rosariani@nutrifood.co.id>
  - <awyatno@nutrifood.co.id>
  - <Edia@nutrifood.co.id>

#### Kelompok II

Fasilitator: Teguh

  - <geovano.satria@nutrifood.co.id>
  - <michael.lopolisa@nutrifood.co.id>
  - <riangga.sujatmiko@nutrifood.co.id>
  - <iman.budiman@nutrifood.co.id>
  - <nevvi.wibella@nutrifood.co.id>
  - <titik.kurniawati@nutrifood.co.id>

#### Kelompok II

Fasilitator: Sigit - Fahmi

  - <arga.putra@nutrifood.co.id>
  - <yulianus.dengi@nutrifood.co.id>
  - <nicolas.orlando@nutrifood.co.id>
  - <audy.fathia@nutrifood.co.id>
  - <caesar.rifa@nutrifood.co.id>

-----

# PENTING\!

Ada banyak cara dalam mengolah data di **R**. Teman-teman bisa
menggunakan prinsip `tidyverse`, `data.table`, dan lainnya. Saya akan
menggunakan prinsip `tidyverse` menggunakan `%>%` agar lebih mudah
dipahami.

## Langkah Pengerjaan di R

Setiap kita bekerja dengan menggunakan **R**, berikut adalah
langkah-langkah standar yang biasa dilakukan:

![](readme_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

-----

# Review Materi dari `.pdf`

##### *by Ikang*

**R** sangat berguna saat kita berhadapan dengan dta dalam bentuk
*unstructured* atau *semi-unstructured*. Data yang sepertinya tidak
mungkin dianalisa bisa saja dianalisa setelah kita lakukan *data
carpentry* atau *data manipulation*.

Sekarang, kita akan mencoba melakukan *data carpentry* menggunakan
prinsip `tidy` dari data yang ada di situs
[BPOM](https://cekbpom.pom.go.id/) untuk kategori **produk pangan**
berikut ini:

<img src="bpom.png" width="1366" />

Data dari website di atas sudah saya *scrape* pada tanggal `15
September 2020` sore. *Scrape* dilakukan menggunakan **R** dengan
memanfaatkan `library(rvest)`. Jika teman-teman mau belajar *web
scrape*, berikut *function* yang saya buat untuk *scrape* data dari
situs tersebut:

Sekarang, kita akan mencoba menjawab beberapa hal berikut:

1.  Provinsi mana yang paling banyak menyumbang listing produk
    terbanyak?
2.  Kemasan apa yang paling banyak digunakan?
3.  Di Jawa Barat, kota mana yang paling sering muncul?

### Bagaimana caranya? Nantikan pada saat live session\!
