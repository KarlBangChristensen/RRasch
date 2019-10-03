## Purpose of script: (server.R) Shiny app (server-side) for AGD 
##
## Author: Anne Lyngholm Soerensen
##
## Date Created: 2019-06-18
##
## Copyright (c) Anne Lyngholm Soerensen, 2019
## Email: lynganne@gmail.com

source("~/functions.R")

server <- function(input, output, session){
  
  # reacrive data
  addData <- reactiveValues()
  addData$dataset0 <- NULL
  
  # Observe button
  observeEvent(input$addData,{
    newAge <- input$newAge
    newResp <- input$newResp
    newID <- input$newId
    
    newRow <- data.frame(id = newID, age = newAge, resp = newResp)
    addData$dataset0 <- rbind(addData$dataset0, newRow)
  })
  
      # visualize raw data
      output$ageAGDplot <- renderPlot({
        
        #plot(x=c(1:3), y = c(2:4))
        plot(c(1:100),rnorm(100,0,1), ylim = c(-6, 6),
             xlab = "age", ylab = "LH FSH ratio", main= "LH FSH ratio Male\n-2SD, -1SD, mean, +1SD, +2SD",
             pch = 16, col = "gray90")
        if(!is.null(addData$dataset0)){
          points(addData$dataset0$age, addData$dataset0$resp, col = "red", pch = 16,
                 cex = 2)
        }})
      
          # data upload visualization help text
          output$dataLoadText <- renderText({
            "Use the visulization of your data to ensure that your data is read correctly. <br>
          The data should be divided into columns. If not try to select another separator radiobottom under 'Choose separator' ."
          })

          # upload data and visualize uploaded data code
          output$contents <- renderTable({

            # input$file1 will be NULL initially. After the user selects
            # and uploads a file, head of that data file by default,
            # or all rows if selected, will be shown.

            req(input$file1) # if no input$file1 then no plot

            # read data
            tryCatch(
              {
                z_data <<- read.csv(input$file1$datapath,
                                      header = TRUE,
                                      sep = input$sep
                                      )
              },
              error = function(e) {
                # return a safeError if a parsing error occurs
                stop(safeError(e))
              }
            )

            return(head(z_data))
          })
          
          # the z-score plot
          observeEvent(input$plotBut,{
            output$zScoreplot <- renderPlot({
              req(input$file1)              
              plot(c(0:44), rnorm(44),
                   xlab = "age", ylab = "LH FSH ratio", main= "LH FSH ratio Male\n-2SD, -1SD, mean, +1SD, +2SD")
            })
          })
          
}


