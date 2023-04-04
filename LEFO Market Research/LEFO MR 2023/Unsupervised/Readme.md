Beberapa Contoh Metode Clustering dengan R
================

# *Introduction*

Berikut adalah beberapa *showcase* contoh penerapan metode *clustering*
dengan **R**.

# *K-Means Clustering*

## Contoh Kasus I

``` r
# import data
df = read.csv("/cloud/project/LEFO Market Research/LEFO MR 2023/Unsupervised/k means/compact disks.csv") %>% 
     janitor::clean_names() %>%
     select(-x) %>%
     rename(x = x_2)

# kita bikin visualisasinya terlebih dahulu
plt = 
  df %>%
  ggplot(aes(x,y)) +
  geom_point()
plt
```

<img src="Readme_files/figure-gfm/unnamed-chunk-2-1.png" width="672" style="display: block; margin: auto;" />

Jika melihat langsung data di atas, kita sudah bisa pastikan bahwa ada
![k = 4](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;k%20%3D%204 "k = 4")
buah *cluster*.

> Namun bagaimana jika kita gunakan *elbow method* dan *silhouette
> method* untuk menentukan berapa banyaknya
> ![k](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;k "k")?

### *Elbow Method*

``` r
elbow = fviz_nbclust(df, kmeans, method = "wss")
plot(elbow)
```

![](Readme_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

### *Silhouette Method*

``` r
siluet = fviz_nbclust(df, kmeans, method = "silhouette")
plot(siluet)
```

![](Readme_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

### Kesimpulan Sementara

Penentuan
![k](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;k "k")
menggunakan *elbow* dan *silhouette method* bisa berpotensi *miss
leading*.

#### Jika ![k=5](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;k%3D5 "k=5")

``` r
# k-means clustering
final = kmeans(df, 5, nstart = 25)

# center dari masing-masing cluster
final$centers
```

    ##             x           y
    ## 1 10.50025161 -0.39974068
    ## 2 10.04097999  9.98130971
    ## 3  0.04097999 -0.01869029
    ## 4  9.53552463  0.40067802
    ## 5  0.04097999  9.98130971

``` r
# save hasil cluster ke data awal
data_kmeans = df
data_kmeans$cluster = final$cluster

# berapa banyak isi dari cluster
table(data_kmeans$cluster)
```

    ## 
    ##   1   2   3   4   5 
    ## 197 376 376 179 376

``` r
plt = 
  data_kmeans %>%
  ggplot(aes(x,y)) +
  geom_point(aes(color = as.factor(cluster)))
plt
```

![](Readme_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

#### Jika ![k=6](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;k%3D6 "k=6")

``` r
# k-means clustering
final = kmeans(df, 6, nstart = 25)

# center dari masing-masing cluster
final$centers
```

    ##             x           y
    ## 1  0.04097999  9.98130971
    ## 2  9.53552463 10.40067802
    ## 3  9.53552463  0.40067802
    ## 4 10.50025161  9.60025932
    ## 5  0.04097999 -0.01869029
    ## 6 10.50025161 -0.39974068

``` r
# save hasil cluster ke data awal
data_kmeans = df
data_kmeans$cluster = final$cluster

# berapa banyak isi dari cluster
table(data_kmeans$cluster)
```

    ## 
    ##   1   2   3   4   5   6 
    ## 376 179 179 197 376 197

``` r
plt = 
  data_kmeans %>%
  ggplot(aes(x,y)) +
  geom_point(aes(color = as.factor(cluster)))
plt
```

![](Readme_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->
