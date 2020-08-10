Read Me First
================

# *Dear Trainees*

## *Preface*

Selamat datang pada *live session* **training R** hari ini. Kali ini
saya akan memfasilitasi *training* ini pada tema **Data Visualization**.

Semua materi *training* dan **R Markdown** yang dikerjakan saat *live*
ini dapat dipantau juga melalui halaman `github` ini secara *realtime*.

## Materi *Training*

Materi *training* telah disiapkan oleh `Sigit` dan telah dikerjakan
sebagian pada saat sesi di **Nutriversity**. Oleh karena itu, *rundown
training* kali ini:

<img src="Rplot.png" width="905" />

### Sesi 1

Pada sesi 1 ini, saya akan melakukan *review* singkat terhadap materi
dari *file* `pdf` yang telah dibaca dan dilakukan. Fokus pada materi
tersebut adalah penggunaan `library(tidyverse)` yakni *function pipe*:
`%>%`.

Selain itu, konsep dasar *importing* data dan *setting working
directory* juga akan diingatkan kembali.

Setelah itu kita akan masuk ke materi dari `Sigit` mengenai
`library(lubridate)`.

### Sesi 2

Pada sesi ini kita akan melakukan praktek langsung melanjutkan video
dari `Sigit`. Diharapkan rekan-rekan *trainee* telah melakukan *work
out* dan melengkapi *R Markdown* yang telah diberikan.

> Jika ternyata belum sempat dilengkapi, rekan-rekan bisa mengambilnya
> di halaman *github* ini.

Fokus bahasan dari sesi ini adalah melakukan visualisasi data dengan
menggunakan `library(ggplot2)` tanpa melupakan keterkaitannya dengan
*function pipe*: `%>%`.

#### Data dan *R Markdown* yang Digunakan

Selama training ini, ada tiga komponen yang harus masuk ke dalam
*working directory*:

1.  Data `USvideos.csv`.
2.  *R Markdown* `Materi Data Viz Day 1.Rmd` (*file* `.Rmd` ini akan
    selalu *update*).
3.  *Folder* `asset`.

### Sesi 3

Pada sesi ini kita akan membuat visualisasi data interaktif dengan cara
mengkonversi *object* `ggplot` ke dalam `plotly`.

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

<table>

<caption>

Kelompok I

</caption>

<thead>

<tr>

<th style="text-align:right;">

id

</th>

<th style="text-align:left;">

trainee

</th>

<th style="text-align:left;">

fasilitator

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Evelyn

</td>

<td style="text-align:left;">

Lenny

</td>

</tr>

<tr>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

May

</td>

<td style="text-align:left;">

Lenny

</td>

</tr>

<tr>

<td style="text-align:right;">

3

</td>

<td style="text-align:left;">

Novita

</td>

<td style="text-align:left;">

Lenny

</td>

</tr>

<tr>

<td style="text-align:right;">

4

</td>

<td style="text-align:left;">

Albert

</td>

<td style="text-align:left;">

Lenny

</td>

</tr>

<tr>

<td style="text-align:right;">

5

</td>

<td style="text-align:left;">

Novia

</td>

<td style="text-align:left;">

Lenny

</td>

</tr>

<tr>

<td style="text-align:right;">

6

</td>

<td style="text-align:left;">

Tikadewi

</td>

<td style="text-align:left;">

Lenny

</td>

</tr>

</tbody>

</table>

<table>

<caption>

Kelompok II

</caption>

<thead>

<tr>

<th style="text-align:right;">

id

</th>

<th style="text-align:left;">

trainee

</th>

<th style="text-align:left;">

fasilitator

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Davin

</td>

<td style="text-align:left;">

Teguh

</td>

</tr>

<tr>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

Andrew

</td>

<td style="text-align:left;">

Teguh

</td>

</tr>

<tr>

<td style="text-align:right;">

3

</td>

<td style="text-align:left;">

Vianna

</td>

<td style="text-align:left;">

Teguh

</td>

</tr>

<tr>

<td style="text-align:right;">

4

</td>

<td style="text-align:left;">

Luthfan

</td>

<td style="text-align:left;">

Teguh

</td>

</tr>

</tbody>

</table>

<table>

<caption>

Kelompok III

</caption>

<thead>

<tr>

<th style="text-align:right;">

id

</th>

<th style="text-align:left;">

trainee

</th>

<th style="text-align:left;">

fasilitator

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Didit

</td>

<td style="text-align:left;">

Fahmi

</td>

</tr>

<tr>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

Yulius

</td>

<td style="text-align:left;">

Fahmi

</td>

</tr>

<tr>

<td style="text-align:right;">

3

</td>

<td style="text-align:left;">

Eko

</td>

<td style="text-align:left;">

Fahmi

</td>

</tr>

<tr>

<td style="text-align:right;">

4

</td>

<td style="text-align:left;">

Patricia

</td>

<td style="text-align:left;">

Fahmi

</td>

</tr>

</tbody>

</table>
