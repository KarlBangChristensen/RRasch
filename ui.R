## Purpose of script: (ui.R) Shiny app User Interface (UI) for AGD
##
## Author: Anne Lyngholm Soerensen
##
## Date Created: 2019-06-18
##
## Copyright (c) Anne Lyngholm Soerensen, 2019
## Email: lynganne@gmail.com

# libraries
library(shiny)
library(shinydashboard)
library(shinyjs)

ui <- fluidPage(
  titlePanel("Prototype of LH/FSH app"),
  mainPanel(
    plotOutput("ageAGDplot", height = "600px"),
    fluidRow(
      box(width = 12,
          splitLayout(
            numericInput("newResp", "New LH/FSH value", 0, min = 0, max = 100),
            numericInput("newAge", "New age value", 0, min = 0, max = 100),
            numericInput("newId", "New id value", 0, min = 0, max = 10000000000),
            actionButton("addData", "Add new data to plot")
          ))
    ),
                                   fluidRow(
                                     column(width=5,
                                            box(id = "zscore", width = NULL,
                                                # The upload data box
                                                h4("Upload data"),
                                                hr(),
                                                htmlOutput("dataLoad"),
                                                br(),
                                                fileInput("file1", "Choose a .csv or .txt file:",
                                                          multiple = FALSE,
                                                          accept = c("text/csv",
                                                                     "text/comma-separated-values,text/plain",
                                                                     ".csv", ".txt")),
                                                radioButtons(inputId = 'sep', label = 'Choose separator:',
                                                             choices = c(Comma=',' ,Semicolon=';'
                                                                         ,Tab='\t', Space=''
                                                             ), selected = ',')
                                                )),
                                     # The data visualization box
                                     column(width=7,
                                            box(id="showUploadData",
                                                width=NULL, #height = 425,
                                                h4("Visualization of a subset of data (upload)"),
                                                tags$hr(),
                                                htmlOutput("dataLoadText"),
                                                br(),
                                                div(style = 'overflow-x: scroll', tableOutput('contents'))))
                          ),
    #downloadButton("downloadData", "Download"),
    actionButton("plotBut", "Plot data and z-score"),
    plotOutput("zScoreplot"),
    tags$style(type='text/css', "#addData { width:100%; margin-top: 25px;}")
  )
)

# ui <- fluidPage(
#     titlePanel("Prototype of AGD app"), #titel på siden
#     
#     mainPanel(
#           tabsetPanel(type = "tabs",
#                       tabPanel("Purpose",
#                                # The purpose (introduction)
#                                fluidRow(
#                                  column(width=12, 
#                                         box(id = "Purpose", width = NULL,
#                                             h4("This app serves the purpose of ..")
#                                         ))
#                                )),
#                       tabPanel("Z-scores on existing model",
#                                # The zscore-box
#                                h3("Calculate, visualize and download z-scores"),
#                                textOutput("zscoreIntro"),
#                                fluidRow(
#                                  column(width=5, 
#                                         box(id = "zscore", width = NULL,
#                                             # The upload data box
#                                             h4("Upload data"),
#                                             hr(),
#                                             htmlOutput("dataLoad"),
#                                             br(),
#                                             fileInput("file1", "Choose a .csv or .txt file:",
#                                                       multiple = FALSE,
#                                                       accept = c("text/csv",
#                                                                  "text/comma-separated-values,text/plain",
#                                                                  ".csv", ".txt")),
#                                             radioButtons(inputId = 'sep', label = 'Choose separator:', 
#                                                          choices = c(Comma=',' ,Semicolon=';'
#                                                                      ,Tab='\t', Space=''
#                                                          ), selected = ','),
#                                             # selectInput("sep", "Choose separator:", c(comma=",", semicolon=";",
#                                             #                                           tab = "\t",
#                                             #                                           whitespace ='',
#                                             #                                           joker = " "),
#                                             #             selected = "", multiple = FALSE,
#                                             #             selectize = TRUE, width = 200, size = NULL),
#                                             checkboxInput("header",
#                                                           "Does the data have named columns (header)?",
#                                                           TRUE),
#                                             selectInput("na", "Missing value symbol", c(comma=",", dot="."),
#                                                         selected = NULL, multiple = FALSE,
#                                                         selectize = TRUE, width = 200, size = NULL)
#                                             )),
#                                  # The data visualization box
#                                  column(width=7, 
#                                         box(id="showUploadData",
#                                             width=NULL, #height = 425,
#                                             h4("Visualization of a subset of data (upload)"),
#                                             tags$hr(),
#                                             htmlOutput("dataLoadText"),
#                                             br(),
#                                             div(style = 'overflow-x: scroll', tableOutput('contents'))))
#                       ),
#                       hr(),
#                       fluidRow(
#                         column(width = 12,
#                                box(id = "visZscore", width = NULL,
#                                    h4("Visualize the data, calculate the z-scores and download"),
#                                    tabsetPanel(type = "tabs",
#                                                tabPanel("Age, AGD plot",
#                                                         useShinyjs(),
#                                                         br(),
#                                                         textOutput("introPlotRaw"),
#                                                         br(),
#                                                         actionButton("rawPlot", "Show raw plot"),
#                                                         actionButton("modPlot", "Add new data to plot"),
#                                                         br(),
#                                                         fluidRow(width=12,
#                                                                  column(width=2,
#                                                                         uiOutput("arguments1")),
#                                                                  column(width=2,
#                                                                         uiOutput("arguments2")),
#                                                                  column(width=2,
#                                                                         br(),
#                                                                         actionButton("startPlot",
#                                                                                      "Add selected variables to plot"))),
#                                                         plotOutput("ageAGDplot")),
#                                                tabPanel("Age, Z-score plot",
#                                                         plotOutput("zscorePlot")))
#                       )
#                       ))),
#                       tabPanel("Z-scores on new model",
#                                # The new data model box
#                                fluidRow(
#                                  column(width=12, 
#                                         box(id = "newmodel", width = NULL,
#                                             h3("Choose scales, scale items, correlation and restscore")
#                                         ))
#                                ))
#           )
#         )
#       )


