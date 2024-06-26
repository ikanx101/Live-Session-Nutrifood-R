rm(list=ls())

# probability
p_apel = 35/100
p_jeruk = 25/55
p_mangga = 40/60
p_salak = 15/75

# yang diambil pelanggan
n_apel = 4
n_jeruk = 8
n_mangga = 3
n_salak = 5

# simulasi
busuk = c()
n_simu = 90000

start = Sys.time()

for(i in 1:n_simu){
  apel = sample(c(1,0),n_apel,replace = T,prob = c(p_apel,1-p_apel))
  jeruk = sample(c(1,0),n_jeruk,replace = T,prob = c(p_jeruk,1-p_jeruk))
  mangga = sample(c(1,0),n_mangga,replace = T,prob = c(p_mangga,1-p_mangga))
  salak = sample(c(1,0),n_salak,replace = T,prob = c(p_salak,1-p_salak))
  buah_busuk = sum(apel,jeruk,mangga,salak)
  busuk = c(buah_busuk,busuk)
}

rekap_simulasi = data.frame(iter = 1:n_simu,busuk)
rekap_simulasi$mean = rekap_simulasi$busuk

for(k in 2:n_simu){
  rekap_simulasi$mean[k] = mean(rekap_simulasi$busuk[1:k])
}

end = Sys.time() - start
end = round(end,5)

message = paste0("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
                 "Expected buah busuk yang didapatkan pembeli: ",
                 rekap_simulasi$mean[n_simu],
                 "\n\nButuh waktu selama: ",
                 end,
                 " detik\n\nUntuk simulasi sebanyak: ",
                 n_simu," kali\n\n")
cat(message)
