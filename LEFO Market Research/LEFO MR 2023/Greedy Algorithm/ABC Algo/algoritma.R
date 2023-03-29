rm(list=ls())

setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/Greedy Algorithm/ABC Algo")

# ==============================================================================
# libraries
library(dplyr)
library(tidyr)
library(parallel)
library(ggplot2)

# kita set corenya berapa
numcore = 7

# kita set berapa banyak food source
n_scout = 15

# kita set berapa banyak iterasi
n_iterasi = 5
# ==============================================================================


# ==============================================================================
# kita masukin soalnya
df = mtcars %>% select(mpg,wt)
row.names(df) = NULL
df
# ==============================================================================

# ==============================================================================
# kita buat function untuk generate calon solusi dulu
generate_food_source = function(dummy){
  runif(2,min = -50,max = 50)
}

# kita akan buat juga function untuk menghitung obj function
# yakni dengan mencari pasangan x dan y yang meminimumkan MAE
obj_func = function(list){
  # kita buat dulu data framenya
  temp         = df
  temp$x       = list[1]
  temp$y       = list[2]
  temp$mpg_hit = (temp$x * temp$wt) + temp$y
  MAE          = Metrics::mae(temp$mpg,temp$mpg_hit)
  output       = 100 - MAE
  return(output)
}

# measure the quality of food
food_qual = function(food){
  qual = 0
  if(food >= 0){qual = 1/(1+food)}
  if(food <  0){qual = 1 + abs(food)}
  return(qual)
}

# kita harus pastikan jika masalah kita maksimasi, maka food qualnya dicari yang minimal
# kalau masalah kita minimal, maka food qualnya dicari yang maksimal

forager_bee = function(i){
  # generate random numbers
  theta = runif(1,min = -1,max = 1)
  p     = sample((1:n_scout)[-i],1)
  x_y   = sample(2,1)
  # pilih bee utama
  bee   = food_sources[[i]]
  # pilih bee lain
  bee_  = food_sources[[p]]
  # kita hitung bagian yang baru
  bee_new = bee + theta * (bee_ - bee) 
  # membuat output
  if(x_y == 1){output = c(bee_new[1],bee[2])}
  if(x_y == 2){output = c(bee[1],bee_new[2])}
  return(output)
}

# untuk membuat grafik
bikin_grafik = function(list){
  x    = rep(0,length(list))
  y    = rep(0,length(list)) 
  for(i in 1:length(food_sources)){
    x[i] = food_sources[[i]][1]
    y[i] = food_sources[[i]][2]
  }
  plot = data.frame(x,y) %>% 
    ggplot(aes(x,y)) + geom_point(shape = 4) + 
    ylim(-70,70) + xlim(-70,70) + 
    geom_point(aes(y = 37.285,   x = -5.344),color = "red",size = 2.5) +
    geom_point(aes(y = 34.232276,x = -4.539481),color = "steelblue",size = 2.5,shape = 5)
  print(plot)
}
# ==============================================================================


trial_counter = rep(0,n_scout)

# EMPLOYED BEE PHASE
# kita mulai TAHAP I
food_sources = mclapply(1:n_scout,generate_food_source,mc.cores = numcore)

# kita mulai iterasinya dari sini
for(iter in 1:n_iterasi){
  # kita bikin plot
  Sys.sleep(.5)
  bikin_grafik(food_sources)
  # kita hitung nilai F-nya
  f_x = mcmapply(obj_func,food_sources,mc.cores = numcore)
  # kita hitung food quality-nya
  fit = mcmapply(food_qual,f_x,mc.cores = numcore)
  
  # kita mulai TAHAP II
  # mencari food sources baru
  food_sources_new = mclapply(1:n_scout,forager_bee,mc.cores = numcore)
  # kita hitung nilai F-nya
  f_x_new = mcmapply(obj_func,food_sources_new,mc.cores = numcore)
  # kita hitung food quality-nya
  fit_new = mcmapply(food_qual,f_x_new,mc.cores = numcore)
  
  # sekarang kita bandingkan
  decision = fit_new < fit
  
  # kita tuliskan food sources yang final
  food_sources = ifelse(decision == T, food_sources_new,food_sources)
  
  # kita hitung trial counter
  trial_counter = ifelse(decision == F,trial_counter + 1,0)
  # trial_counter = ifelse(decision == F,1,0)
  print(trial_counter)
  
  # kita bikin plot
  Sys.sleep(.5)
  bikin_grafik(food_sources)
  
}


