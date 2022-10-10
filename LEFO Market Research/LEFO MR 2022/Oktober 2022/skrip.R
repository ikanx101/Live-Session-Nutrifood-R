rm(list=ls())
setwd("/mnt/chromeos/removable/Workstation/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2022/Oktober 2022/")

# skrip untuk learning forum

library(dplyr)
library(ggplot2)

# auto replenishment
# langkah kerja
    # fase 1: 
        # analisa demand utk finished goods.
        # analisa pembelian bahan baku.
        # mulai membuat model inventori dengan catatan:
            # inventory cost berisi:
                # ordering cost (termasuk transportation cost and communication cost). 
                # carrying cost; dihitung dengan dari deteriorating value dari bahan baku jika disimpan di gudang sebagai inventori. sbg contoh, berat bawang merah akan susut sebesar 15% - 20% di suhu ruang dalam seminggu.
                # shortage cost; dihitung dari potensi loss of income saat stok finished good habis.
    # economic order quantity pada periode tertentu didefinisikan sebagai:
        # eoq = sqrt(2 * D * C0) / Ch
        # D = demand 
        # C0 = ordering cost
        # Ch = carrying cost
    # reorder point dihitung dari:
        # rop = dL + ss
        # dL = average demand during lead time
        # ss = safety stock; dihitung dengan mengasumsikan service level terpenuhi. service level adalah persentase di mana demand terpenuhi.
            # rumus ss adalah:
            # ss = normsinv(CSL) * sigmaL
                # CSL = cycle service level
                # sigmaL = standar deviasi demand pada lead time
    # fase 2:
        # membuat simulasi dari model di atas untuk berbagai nilai.

# parameter yang dibutuhkan
service_level = 95/100
leadtime_min = 1
leadtime_max = 2
carrying_cost_per_unit = 3780
ordering_cost = 550000
stock_out_cost = 400

# misalkan demand
D = runif(20,0:1) * 10 
D = round(D,0)

# hitung ROP
# ss = normsinv(CSL) * sigmaL
sigmaL = sd(D)
nomrs_inv = qnorm(service_level)
ss = nomrs_inv + sigmaL
# rop = dL + ss
dL = mean(D)
rop = dL + ss

# kita akan hitung EOQ
Ch = carrying_cost_per_unit
C0 = ordering_cost
Dx = sum(D)
eoq = sqrt(2 * Dx * C0 / Ch)
eoq = round(eoq,0)

# summary
rop
eoq
ss

eoq = 30

# kita mulai simulasinya
days = 1:20
begin_stok = c(0)
order_recv = c(0)
avail_stock = c(0)
demand = D
# bikin rumah utk variabel dependen
full_filled = rep(NA,20)
ending_stock = rep(NA,20)
stock_outage = rep(NA,20)
place_order = rep(NA,20)
lead_time = rep(NA,20)
order_arrive_at = rep(NA,20)

# untuk hari 1
i = 1

# perhitungan demand berapa yang bisa dipenuhi
full_filled[i] = ifelse(avail_stock[i] < demand[i],
                        0,
                        demand[i])
# perhitungan ending stok
ending_stock[i] = avail_stock[i] - full_filled[i]                     
# outage atau tidak
stock_outage[i] = demand[i] - full_filled[i]
# perlu pesan lagi atau tidak?
place_order[i] = ifelse(ending_stock[i] <= ss,
                        1,
                        0)
# lead time pengiriman
lead_time[i] = sample(leadtime_min:leadtime_max,1)
# order akan datang kapan
order_arrive_at[i] = ifelse(place_order[i] == 1,
                            i + lead_time[i],
                            0)

# kita mulai looping hari kedua
for(i in 2:20){
    # stok hari i adalah stok hari i-1
    begin_stok[i] = ending_stock[i-1]
    # jika order arrive, maka order sama dengan eoq
    if(i == order_arrive_at[i-1]){order_recv[i] = eoq}
    if(i != order_arrive_at[i-1]){order_recv[i] = 0}
    
    # hitung saldo sekarang
    avail_stock[i] = begin_stok[i] + order_recv[i]
    
    # perhitungan demand berapa yang bisa dipenuhi
    full_filled[i] = ifelse(avail_stock[i] < demand[i],
                            0,
                            demand[i])
    # perhitungan ending stok
    ending_stock[i] = avail_stock[i] - full_filled[i]                     
    # outage atau tidak
    stock_outage[i] = demand[i] - full_filled[i]
    # perlu pesan lagi atau tidak?
    place_order[i] = ifelse(ending_stock[i] <= ss,
                            1,
                            0)
    # lead time pengiriman
    lead_time[i] = sample(leadtime_min:leadtime_max,1)
    # order akan datang kapan
    order_arrive_at[i] = ifelse(place_order[i] == 1 & order_arrive_at[i-1] == 0,
                                i + lead_time[i],
                                0)
                                
}

df = data.frame(
    begin_stok,order_recv,avail_stock,
    demand,full_filled,ending_stock,
    stock_outage,place_order,
    lead_time,order_arrive_at)

View(df)
