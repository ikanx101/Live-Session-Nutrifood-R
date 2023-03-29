# ============================================================================
# kita mulai dari nol yah
rm(list=ls())

setwd("/home/ikanx101/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/Unsupervised/bikin data training")

# libraries
library(dplyr)
library(tidyr)
library(ggplot2)
# ============================================================================


# ============================================================================
# data pertama
# kita akan buat data berbentuk donat
x = runif(1000,min = -1,max = 1)
y = runif(1000,min = -1,max = 1)

# bentuk lingkaran
lingkaran = function(x,y){
  marker = x^2 + y^2
  marker <= .3
}

# kita bikin dot pertama
df_1 = 
  data.frame(x,y) %>%
  mutate(masuk = lingkaran(x,y)) %>%
  filter(masuk == T) %>%
  mutate(cluster = 1)

# data kedua
# kita akan buat donatnya
x = runif(8000,min = -2,max = 2)
y = runif(8000,min = -2,max = 2)

# bentuk lingkaran
lingkaran = function(x,y){
  marker = x^2 + y^2
  marker <= 2 & marker >= 1
}

# kita bikin dot kedua
df_2 = 
  data.frame(x,y) %>%
  mutate(masuk = lingkaran(x,y)) %>%
  filter(masuk == T) %>%
  mutate(cluster = 2) 

# data ketiga
# kita akan buat donatnya
x = runif(40000,min = -5,max = 5)
y = runif(40000,min = -5,max = 5)

# bentuk lingkaran
lingkaran = function(x,y){
  marker = x^2 + y^2
  marker <= 5 & marker >= 3
}

# kita bikin dot kedua
df_3 = 
  data.frame(x,y) %>%
  mutate(masuk = lingkaran(x,y)) %>%
  filter(masuk == T) %>%
  mutate(cluster = 3) 

 df = rbind(df_1,df_2)
 df = rbind(df,df_3)
 
 df %>%
  ggplot(aes(x,y)) +
  geom_point() +
  xlim(-3,3) +
  ylim(-3,3)

write.csv(df,"donat.csv")
# ============================================================================


# ============================================================================
# data kedua
# yakni adalah data contoh untuk k-means
rm(list=ls())

x = runif(1000,min = -2,max = 2)
y = runif(1000,min = -2,max = 2)

lingkaran = function(x,y){
  marker = x^2 + y^2
  marker <= 2
}

df_1 = data.frame(x,y) %>% 
       rowwise() %>%
       mutate(marker = lingkaran(x,y)) %>%
       ungroup() %>%
       filter(marker == T) %>%
       select(-marker)
df_2 = data.frame(x = (df_1$x + 10),
                  y = (df_1$y))
df_3 = data.frame(x = (df_1$x + 10),
                  y = (df_1$y + 10))
df_4 = data.frame(x = (df_1$x),
                  y = (df_1$y + 10))

df = rbind(df_1,df_2)
df = rbind(df,df_3)
df = rbind(df,df_4)

df %>%
  ggplot(aes(x,y)) +
  geom_point()

write.csv(df,"compact disks.csv")
# ============================================================================


# ============================================================================
# data kedua
# yakni adalah data contoh untuk macem-macem
rm(list=ls())

x = runif(20000,min = -3,max = 3)
y = runif(20000,min = -3,max = 3)

seleksi_1 = function(x,y){
    m1 = ((x >= -3 & x <= -2) | 
          (x >= 0 & x <= 1) |
          (x >= 2 & x < 3))
    m2 = (y >= -2 & y < 2)
    return(m1 & m2)
}

seleksi_2 = function(x,y){
    m1 = ((x >= -3 & x <= 1))
    m2 = (y >= -0.5 & y < 0.5)
    return(m1 & m2)
}

df_1 = 
  data.frame(x,y) %>%
  mutate(marker = seleksi_1(x,y)) %>%
  filter(marker == T)

df_2 = 
  data.frame(x,y) %>%
  mutate(marker = seleksi_2(x,y)) %>%
  filter(marker == T)

df_3 = rbind(df_1,df_2) 

df_3 %>%
  ggplot(aes(x,y)) +
  geom_point() +
  xlim(-3,3) +
  ylim(-3,3)

write.csv(df_3,"hi.csv")
# ============================================================================


# ============================================================================
# data keempat
# kita akan buat data berbentuk donat
rm(list=ls())
x = runif(1000,min = -1,max = 1)
y = runif(1000,min = -1,max = 1)

# bentuk lingkaran
lingkaran = function(x,y){
  marker = x^2 + y^2
  marker <= .3
}

# kita bikin dot pertama
df_1 = 
  data.frame(x,y) %>%
  mutate(masuk = lingkaran(x,y)) %>%
  filter(masuk == T) %>%
  mutate(cluster = 1)

# data kedua
# kita akan buat donatnya
x = runif(8000,min = -2,max = 2)
y = runif(8000,min = -2,max = 2)

# bentuk lingkaran
lingkaran = function(x,y){
  marker = x^2 + y^2
  marker <= 2 & marker >= 1
}

# kita bikin dot kedua
df_2 = 
  data.frame(x,y) %>%
  mutate(masuk = lingkaran(x,y)) %>%
  filter(masuk == T) %>%
  mutate(cluster = 2) 

# data ketiga
# kita akan buat donatnya
x = runif(40000,min = -5,max = 5)
y = runif(40000,min = -5,max = 5)

# bentuk lingkaran
lingkaran = function(x,y){
  marker = x^2 + y^2
  marker <= 5 & marker >= 3
}

# kita bikin dot kedua
df_3 = 
  data.frame(x,y) %>%
  mutate(masuk = lingkaran(x,y)) %>%
  filter(masuk == T) %>%
  mutate(cluster = 3) 

# kita bikin dot sebelah kiri
x = runif(150,min = -2,max = 0)
y = runif(150,min = -2.236,
              max = 2.236)
df_4 = data.frame(x,y) %>%
       mutate(cluster = 4)

 df = rbind(df_1,df_2)
 df = rbind(df,df_3) %>% 
      select(-masuk) %>% filter(x > 0)
 df = rbind(df,df_4)

 df %>%
  ggplot(aes(x,y)) +
  geom_point() +
  xlim(-3,3) +
  ylim(-3,3)

write.csv(df,"donat density.csv")
# ============================================================================


# ============================================================================
# data kelima
# yakni adalah data contoh untuk k-means
rm(list=ls())

x = runif(9000,min = -2,max = 2)
y = runif(9000,min = -2,max = 2)

lingkaran_1 = function(x,y){
  marker = x^2 + y^2
  marker <= 1
}

df_1 = data.frame(x,y) %>% 
       rowwise() %>%
       mutate(marker = lingkaran_1(x,y)) %>%
       ungroup() %>%
       filter(marker == T) %>%
       select(-marker)

x = runif(2400,min = -2,max = 2)
y = runif(2400,min = -2,max = 2)

lingkaran_2 = function(x,y){
  marker = x^2 + y^2
  marker <= 3
}

df_2 = data.frame(x,y) %>% 
       rowwise() %>%
       mutate(marker = lingkaran_2(x,y)) %>%
       ungroup() %>%
       filter(marker == T) %>%
       select(-marker) %>%
       mutate(x = x + 3)

df = rbind(df_1,df_2)

df %>%
  ggplot(aes(x,y)) +
  geom_point() +
  xlim(-1,5) +
  ylim(-2,2)

write.csv(df,"dual disks.csv")
# ============================================================================