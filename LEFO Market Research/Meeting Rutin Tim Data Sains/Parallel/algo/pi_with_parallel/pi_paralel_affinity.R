rm(list=ls())
set.seed(2022)

# initial condition
nx = 10^8

# fungsi
fx = function(x){4 * sqrt(1 - x^2)}

# paralel
hitung_pi_par = function(n){
  xi = runif(n)
  fxi = fx(xi)
  pi_numerik = mean(fxi)
  return(pi_numerik)
}

# paralel
library(parallel)
numCores = detectCores()

# kita pecah
n_pecah = nx / 5

# affinity
affi = 1:5

# hitung waktu
mulai = Sys.time()

print("Hasil Menggunakan Parallel Processing:")
pi = mclapply(list(n_pecah,n_pecah,n_pecah,n_pecah,
                   n_pecah),
              hitung_pi_par,mc.preschedule = FALSE,affinity.list = affi,mc.cores = numCores)

pi = mean(unlist(pi))

waktu = Sys.time() - mulai

print(pi)
print(waktu)  
