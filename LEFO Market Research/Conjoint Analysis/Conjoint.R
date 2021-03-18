setwd("~/Documents/Live-Session-Nutrifood-R/LEFO Market Research/Conjoint Analysis")
rm(list=ls())

library(dplyr)
library(conjoint)

warna = c("kuning", "hijau", "merah")
rasa = c("soto", "kari ayam", "goreng jawa")
klaim = c("less salt", "no msg", "less fat")

experiment = expand.grid(warna,rasa,klaim)
experiment

factdesign = caFactorialDesign(data=experiment,type="orthogonal")
factdesign 

prof = caEncodedDesign(design=factdesign)
colnames(prof) = c("Warna","Rasa","Klaim_unggulan")

# buat ngeliat orthogonal atau gak
print(round(cov(prof),1))
print(round(cor(prof),1))

case_level = c(warna,rasa,klaim)
case_level

# buat responden palsu
jawab = function(){
  sample(6,8,replace = T)
}

for(i in 1:10){
  nam = paste0("resp",i)
  tes = jawab()
  assign(nam,tes)
}

responses = data.frame(resp1,resp2,resp3,resp4,resp5,resp6,resp7,resp8,resp9,resp10)
responses_print = data.frame(factdesign,responses)

save(experiment,factdesign,prof,case_level,responses,responses_print,file = "bahan lefo.rda")

Conjoint(y=responses, x=prof, z=case_level)