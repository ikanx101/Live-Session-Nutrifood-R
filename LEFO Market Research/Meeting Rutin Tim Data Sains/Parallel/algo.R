rm(list=ls())

# initial condition
a = 0
b = 2
c = 2
d = 3
nx = 10^4
ny = 10^4
f = function(x,y){2*x + y^3}

# serial
int_dobel_serial = function(f,a,b,c,d,nx,ny){
  mulai = Sys.time()
  hx = (b - a)/nx
  hy = (d - c)/ny
  int = 0
  for(i in 0:(nx-1)){
    for(j in 0:(ny-1)){
      xi = a + hx/2 + i*hx
      yj = c + hy/2 + j*hy
      int = int + hx*hy*f(xi, yj)
    }
  }
  output = list("Integral f(x,y) dy dx adalah:" = int,
                "Runtime" = Sys.time()-mulai)
  return(output)
}

# paralel
library(parallel)
numCores = detectCores()
clust = makeCluster(numCores) 
fx = function(df){2*df[1] + df[2]^3}

# paralel
int_dobel_paralel = function(dummy){
  mulai = Sys.time()
  hx = (b - a)/nx
  hy = (d - c)/ny
  x = seq(a+(hx/2),b,by = hx)
  y = seq(c+(hy/2),d,by = hy)
  xy = expand.grid(x,y)
  xy = as.data.frame(xy)
  int = hx*hy*sum(fx(xy))
  output = list("Integral f(x,y) dy dx adalah:" = int,
                "Runtime" = Sys.time()-mulai)
  return(output)
}

print("Hasil Menggunakan Serial Processing:")
int_dobel_serial(f,a,b,c,d,nx,ny)

cat("\n\nHasil Menggunakan Parallel Processing:")
mclapply(100,int_dobel_paralel,mc.cores = numCores)

print("\n\nHasil menggunakan parallel kedua: ")
clusterExport(clust, c("a","b","c","d","nx","ny","fx"))

parSapply(clust, 100, int_dobel_paralel)
cat("\n\n")
parLapply(clust,100,int_dobel_paralel)
