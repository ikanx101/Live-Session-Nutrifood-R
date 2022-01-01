rm(list=ls())

# initial condition
nx = 10^8

fx = function(x){4 * sqrt(1 - x^2)}

# paralel
library(parallel)
numCores = detectCores()

# paralel
hitung_pi_par = function(n){
  mulai = Sys.time()
  xi = runif(n)
  fxi = fx(xi)
  pi_numerik = mean(fxi)
  waktu = Sys.time() - mulai
  output = list("Perhitungan pi" = pi_numerik,
		"Runtime" = waktu)
  return(output)
}

print("Hasil Menggunakan apply:")
lapply(nx,hitung_pi_par)