# server <- function(input, output, session){
# ### the server function contains all output created for the app
# 
#     output$zscoreIntro <- renderText({
#       "Start with adding your own data to the app. The data should contain an age and agd variabel. You will be able to calculate z-scores based on an existing model for your supplied data."
#     })
#     
#     # data upload help text
#     output$dataLoad <- renderText({
#       "Please insert data in either .txt or .csv file format.<br>Notice that the upload may give you an error, 
#     if the the separator is incorrect.
#     Try either looking at your data in e.g. Notepad or an equivalent software before uploading the data
#     and choose the correct separator for your data."
#     })
#     
#     # data upload visualization help text
#     output$dataLoadText <- renderText({
#       "Use the visulization of your data to ensure that your data is read correctly. <br>
#     The data should be divided into columns. If not try to select another separator radiobottom under 'Choose separator' ."
#     })
#     
#     # upload data and visualize uploaded data code
#     output$contents <- renderTable({
#       
#       # input$file1 will be NULL initially. After the user selects
#       # and uploads a file, head of that data file by default,
#       # or all rows if selected, will be shown.
#       
#       req(input$file1) # if no input$file1 then no plot
#       
#       # read data
#       tryCatch(
#         {
#           irt_data <<- read.csv(input$file1$datapath,
#                                 header = input$header,
#                                 na.strings = input$na,
#                                 sep = input$sep
#                                 )
#         },
#         error = function(e) {
#           # return a safeError if a parsing error occurs
#           stop(safeError(e))
#         }
#       )
#       
#       return(head(irt_data))
#     })
#     
#     # set v to a reactive variable - it stores whether or not to show or hide some arguments
#     v <- reactiveValues(doPlot = FALSE) 
#     
#     # visualize raw data
#     observeEvent(input$rawPlot, {
#       v$doPlot <- FALSE
#     output$ageAGDplot <- renderPlot({
#       plot(agddata$V1,agddata$V2, type = "l", ylim = c(0, max(agddata$V6)),
#            xlab = "Age", ylab = "model?", main= "FritT female\n-2SD, -1SD, mean, +1SD, +2SD")
#       lines(agddata$V1,agddata$V3)
#       lines(agddata$V1,agddata$V4)
#       lines(agddata$V1,agddata$V5)
#       lines(agddata$V1,agddata$V6)
#       })
#     })
#     
#     # select variables from irt_data to use in plot
#     observeEvent(input$modPlot,
#                  {if(exists("irt_data")){
#                    output$class <- renderText({"Please supply the needed information below:"})
#                    output$arguments1 <- renderUI({if(v$doPlot == FALSE) return()
#                        isolate({selectInput("varInterest1", "AGD variabel:", colnames(irt_data),
#                                             selected = NULL, multiple = FALSE,
#                                             selectize = TRUE, width = 200, size = NULL)})})
#                    output$arguments2 <- renderUI({if(v$doPlot == FALSE) return()
#                        isolate({selectInput("varInterest2", "Age variabel:", colnames(irt_data),
#                                             selected = NULL, multiple = FALSE,
#                                             selectize = TRUE, width = 200, size = NULL)})})
#                      output$result <- renderPrint({if(v$doPlot == FALSE) return()})
#                      session$sendCustomMessage(type = "scrollCallback", 1)}})
#     
#     
#     # set doPlot to TRUE when modPlot is pressed
#     observeEvent(input$modPlot, {
#       v$doPlot <- input$modPlot})
#     
#     observe({
#       if(v$doPlot == FALSE){ # | input$modPlot == FALSE
#         shinyjs::hide("startPlot")}
#       
#       if(v$doPlot & exists("irt_data")){
#         isolate({shinyjs::show("startPlot")})
#       }
#     })
#     
#     testReact1 <- reactive({ # set testReact1 to a reactive value (y var - plot)
#       input$varInterest1
#     })
#     
#     testReact2 <- reactive({ # set testReact2 to a reactive value (x var - plot)
#       input$varInterest2
#     })
#     
#     # when columns (x and y var) have been select, plot 
#     observeEvent(input$startPlot,
#                  {
#                    if(exists("irt_data")){
#                    myval1 <- testReact1()
#                    myval2 <- testReact2()
#                    vec1 <- eval(parse(text=paste("irt_data$",myval1,sep="")))
#                    vec2 <- eval(parse(text=paste("irt_data$",myval2,sep="")))
#                    
#                    output$ageAGDplot <- renderPlot({
#                      plot(agddata$V1,agddata$V2, type = "l", ylim = c(0, max(c(agddata$V6,vec1))),
#                           xlab = "Age", ylab = "model?", main= "FritT female\n-2SD, -1SD, mean, +1SD, +2SD")
#                      lines(agddata$V1,agddata$V3)
#                      lines(agddata$V1,agddata$V4)
#                      lines(agddata$V1,agddata$V5)
#                      lines(agddata$V1,agddata$V6)
#                      points(vec2, vec1, col = "red") })
#                    } else {
#                      output$ageAGDplot <- renderPlot({
#                        return()
#                      })
#                    }
#                  })
#     
#     output$introPlotRaw <- renderText({
#       paste(
#         "You can decide between looking at the raw plot (without uploaded data) and a modified plot (with uploaded data).",
#         "The raw plot is shown by pressing: 'Show raw plot'. If you decide to look at the modified, press 'Add new data to plot'.",
#         "You will then need to specify which variables to use.", collapse="\n")
#     })
#     
# }

