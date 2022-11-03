rm(list=ls())

library(dplyr)
library(readxl)

# ini isi dengan path dari folder yang diinginkan
folder_path = "~/Live-Session-Nutrifood-R/LEFO Market Research/Gabung Folder/Folder Berisi Files/"

# ini ambil semua nama files
# contohnya semua dalam xlsx ya
nama_files = list.files(folder_path,pattern = ".xlsx")

# kita ambil dataframe trus kita kasih nama_files sebagai kolom
draft_hasil = vector("list",length(nama_files))
for(y in 1:length(nama_files)){
  temp = read_excel(paste0(folder_path,nama_files[y]))
  temp$keterangan = nama_files[y]
  draft_hasil[[y]] = temp
}

# kita gabung lagi filenya
final = do.call(rbind,draft_hasil)

# export ke excel
openxlsx::write.xlsx(final,file = "hasil gabung.xlsx")