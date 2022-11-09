rm(list=ls())
library(tictoc)

# initial condition
nx = 10^9

fx = function(x){4 * sqrt(1 - x^2)}

# paralel
library(parallel)
numCores = detectCores()

# paralel
hitung_pi_par = function(n){
  xi = runif(n)
  fxi = fx(xi)
  pi_numerik = mean(fxi)
  output = list("Perhitungan pi" = pi_numerik)
  return(output)
}

print("Hasil Menggunakan Parallel Processing:")
tic()
mclapply(nx,hitung_pi_par,mc.cores = numCores)
toc()