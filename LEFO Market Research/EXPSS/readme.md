Penjelasan
================
Ikang Fadhli
Update 1 November 2020 - 11:01

# *Dear All,*

Kita akan ada sesi *learning forum* di hari Senin besok terkait
penggunaan `library(expss)` di **R** sebagai pengganti **SPSS**.

Oleh karena itu, mohon dipersiapkan alat dan bahan beserta bumbunya
*yah*. Sehingga besok kita *gak* ribet terkait teknisnya.

# Langkah-Langkah Persiapan

## 1\. *Install* **R** di laptop atau komputer

Karena kita akan menggunakan **R**, maka langkah pertama adalah
meng-*install* terlebih dahulu **R** dan **R Studio**. Bagaimana cara
meng-*install*-nya?

**R** versi terbaru bisa di-*install* di *link*
[berikut](https://cran.r-project.org/bin/windows/base/).

**R Studio Desktop** versi terbaru bisa di-*install* di *link*
[berikut](https://rstudio.com/products/rstudio/download/).

## 2\. Install *libraries* yang dibutuhkan

Jika **R** dan **R Studio** sudah ter-*install* dengan baik dan benar,
maka kita perlu meng-*install* *libraries* yang diperlukan. Setidaknya
ada beberapa *libraries* yang wajib untuk *data processing*, yakni:

1.  `dplyr`
2.  `tidyr`
3.  `lubridate`
4.  `expss`
5.  `janitor`
6.  `reshape2`
7.  `openxlsx`

Bagaimana cara meng-*install*-nya? Ketikkan perintah berikut ini di
*console* **R Studio** masing-masing:

    install.packages("dplyr")
    install.packages("tidyr")
    install.packages("lubridate")
    install.packages("expss")
    install.packages("janitor")
    install.packages("reshape2")
    install.packages("openxlsx")

Jika semua sudah ter-*install* dengan baik dan benar, maka artinya kita
sudah siap untuk sesi di esok hari *yah*.

> Bagaimana cara mengetahui kita telah meng-*install* *libraries*
> tersebut dengan benar?

Ya kita panggil saja *libraries*-nya:

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(tidyr)
library(expss)
```

    ## 
    ## Attaching package: 'expss'

    ## The following objects are masked from 'package:tidyr':
    ## 
    ##     contains, nest

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     between, compute, contains, first, last, na_if, recode, vars

## Bahan dan Bumbu

Untuk besok, kita akan menggunakan *dataset* dari riset yang sudah lama
dijalankan *yah*.

-----

# Materi *Training*

## Tujuan

Tujuan *training* ini untuk membuat:

1.  Tabulasi frekuensi.
2.  *Cross* tabulasi frekuensi.
3.  Uji beda sig pada *cross* tabulasi.

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
