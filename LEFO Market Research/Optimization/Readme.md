Welcome\!
================

*Repositories* ini berisi *R Markdown* penyelesaian dari beberapa kasus
yang diberikan pada saat ***optimization training*** oleh **FINANMOS
ITB** 2021.

## Catatan Penting Tentang *Optimization*

*Optimization* berarti proses pencarian suatu nilai yang **optimal**.
Kondisi optimal bisa terjadi saat sesuatu bernilai **maksimum** atau
**minimum**.

Hal tersebut yang harus kita pahami.

Permodelan matematika terkait *optimization* tidak lepas dari `4` hal
berikut ini:

1.  *Decision Variable*, yakni nilai yang ingin dicari. Diharapkan dari
    nilai ini akan tercipta kondisi yang optimal.
2.  *Parameter*, yakni nilai yang besarannya *given*. Jika kita melihat
    pada kasus *real*, parameter adalah nilai yang tidak kita kontrol.
3.  *Constraints*, yakni *boundaries* (limitasi) yang ada pada *problem*
    yang dihadapi. Bisa jadi dalam suatu kasus, kita membuat permodelan
    matematika yang tidak memiliki *constraints*.
4.  *Objective function*, yakni kondisi optimal yang harus dipenuhi.

*Parameter* dan *decision variable* akan muncul pada *constraints* dan
*objective function*.

Suatu *decision variable* disebut *feasible* jika:

> ***Decision variable yang didapatkan tidak melanggar constraints.***

Suatu *decision variable* disebut optimal jika:

> ***Decision variable yang didapatkan memenuhi objective function.***

## Contoh Kasus yang Dibahas

<img src="contoh.jpg" width="1149" />

## *Cases*

Ada 4 *cases* dari *training* yang sudah saya masukkan di sini:

1.  Case I: Koperasi Susu Berkah. *Sudah dibahas pagi ini*.
2.  Case II: Tiga Mesin Filling.
3.  Case III: Lampu Penerangan Jalan.
4.  Case IV: Perusahaan Cat.

Saya menggunakan **R** untuk membuat model *optimization* dan di-*solve*
dengan *engine* yang tersedia di `library(ompr)`.

Agak berbeda dengan *libraries* yang akan digunakan saat *training*
dengan **FINANMOS ITB** kelak namun tetap menghasilkan hasil yang sama.

> ***Silakan Anda mendownload file*** `.html` ***yang ada pada
> masing-masing folder*** `case`.

## **Discord**

Punya akun *Discord*? Kalau belum, silakan *download apps*-nya di
[sini](https://discord.com/).

*Available* untuk **iOS**, **Android**, **Windows**, dan **Linux**.

*Join discord* **Nutrifood x R** di *link* [berikut
ini](https://discord.gg/zy9XJgsf).

-----

Selamat belajar.

*Feel free to discuss*.

*Created by:* [Ikang Fadhli](https://ikanx101.com/)

*Last update:* 2021-03-22 08:43:07
