library(dplyr)
library(tidyr)
library(ggplot2)
library(ggpubr)
library(expss)



# ==============================================================================
bikinin.pie.chart.dari.data.saya.donk = function(data,variabel,pertanyaan,sub.judul){
  tabulasi = data %>% tab_cells(variabel) %>% tab_stat_cpct() %>% tab_pivot()
  tabulasi$dummy = strsplit(tabulasi$row_labels,'\\|')
  for(i in 1:length(tabulasi$dummy))
  {tabulasi$row_labels[i]=unlist(tabulasi$dummy[i])[2]}
  tabulasi=data.frame(tabulasi)
  tabulasi=tabulasi[-3]
  colnames(tabulasi)=c('ket','percent')
  tabulasi$percent=round(tabulasi$percent,2)
  n = as.numeric(tabulasi %>% filter(grepl('total',ket,ignore.case=T)) %>% 
                   summarise(n=sum(percent))) #ambil base buat kepentingan chart
  tabulasi = tabulasi %>% 
    filter(!grepl('total',ket,ignore.case=T)) #tabulasi final untuk chart
  tabulasi = tabulasi %>% filter(!is.na(ket))
  
  if(n>30){
    label_n=paste0(tabulasi$ket,
                   ', ',
                   tabulasi$percent,'%')
    caption_n = paste0('PERCENTAGE - n = ',n)
  } else{
    label_n=paste0(tabulasi$ket,', ',
                   round(tabulasi$percent*n/100,0),
                   ' (',
                   tabulasi$percent,'%)')
    caption_n = paste0('REAL NUMBER - n = ',n,', indikasi')
  }
  
  ggplot(tabulasi,aes(x='',y=percent,fill=ket,label=label_n)) + 
    geom_bar(stat='identity', color = 'black') + 
    coord_polar("y", start=0) +
    scale_fill_brewer(palette="Pastel1") + 
    theme_minimal() + 
    theme(panel.grid=element_blank(),axis.title.y=element_blank(),
          axis.title.x=element_blank(),legend.position = 'none',
          plot.title = element_text(size=17),
          plot.subtitle = element_text(size=13),
          plot.caption=element_text(size=12),
          axis.text.y = element_blank(),
          axis.text.x = element_blank()) +
    geom_label(position = position_stack(vjust = 0.5),size=3.5) +
    labs(caption = caption_n) +
    labs(title=pertanyaan,subtitle = sub.judul)
}  




# ==============================================================================
bikinin.bar.chart.not.sort.dari.data.saya.donk=function(data,variabel,pertanyaan,sub.judul){
  tabulasi=data %>% tab_cells(variabel) %>% tab_stat_cpct() %>% tab_pivot()
  tabulasi$dummy=strsplit(tabulasi$row_labels,'\\|')
  for(i in 1:length(tabulasi$dummy))
  {tabulasi$row_labels[i]=unlist(tabulasi$dummy[i])[2]}
  tabulasi=data.frame(tabulasi)
  tabulasi=tabulasi[-3]
  colnames(tabulasi)=c('ket','percent')
  tabulasi$percent=round(tabulasi$percent,2)
  n = as.numeric(tabulasi %>% filter(grepl('total',ket,ignore.case=T)) %>% 
                   summarize(n=sum(percent))) #ambil base buat kepentingan chart
  tabulasi = tabulasi %>% 
    filter(!grepl('total',ket,ignore.case=T)) #tabulasi final untuk chart
  tabulasi = tabulasi %>% filter(!is.na(ket))
  tabulasi = tabulasi %>% filter(!is.na(percent))
  tabulasi$ket=factor(tabulasi$ket,levels = (tabulasi$ket))
  
  if(n>30){
    label_n=paste0(tabulasi$percent,'%')
    caption_n = paste0('PERCENTAGE - n = ',n)
  } else{
    label_n=paste0(round(tabulasi$percent*n/100,0))
    caption_n = paste0('REAL NUMBER - n = ',n,', indikasi')
  }
  
  ggplot(tabulasi,aes(ket,percent,label=label_n)) +
    geom_bar(color='black',
             fill='blue',
             stat='identity',
             alpha=.25,
             size=1) +
    theme_minimal() + 
    theme(panel.grid=element_blank(),axis.title.y=element_blank(),
          axis.title.x=element_blank(),legend.position = 'none',
          plot.title = element_text(size=17),
          plot.subtitle = element_text(size=13),
          plot.caption=element_text(size=12),
          axis.text.y = element_blank(),
          axis.text.x = element_text(size=12)) +
    geom_label(size=3) +
    labs(caption = caption_n) +
    labs(title=pertanyaan,subtitle = sub.judul)
}




