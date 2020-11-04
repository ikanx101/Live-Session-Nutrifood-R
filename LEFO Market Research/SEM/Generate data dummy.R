# =======================
# Generate data untuk keperluan training
# =======================

rm(list=ls())

data = data.frame(
  id_resp = c(1:200),
  a1 = sample(1:5,200,replace = T,prob = c(1/5,3/5,1/5,2/5,2/5)),
  a2 = sample(1:5,200,replace = T,prob = c(1/5,3/5,1/5,2/5,4/5)),
  a3 = sample(1:5,200,replace = T,prob = c(1/5,3/5,1/5,2/5,3/5)),
  a4 = sample(1:5,200,replace = T,prob = c(1/5,3/5,1/5,2/5,2/5)),
  a5 = sample(1:5,200,replace = T,prob = c(1/5,4/5,1/5,2/5,2/5)),
  a6 = sample(1:5,200,replace = T,prob = c(1/5,3/5,2/5,2/5,2/5)),
  a7 = sample(1:5,200,replace = T,prob = c(1/5,3/5,1/5,4/5,2/5)),
  a8 = sample(1:5,200,replace = T,prob = c(1/5,3/5,3/5,2/5,2/5)),
  a10 = sample(1:5,200,replace = T,prob = c(1/5,1/5,1/5,2/5,4/5))
)

write.csv(data,"dataset training.csv")
