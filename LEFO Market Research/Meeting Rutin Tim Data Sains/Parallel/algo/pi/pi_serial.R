rm(list=ls())

# initial condition
nx = 10^8

fx = function(x){4 * sqrt(1 - x^2)}

# serial
hitung_pi_serial = function(n){
  mulai = Sys.time()
  sum = 0
  for(i in 1:n){
    xi = runif(1)
    sum = sum + fx(xi)
    }
  pi_numerik = sum/n
  waktu = Sys.time() - mulai
  output = list("Perhitungan pi" = pi_numerik,
		"Runtime" = waktu)
  return(output)
}

print("Hasil Menggunakan Serial Processing:")
hitung_pi_serial(nx)

