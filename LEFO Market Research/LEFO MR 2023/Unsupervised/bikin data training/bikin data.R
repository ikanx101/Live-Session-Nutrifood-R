# ============================================================================
# kita mulai dari nol yah
rm(list=ls())

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

save("compact disks.csv")
# ============================================================================