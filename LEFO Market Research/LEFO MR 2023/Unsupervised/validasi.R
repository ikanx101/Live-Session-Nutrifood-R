rm(list=ls())

df = mtcars %>% select(mpg,disp)
row.names(df) = NULL

df %>% 
  ggplot(aes(mpg,disp)) + geom_point()

df
elbow = fviz_nbclust(df, kmeans, method = "wss")
plot(elbow)

# k-means clustering
final = kmeans(df, 2, nstart = 25)

# center dari masing-masing cluster
final$centers

# save hasil cluster ke data awal
data_kmeans = df
data_kmeans$cluster = final$cluster

data_kmeans %>% 
  ggplot(aes(mpg,disp)) + geom_point(aes(color = as.factor(cluster)))


data_validasi = 
  data_kmeans %>% 
  arrange(cluster) %>% 
  select(-cluster)

matriks = dist(data_validasi,diag = T,upper = T)

df <- melt(as.matrix(matriks), varnames = c("row", "col"))
df %>% ggplot(aes(x = row,y = col)) + geom_tile(aes(fill = value)) 
