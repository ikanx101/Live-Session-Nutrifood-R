Productive with R Series
================
by: Ikang Fadhli  
Nutrifood Indonesia

# PENDAHULUAN

## Latar Belakang

Tidak setiap waktu kita berada di depan laptop atau komputer.
Penyimpanan *cloud* seperti *Google Drive* atau *OneDrive* kurang
bersahabat bagi analis data, *programmer*, dan *data-related job*.

*Ngoding* seringkali dirasakan cukup sulit. Apalagi begitu banyak
*scripts* atau *commands* yang tidak mungkin “dihapalkan” semua. Oleh
karena itu, kita bisa mempersingkatnya dengan membuat *function*
sendiri.

## Tujuan

Bekerja dengan lebih produktif dengan **R Studio Server**.

-   *Fast*,
-   *Reliable*,
-   *Agile*.

## Bumbu yang Dibutuhkan

Untuk melakukan ini, kita memerlukan beberapa hal ini:

1.  *Gadget* dengan *browser* (`Chrome`, `Mozilla`, atau `Opera`. Saya
    belum mencoba `Safari`) dan koneksi internet.
2.  Akun *Gmail* untuk *run* di *Google Colab*.
3.  Akun `github` untuk *cloud storage*.
4.  Waktu
    ![\\sim 5](https://latex.codecogs.com/png.latex?%5Csim%205 "\sim 5")
    menit untuk instalasi dan konfigurasi **R Studio Server**.

## Bagaimana Cara Kerjanya?

*Google Colab* secara *default* berjalan menggunakan bahasa `Python3`
dalam sistem operasi **Linux** pada *Compute Engine*-nya.

Kita bisa memanfaatkan **Linux** tersebut untuk meng-*install* beberapa
aplikasi *server* seperti **R Studio Server** secara *cloud*. Setelah
itu *port server* tersebut kita *forward* ke *public* menggunakan *ssh
forwarding* di **Linux**.

<img src="readme_files/figure-gfm/unnamed-chunk-2-1.png" width="672" style="display: block; margin: auto;" />

------------------------------------------------------------------------

# *STEP* 1

## Persiapan Github

### Buat Akun Github (opsional)

[Github](https://en.m.wikipedia.org/wiki/GitHub) adalah salah satu situs
yang digunakan oleh banyak *programmer* di dunia sebagai area bekerja.
Salah satu keunggulannya adalah *environment*-nya yang memang dibuat
khusus *programmer*.

Github kini dimiliki oleh *Microsoft* dan bersifat *free* dan *open
source*.

*Backbone* dari Github adalah *software* `Git` yang dibuat oleh penemu
**Linux** ([Linus
Torvalds](https://en.m.wikipedia.org/wiki/Linus_Torvalds)).

> Git software for tracking changes in any set of files, usually used
> for coordinating work among programmers collaboratively developing
> source code during software development. Its goals include speed, data
> integrity, and support for distributed, non-linear workflows
> (thousands of parallel branches running on different systems).

Untuk keperluan market riset, Github akan sangat berguna sebagai
*infinite cloud storage* yang bisa ditempel ke **R Studio** di perangkat
apa saja.

### Buat *Repository*

Silakan buat akun Github (opsional - jika berkenan) lalu coba buat satu
*repository* baru.

Apa itu *repository*?

> Secara simpel suatu repository adalah satu “folder” besar berisi
> project **R** yang hendak kita buat atau kerjakan.

Kita bisa membuat *repository* tersebut *private* atau *public* sesuai
dengan kebutuhan. Kita juga bisa mengajak rekan-rekan kerja yang lain
sebagai *contributors* dengan *access level* yang ditentukan dari awal.

Jika kita tidak memiliki akun Github, kita tetap bisa ***clone public
repository*** ke dalam **R Studio** *environment*. Tapi sifatnya hanya
pasif (hanya menerima dan mengedit) tidak bisa melakukan perubahan
secara *cloud*.

### *Clone* *Repository*

Jika kita sudah membuat *repository*, silakan *clone repository*
tersebut ke **R Studio**.

### *Set Tokens*

Sebagai pengaman agar *file* yang ada di *cloud* tidak diganggu oleh
orang yang tidak berkepentingan, kita perlu membuat *tokens* yang
berguna untuk komunikasi antara **R Studio** dengan Github.

## Set Time Zone

    Sys.setenv(TZ = "GMT")

## Config Git Global Setting

    system('git config --global user.name "yourname"')
    system('git config --global user.email "youremail@email.com"')
