rm(list=ls())

final = c()

monty = function(){
  # ceritanya ada 3 pintu
  pintu = 1:3
  # salah satu memiliki hadiah
  hadiah = sample(pintu,1)
  # sedangkan kita akan pilih sesuai feeling
  pilih = sample(pintu,1)
  # host akan membuka pintu yang tidak berisi hadiah
  buka = pintu[c(-pilih,-hadiah)]
  if(length(buka)>1){buka = sample(buka,1)}
  # akibatnya ada dua pintu yg membuat kita mikir
  mikir = pintu[-buka]
  # sebaiknya kita?
  decision = ifelse(pilih == hadiah,"stay","switch")
  # save decision
  final <<- c(final,decision)
  message = paste0("Ada 3 pintu\nTanpa sepengetahuan kita, hadiah ada di: ",hadiah,
                   "\nSedangkan kita pilih: ",pilih,
                   "\nTerus host membuka pintu: ",buka,
                   "\nAkibatnya kita jadi mikir, dari dua pintu ini: ",
                   paste(mikir,collapse = " dan "),
                   " mau stay atau pindah?\nLebih baik kita: ",
                   decision)
  cat(rep("\n",2))
  cat(message)
}

n = 9000
mulai = Sys.time()

for(i in 1:n){
  monty()
}

runtime = Sys.time() - mulai
runtime = round(runtime,5)

cat("\n\nUntuk melakukan simulasi sebanyak ",n," kali dibutuhkan waktu selama ")
cat(runtime,"\n\n")
# proporsi
prop.table(table(final))