# jika trial counter melebihi nilai limit tertentu
for(iter in 1:(n_iterasi*2)){
  # ONLOOKER BEE PHASE
  # kita hitung nilai F-nya
  f_x = mcmapply(obj_func,food_sources,mc.cores = numcore)
  
  # kita hitung food quality-nya
  fit = mcmapply(food_qual,f_x,mc.cores = numcore)
  
  # kita hitung probability-nya
  fit_prob    = fit/sum(fit)
  random_prob = runif(n_scout)
  
  # kita hitung trial counter
  decision      = fit_prob < random_prob
  trial_counter = ifelse(decision == F,trial_counter + 1,0)
  print(trial_counter)
  
  # kita buat food sources new
  for(i in 1:n_scout){
    if(decision[i] == T){
      ganti = forager_bee(i)
      food_sources_new[[i]] = ganti
    }
    if(decision[i] == F){
      food_sources_new[[i]] = food_sources[[i]]
    }
    print(i)
  }
  
  # kita hitung nilai F-nya
  f_x_new = mcmapply(obj_func,food_sources_new,mc.cores = numcore)
  
  # kita hitung food quality-nya
  fit_new = mcmapply(food_qual,f_x_new,mc.cores = numcore)
  
  # sekarang kita bandingkan
  decision = fit_new < fit
  trial_counter = ifelse(decision == F,trial_counter + 1,0)
  print(trial_counter)
  
  
  # kita tuliskan yang final
  food_sources = ifelse(decision == T, food_sources_new,food_sources)
  
  # kita bikin plot
  Sys.sleep(.5)
  bikin_grafik(food_sources)
  print(paste0("Onlooker ke ",iter))
}


# kita mulai iterasinya dari sini
for(iter in 1:n_iterasi){
  # kita bikin plot
  Sys.sleep(.5)
  bikin_grafik(food_sources)
  # kita hitung nilai F-nya
  f_x = mcmapply(obj_func,food_sources,mc.cores = numcore)
  # kita hitung food quality-nya
  fit = mcmapply(food_qual,f_x,mc.cores = numcore)
  
  # kita mulai TAHAP II
  # mencari food sources baru
  food_sources_new = mclapply(1:n_scout,forager_bee,mc.cores = numcore)
  # kita hitung nilai F-nya
  f_x_new = mcmapply(obj_func,food_sources_new,mc.cores = numcore)
  # kita hitung food quality-nya
  fit_new = mcmapply(food_qual,f_x_new,mc.cores = numcore)
  
  # sekarang kita bandingkan
  decision = fit_new < fit
  
  # kita tuliskan food sources yang final
  food_sources = ifelse(decision == T, food_sources_new,food_sources)
  
  # kita hitung trial counter
  trial_counter = ifelse(decision == F,trial_counter + 1,0)
  # trial_counter = ifelse(decision == F,1,0)
  print(trial_counter)
  
  # kita bikin plot
  Sys.sleep(.5)
  bikin_grafik(food_sources)
  
}

# jika trial counter melebihi nilai limit tertentu
for(iter in 1:(n_iterasi*2)){
  # ONLOOKER BEE PHASE
  # kita hitung nilai F-nya
  f_x = mcmapply(obj_func,food_sources,mc.cores = numcore)
  
  # kita hitung food quality-nya
  fit = mcmapply(food_qual,f_x,mc.cores = numcore)
  
  # kita hitung probability-nya
  fit_prob    = fit/sum(fit)
  random_prob = runif(n_scout)
  
  # kita hitung trial counter
  decision      = fit_prob < random_prob
  trial_counter = ifelse(decision == F,trial_counter + 1,0)
  print(trial_counter)
  
  # kita buat food sources new
  for(i in 1:n_scout){
    if(decision[i] == T){
      ganti = forager_bee(i)
      food_sources_new[[i]] = ganti
    }
    if(decision[i] == F){
      food_sources_new[[i]] = food_sources[[i]]
    }
    print(i)
  }
  
  # kita hitung nilai F-nya
  f_x_new = mcmapply(obj_func,food_sources_new,mc.cores = numcore)
  
  # kita hitung food quality-nya
  fit_new = mcmapply(food_qual,f_x_new,mc.cores = numcore)
  
  # sekarang kita bandingkan
  decision = fit_new < fit
  trial_counter = ifelse(decision == F,trial_counter + 1,0)
  print(trial_counter)
  
  
  # kita tuliskan yang final
  food_sources = ifelse(decision == T, food_sources_new,food_sources)
  
  # kita bikin plot
  Sys.sleep(.5)
  bikin_grafik(food_sources)
  print(paste0("Onlooker ke ",iter))
}


# kita hitung nilai F-nya
f_x_new = mcmapply(obj_func,food_sources,mc.cores = numcore)

# kita hitung food quality-nya
fit_new = mcmapply(food_qual,f_x_new,mc.cores = numcore)
hasil = food_sources[[which.min(fit_new)]]
hasil

