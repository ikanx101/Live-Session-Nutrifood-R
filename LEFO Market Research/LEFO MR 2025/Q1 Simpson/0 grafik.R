# pie chart dari data single answer
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
                   '\n',
                   tabulasi$percent,'%')
    caption_n = paste0('PERCENTAGE - n = ',n)
  } else{
    label_n=paste0(tabulasi$ket,'\n',
                   round(tabulasi$percent*n/100,0),
                   ' (',
                   tabulasi$percent,'%)')
    caption_n = paste0('REAL NUMBER - n = ',n,', indikasi')
  }
  
  ggplot(tabulasi,aes(x='',y=percent,fill=ket,label=label_n)) + 
    geom_bar(stat='identity', color = 'black',size = .5) + 
    coord_polar("y", start=0) +
    scale_fill_brewer(palette="Pastel1") + 
    theme_minimal() + 
    theme(panel.grid=element_blank(),axis.title.y=element_blank(),
          axis.title.x=element_blank(),legend.position = 'none',
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=10),
          plot.caption=element_text(size=8),
          axis.text.y = element_blank(),
          axis.text.x = element_blank()) +
    geom_label(position = position_stack(vjust = 0.5),size=2.5) +
    labs(caption = caption_n) +
    labs(title=pertanyaan,subtitle = sub.judul)
}  

# bar chart dari data single answer
# not sort
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
             fill='#fcd700',
             stat='identity',
             size=1) +
    theme_minimal() + 
    theme(panel.grid=element_blank(),axis.title.y=element_blank(),
          axis.title.x=element_blank(),legend.position = 'none',
          plot.title = element_text(size=10),
          plot.subtitle = element_text(size=8),
          plot.caption=element_text(size=7),
          axis.text.y = element_blank(),
          axis.text.x = element_text(size=7)) +
    geom_label(size=2) +
    labs(caption = caption_n) +
    labs(title=pertanyaan,subtitle = sub.judul)
}

# sort
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
             fill='#fcd700',
             stat='identity',
             size=1) +
    theme_minimal() + 
    theme(panel.grid=element_blank(),axis.title.y=element_blank(),
          axis.title.x=element_blank(),legend.position = 'none',
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=10),
          plot.caption=element_text(size=8),
          axis.text.y = element_blank(),
          axis.text.x = element_text(size=9)) +
    geom_label(size=2.5) +
    labs(caption = caption_n) +
    labs(title=pertanyaan,subtitle = sub.judul)
}

# sort
bikinin.bar.chart.sort.dari.data.saya.donk.puter=function(data,variabel,pertanyaan,sub.judul){
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
  
  ggplot(tabulasi,aes(reorder(ket,percent),percent,label=label_n)) +
    geom_bar(color='black',
             fill='#fcd700',
             stat='identity',
             size=.5) +
    theme_minimal() + 
    theme(panel.grid=element_blank(),axis.title.y=element_blank(),
          axis.title.x=element_blank(),legend.position = 'none',
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=10),
          plot.caption=element_text(size=8),
          axis.text.x = element_blank(),
          axis.text.y = element_text(size=9)) +
    geom_label(size=2.5) +
    labs(caption = caption_n) +
    labs(title=pertanyaan,subtitle = sub.judul) +
    coord_flip()
}


# bikin data dari tabulasi
# biasanya digunakan saat tabulasinya itu mengandung multiple answer
bikinin.bar.chart.sort.dari.data.tabulasi.saya.donk.puter=function(tabulasi,
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
  
  
  ggplot(tabulasi,aes(reorder(ket,percent),percent,label=label_n)) +
    geom_bar(color='black',
             fill='#fcd700',
             stat='identity',
             size=.5) +
    theme_minimal() + 
    coord_flip() +
    theme(panel.grid=element_blank(),axis.title.y=element_blank(),
          axis.title.x=element_blank(),legend.position = 'none',
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=10),
          plot.caption=element_text(size=8),
          axis.text.x = element_blank(),
          axis.text.y = element_text(size=9)) +
    geom_label(size=2.5) +
    labs(caption = caption_n) +
    labs(title=pertanyaan,subtitle = sub.judul) 
}


# secara default
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
             fill='#fcd700',
             stat='identity',
             size=.5) +
    theme_minimal() + 
    theme(panel.grid=element_blank(),axis.title.y=element_blank(),
          axis.title.x=element_blank(),legend.position = 'none',
          plot.title = element_text(size=12),
          plot.subtitle = element_text(size=10),
          plot.caption=element_text(size=8),
          axis.text.y = element_blank(),
          axis.text.x = element_text(size=9)) +
    geom_label(size=2.5) +
    labs(caption = caption_n) +
    labs(title=pertanyaan,subtitle = sub.judul) 
}



# ini fungsi baru agar bisa gabungin 2 tabulasi tabyl
bikin.bar.chart.gabung.tabyl = function(tabel_1,tabel_2,pertanyaan_input,
                                        subjudul_input,caption_input){
  colnames(tabel_1)[1] = "ket"
  colnames(tabel_2)[1] = "ket"
  blank_df = data.frame(ket = "",n = NA,percent = NA)
  
  gab = 
    data.table::rbindlist(list(tabel_2,blank_df,tabel_1)) %>% 
    as.data.frame() 
  
  val = gab$ket
  
  gab = 
    gab %>% 
    mutate(ket = factor(ket,levels = val))
  
  gab
  
  gab%>% 
    ggplot(aes(x = ket,
               y = n)) +
    geom_col(color='black',fill='#fcd700') +
    geom_label(aes(label = percent),size = 2) +
    coord_flip() +
    theme_minimal() + 
    theme(panel.grid=element_blank(),axis.title.y=element_blank(),
          axis.title.x=element_blank(),legend.position = 'none',
          plot.title = element_text(size=10),
          plot.subtitle = element_text(size=8),
          plot.caption=element_text(size=7),
          axis.text.x = element_blank(),
          axis.text.y = element_text(size=7)) +
    labs(caption = caption_input) +
    labs(title = pertanyaan_input,
         subtitle = subjudul_input)
}
