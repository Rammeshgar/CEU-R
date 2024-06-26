library(shiny)
library(jsonlite)
library(data.table)
library(httr)
library(rtsdata)
library(DT)
library(TTR)
library(plotly)
library(shinythemes)
library(shinydashboard)
library(ggplot2)

source('functions.R')

#https://shiny.rstudio.com/articles/layout-guide.html


# base --------------------------------------------------------------------


# ui <- fluidPage(
#   uiOutput('my_ticker'),
#   dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date()),
#   dataTableOutput('my_data'),
#   dataTableOutput('all_tr'),
#   div(plotlyOutput('data_plot', width = '60%', height='800px'),align="center")
# 
# )



# sidebar -----------------------------------------------------------------

# 
# ui <- fluidPage(
# 
#   sidebarLayout(
#     sidebarPanel(
#       uiOutput('my_ticker'),
#       dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date())
# 
#     ),
#     mainPanel(
#       plotlyOutput('data_plot', width = '60%', height='800px'),
#       dataTableOutput('my_data')
#     )
#   )
# )


# ui <- fluidPage(
#   
#   sidebarLayout(
#     sidebarPanel(
      # uiOutput('my_ticker'),
      # dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date())
#       
#     ),
#     mainPanel(
#       tabsetPanel(
#         tabPanel("plot",plotlyOutput('data_plot', width = '60%', height='800px')),
#         tabPanel("data",dataTableOutput('my_data'))
#         
#       )
#     )
#   )
# )

# ui <- fluidPage(
#   
#     tabsetPanel(
#       tabPanel("control",uiOutput('my_ticker'),
#                dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date())),
#       tabPanel("plot",plotlyOutput('data_plot', width = '60%', height='800px')),
#       tabPanel("data",dataTableOutput('my_data'))
#       )
# )
  
# ui <- navbarPage("Stocks",theme = shinytheme("flatly"),
#   
    # tabPanel("control",uiOutput('my_ticker'),
    #          dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date())),
    # tabPanel("plot",plotlyOutput('data_plot', width = '100%', height='800px')),
#     tabPanel("data",dataTableOutput('my_data'))
#   
# )

ui <- dashboardPage(
  dashboardHeader(title = "Stocks browser"),
  dashboardSidebar(uiOutput('my_ticker'),dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date())),
  dashboardBody((plotlyOutput('data_plot', width = '100%', height='800px')))
)


# sidebarwithtabset -------------------------------------------------------

# ui <- fluidPage(
# 
#   sidebarLayout(
#     sidebarPanel(
#       uiOutput('my_ticker'),
#       dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date())
# 
#     ),
#     mainPanel(
#       tabsetPanel(
#         tabPanel("Plot", plotlyOutput('data_plot', width = '60%', height='800px')),
#         tabPanel("Table",  dataTableOutput('my_data'))
#       )
#     )
#   )
# )



# just tabsetpanel ---------------------------------------------------------

# ui <- fluidPage(
# 
#   tabsetPanel(
# 
#     tabPanel("control",
#              wellPanel(
#                uiOutput('my_ticker'),
#                dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date())
#                )
#              ),
#     tabPanel("Plot", plotlyOutput('data_plot', width = '60%', height='800px')),
#     tabPanel("Table",  dataTableOutput('my_data'))
#   )
# )




# ui <- navbarPage(title = 'Stock browser',theme = shinytheme('united'),
#                  tabPanel('control',
#                           uiOutput('my_ticker'),
#                           dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date())
#                           ),
#                  tabPanel('Plot',
#                           plotlyOutput('data_plot', width = '60%', height='800px')
#                           ),
#                  tabPanel('Data',
#                           dataTableOutput('my_data')
#                           )
#                  )




# ui <- navbarPage(title = 'Stock browser',theme = shinytheme('flatly'),
#                  tabPanel('control',
#                           uiOutput('my_ticker'),
#                           dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date())
#                  ),
#                  tabPanel('Plot & data',
#                           fluidRow(
#                             column(9,
#                                    plotlyOutput('data_plot')
#                                    ),
#                             column(3,
#                                    dataTableOutput('my_data')
#                                    )
#                           )
#                  )# ends tabpanel
# )# end navbarpage

# 
# ui <-dashboardPage(
#   dashboardHeader(title = 'Stock browser'),
#   dashboardSidebar(
#     uiOutput('my_ticker'),
#     dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date())
# 
#   ),
#   dashboardBody(
#     fluidRow(
#       column(width = 6, valueBoxOutput('marketcap')),
#       column(width = 6, infoBoxOutput('positive_info'))),
#     fluidRow(
#     box(
#       title = "Price", status = "primary", solidHeader = TRUE,
#       collapsible = TRUE,
#       plotlyOutput('data_plot')
#     )
#     ),
#     # infoBoxOutput('plus_infobox'),
#     dataTableOutput('my_data')
#   )
# )
#



# 
# ui <-dashboardPage(
#   dashboardHeader(title = 'Stock browser'),
#   dashboardSidebar(
#     uiOutput('my_ticker'),
#     dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date()),
#     
#     sidebarMenu(
#     menuItem("Plot", tabName = "plot", icon = icon("dashboard")),
#     menuItem("Data", tabName = "data", icon = icon("th"))
#     )
# 
# 
#   ),
#   dashboardBody(
#     tabItems(
#       tabItem(tabName = "plot",
#              
#               plotlyOutput('data_plot')
#       ),
# 
#       tabItem(tabName = "data",
#               dataTableOutput('my_data')
#       )
#     )
# 
# 
#   )
# )

# value sum of the marketcap in T 
# infobox % of positive in change
# and also put a plot into box

server <- function(input, output, session) {
  sp500 <-data.table(get_sp500())
  
  setorder(sp500, -market_cap_basic)
  sum(sp500$market_cap_basic)/1000000000
  sum(sp500$change>0)/nrow(sp500) 
  

  output$my_ticker <- renderUI({
    selectInput('ticker', label = 'Select a ticker', choices = setNames(sp500$name, sp500$description), multiple = FALSE)
  })
  
  
  my_reactive_df <- reactive({
    df<- get_data_by_ticker_and_date(input$ticker, input$my_date[1], input$my_date[2])
    return(df)
  })
  
  
  # go to https://rstudio.github.io/DT/shiny.html
  output$my_data <- DT::renderDataTable({
  my_reactive_df()
    #render_df_with_buttons(my_reactive_df())
  })

  
  # output$my_data <- DT::renderDT(server = F,{
  #   render_df_with_all_download_buttons(my_reactive_df())
  # })
 
  output$data_plot <- renderPlotly({
    get_plot_of_data(my_reactive_df())
  })
  
  
  
  
  # output$plus_infobox <- renderInfoBox({
  #   infoBox(title = 'Positive performace', value = sum(sp500$change>0) / nrow(sp500),
  #       icon = icon("thumbs-up", lib = "glyphicon"),
  #     color = "yellow"
  #   )
  # })
  
  # output$marketcap <- renderValueBox({
  #   valueBox(
  #     paste0('$', round(sum(as.numeric(sp500$market_cap_basic))/1000000000, 2), ' T'), "Market capitalization", icon = icon("money-bill"),
  #     color = "blue"
  #   )
  # })
  # 
  # output$positive_info <- renderInfoBox({
  #   infoBox(
  #     "Positive change", paste( round(sum(sp500$change>0)/nrow(sp500) ,2) , "%"), icon = icon("thumbs-up", lib = "glyphicon"),
  #     color = "yellow", fill = TRUE
  #   )
  # })
  
  
  

}


shinyApp(ui = ui, server = server)



