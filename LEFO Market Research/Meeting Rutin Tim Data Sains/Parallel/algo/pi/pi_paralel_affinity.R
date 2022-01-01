rm(list=ls())

# initial condition
nx = 10^8

# fungsi
fx = function(x){4 * sqrt(1 - x^2)}

# paralel
hitung_pi_par = function(n){
  fxi = fx(xi)
  pi_numerik = mean(fxi)
  return(pi_numerik)
}

# paralel
library(parallel)
numCores = detectCores()

# hitung waktu
mulai = Sys.time()
# generate
xi = runif(nx)

# kita pecah
n_pecah = nx / numCores
x1 = xi[1:n_pecah]
x2 = xi[(n_pecah+1):(n_pecah*2)]
x3 = xi[(2*n_pecah+1):(n_pecah*3)]
x4 = xi[(3*n_pecah+1):(n_pecah*4)]
x5 = xi[(4*n_pecah+1):(n_pecah*5)]
x6 = xi[(5*n_pecah+1):(n_pecah*6)]
x7 = xi[(6*n_pecah+1):(n_pecah*7)]
x8 = xi[(7*n_pecah+1):(n_pecah*8)]

# affinity
affi = 1:8

print("Hasil Menggunakan Parallel Processing:")
mclapply(list(x1,x2,x3,x4,x5,x6,x7,x8),hitung_pi_par,mc.preschedule = FALSE,affinity.list = affi)

waktu = Sys.time() - mulai
  
