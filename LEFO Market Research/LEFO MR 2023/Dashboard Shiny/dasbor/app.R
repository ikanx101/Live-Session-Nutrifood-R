#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

rm(list=ls())
setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/Dashboard Shiny/dasbor")

# libraries
library(shiny)
library(shinymanager)
library(shinydashboard)
source("graph.R")

# import df
df = read.csv("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/Dashboard Shiny/generating data/data.survey.csv")

# kita rapihin dulu gaes
df_ready = 
  df %>% 
  mutate(id = 1:nrow(df)) %>% 
  mutate(user_ts = ifelse(user_ts == "ya","User TS",NA),
         user_ns = ifelse(user_ns == "ya","User NS",NA)
  )

# kita akan ambil selectornya
usia_sel = df_ready$usia %>% unique() %>% sort()
area_sel = df_ready$area %>% unique() %>% sort()
ses_sel  = df_ready$ses %>% unique() %>% sort()
tom_sel  = df_ready$tom %>% unique() %>% sort()
user_sel = c("User TS","User NS")


df_filter = 
  df_ready %>% 
  reshape2::melt(id.vars = c("id","nama","usia","area","ses","tom"))

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Dashboard Media Habit"),

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
          # filter ses
          selectInput('filter_user', 
                      h4(strong('Pilih Tipe User')), 
                      choices = user_sel, 
                      multiple = T)
        ),

        # Show a plot of the generated distribution
        mainPanel(
          fluidRow(
            box(
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

  # kita ambil id yang dari filtered 
  id_filtered = reactive({
    # kita filter terlebih dahulu untuk usia, area, ses, dan tom
    temp = 
      df_filter %>% 
      filter(usia   %in% input$filter_usia &
               area %in% input$filter_area &
               ses  %in% input$filter_ses &
               tom  %in% input$filter_tom
               )
    
    # sekarang kita akan ambil dari user
    if(!is.null(input$filter_user)){
      id_sel = 
        temp %>% 
        filter(value %in% input$filter_user) %>% 
        pull(id) %>% 
        unique()
    }
    if(is.null(input$filter_user)){
      id_sel = temp %>% pull(id) %>% unique()
    }
    # kita kembalikan id nya
    return(id_sel)
  })
  
  # sebagai bentuk reaktif
  df_new = reactive({
    df_ready %>% 
      filter(id %in% id_filtered())
  })
  
  # infobox dan filtered data
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