# ==============================================================================
bikinin.bar.chart.sort.dari.data.saya.donk=function(data,variabel,pertanyaan,sub.judul){
  tabulasi=data %>% tab_cells(variabel) %>% tab_stat_cpct() %>% tab_pivot()
  tabulasi$dummy=strsplit(tabulasi$row_labels,'\\|')
  for(i in 1:length(tabulasi$dummy))
  {tabulasi$row_labels[i]=unlist(tabulasi$dummy[i])[2]}
  tabulasi=data.frame(tabulasi)
  tabulasi=tabulasi[-3]
  colnames(tabulasi)=c('ket','percent')
  tabulasi$percent=round(tabulasi$percent,2)
  n = as.numeric(tabulasi %>% filter(grepl('total',ket,ignore.case=T)) %>% summarize(n=sum(percent))) #ambil base buat kepentingan chart
  tabulasi = tabulasi %>% filter(!grepl('total',ket,ignore.case=T)) #tabulasi final untuk chart
  tabulasi = tabulasi %>% filter(!is.na(ket))
  tabulasi = tabulasi %>% filter(!is.na(percent))
  
  if(n>30){
    label_n=paste0(tabulasi$percent,'%')
    caption_n = paste0('PERCENTAGE - n = ',n)
  } else{
    label_n=paste0(round(tabulasi$percent*n/100,0))
    caption_n = paste0('REAL NUMBER - n = ',n,', indikasi')
  }
  
  ggplot(tabulasi,aes(reorder(ket,-percent),percent,label=label_n)) +
    geom_bar(color='black',
             fill='blue',
             stat='identity',
             alpha=.25,
             size=1) +
    theme_minimal() + 
    theme(panel.grid=element_blank(),axis.title.y=element_blank(),
          axis.title.x=element_blank(),legend.position = 'none',
          plot.title = element_text(size=17),
          plot.subtitle = element_text(size=13),
          plot.caption=element_text(size=12),
          axis.text.y = element_blank(),
          axis.text.x = element_text(size=12)) +
    geom_label(size=3) +
    labs(caption = caption_n) +
    labs(title=pertanyaan,subtitle = sub.judul)
}






# ==============================================================================
bikinin.bar.chart.sort.dari.data.tabulasi.saya.donk=function(tabulasi,
                                                             pertanyaan,
                                                             sub.judul){
  colnames(tabulasi)=c('ket','percent')
  tabulasi$percent=round(tabulasi$percent,2)
  n = as.numeric(tabulasi %>% 
                   filter(grepl('total',ket,ignore.case=T)) %>% 
                   summarize(n=sum(percent))) #ambil base buat kepentingan chart
  tabulasi = tabulasi %>% 
    filter(!grepl('total',ket,ignore.case=T)) #tabulasi final untuk chart
  tabulasi = tabulasi %>% filter(!is.na(ket))
  tabulasi = tabulasi %>% filter(!is.na(percent))
  
  if(n>30){
    label_n=paste0(tabulasi$percent,'%')
    caption_n = paste0('PERCENTAGE - n = ',n)
  } else{
    label_n=paste0(round(tabulasi$percent*n/100,0))
    caption_n = paste0('REAL NUMBER - n = ',n,', indikasi')
  }
  
  
  ggplot(tabulasi,aes(reorder(ket,-percent),percent,label=label_n)) +
    geom_bar(color='black',
             fill='blue',
             stat='identity',
             alpha=.25,
             size=1) +
    theme_minimal() + 
    theme(panel.grid=element_blank(),axis.title.y=element_blank(),
          axis.title.x=element_blank(),legend.position = 'none',
          plot.title = element_text(size=17),
          plot.subtitle = element_text(size=13),
          plot.caption=element_text(size=12),
          axis.text.y = element_blank(),
          axis.text.x = element_text(size=12)) +
    geom_label(size=3) +
    labs(caption = caption_n) +
    labs(title=pertanyaan,subtitle = sub.judul) 
}

