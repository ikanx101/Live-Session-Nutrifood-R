#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
rm(list=ls())
# ==============================================================================
# part 1
# load libraries
library(shiny)
library(shinymanager)
library(shinydashboard)

# part 2
source("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/Dashboard Shiny/dasbor/graph.R")

# ambil data
df = read.csv("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/Dashboard Shiny/generating data/data.survey.csv")

# kita rapihin dulu gaes
# data untuk visualisasi dashboard
df_ready = 
  df %>% 
  # tambahin id dari 1 sampai baris terakhir
  mutate(id = 1:nrow(df)) %>% 
  # saya bikin isinya masing-masing kolom ini
  # bukan ya tidak tapi ...
  mutate(user_ts = ifelse(user_ts == "ya","User TS",NA),
         user_ns = ifelse(user_ns == "ya","User NS",NA)
  )

# part 3
# bikin selector atau filter apa aja yang akan ada di dashboard
usia_sel = df_ready$usia %>% unique() %>% sort()
usia_sel = c(usia_sel[2:5],usia_sel[1])
gend_sel = df_ready$gender %>% unique() %>% sort()
area_sel = df_ready$area %>% unique() %>% sort()
ses_sel  = df_ready$ses %>% unique() %>% sort()
tom_sel  = df_ready$tom %>% unique() %>% sort()
user_sel = c("User TS","User NS")

# part 4
# kita bikin data utk filter
# kita mengandalkan si reshape2
df_filter = 
  df_ready %>% 
  reshape2::melt(id.vars = c("id","gender","nama","usia","area","ses","tom"))


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Dashboard LEFO"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          # filter usia
          checkboxGroupInput('filter_usia', 
                             h4(strong('Filter USIA')), 
                             choices  = usia_sel, 
                             selected = usia_sel),
          # filter area
          checkboxGroupInput('filter_area', 
                             h4(strong('Filter AREA')), 
                             choices  = area_sel, 
                             selected = area_sel),
          # filter ses
          checkboxGroupInput('filter_ses', 
                             h4(strong('Filter SES')), 
                             choices  = ses_sel, 
                             selected = ses_sel),
          # filter tom tv
          checkboxGroupInput('filter_tom', 
                             h4(strong('Filter TOM TV Stasiun')), 
                             choices  = tom_sel, 
                             selected = tom_sel),
          # filter user
          selectInput('filter_user', 
                      h4(strong('Pilih Tipe User')), 
                      choices = user_sel, 
                      multiple = T)
        ),

        # Show a plot of the generated distribution
        mainPanel(
          fluidRow(
            box(
              # total responden berapa?
              infoBoxOutput(outputId = "totalresponden", width = 5)
            )
          ),
          br(),
          fluidRow(
            box(
              plotOutput("plt_1")
            ),
            box(
              plotOutput("plt_2")
            )
          )
          
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  # pastikan kita bikin data filter di sini
  id_filtered = reactive({
    # jangan lupa pakai reactive
    
    # filter yang gampang dulu
    temp = 
      df_filter %>% 
      filter(usia   %in% input$filter_usia &
               area %in% input$filter_area &
               ses  %in% input$filter_ses &
               tom  %in% input$filter_tom
      )
    
    # khusus filter user ini harus diperhatikan jangan sampai salah
    # sekarang kita akan ambil dari user
    
    # jika filter usernya terisi
    if(!is.null(input$filter_user)){
      id_sel = 
        temp %>% 
        filter(value %in% input$filter_user) %>% 
        pull(id) %>% 
        unique()
    }
    # jika filter usernya tidak terisi
    if(is.null(input$filter_user)){
      id_sel = temp %>% pull(id) %>% unique()
    }
    
    # kita kembalikan id nya utk dipakai
    return(id_sel)
  })
  
  # data final utk visualisasi
  df_new = reactive({
    df_ready %>% 
      filter(id %in% id_filtered())
  })
  
  # bikin infobox untuk jumlah responden
  output$totalresponden = renderInfoBox({
    n = nrow(df_new())
    infoBox(
      "Jumlah Responden", as.character(n), icon = icon("users"),
      color = "purple")
  })
  
  # kita bikin plot pertama
  output$plt_1 = renderPlot({
    bikinin.pie.chart.dari.data.saya.donk(df_new(),
                                          df_new()$ses,
                                          "SES Responden",
                                          "base: data hasil survey")
  })
  
  # bikin plot kedua
  output$plt_2 = renderPlot({
    bikinin.bar.chart.sort.dari.data.saya.donk(df_new(),
                                               df_new()$area,
                                               "Area Asal Responden",
                                               "base: data hasil survey") +
      scale_x_discrete(guide = guide_axis(n.dodge = 3))
  })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
