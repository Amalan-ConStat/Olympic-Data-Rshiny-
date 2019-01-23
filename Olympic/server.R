# load the packages
library(shiny)
library(magrittr)
library(readr)
library(DT)
library(summarytools)
library(shiny)
library(tidyverse)
library(htmlTable)
library(readr)
library(htmlwidgets)

# load the data
load("Data/data.RData")
attach(Olympic)

function(input, output){
    # creating the plots
    output$plot <- renderPlot({
    
                              Medal_color<-c("#CD7F32","#FFD700","#C0C0C0")
                              names(Medal_color)<-levels(factor(Medal))
                              colScale<-scale_color_manual(name="Medal",values=Medal_color,na.value="red")
                              
                              if(input$NoNA == FALSE)
                              {
                              subset(Olympic,NOC==input$NOC) %>%
                              ggplot(.,aes(x=Season,y=Sex,color=factor(Medal)))+
                              geom_jitter()+facet_wrap(~factor(Year))+
                              xlab("Years of Participation")+
                              ylab("Medals")+ colScale
                              }
                              else
                              {
                              subset(Olympic[!is.na(Olympic$Medal),],NOC==input$NOC) %>%
                              ggplot(.,aes(x=Season,y=Sex,color=factor(Medal)))+
                              geom_jitter()+facet_wrap(~factor(Year))+
                              xlab("Years of Participation")+
                              ylab("Medals")+
                              colScale
                              }
                               },height = 1000,width = 1200)  
                              
  # creating the table
  output$table<-DT::renderDataTable({
                                datatable(subset(Olympic,NOC==input$NOC, 
                                                 select = -c(Height,Weight,Team,NOC,Games)),
                                          options = list(pageLength= 25))
                               })
  # creating the summary for selected variables
  output$summary<-renderUI({
                            print(dfSummary(subset(Olympic,NOC==input$NOC, 
                                                   select =c(Sex,Age,Year,Season,Sport,Medal))
                                            ),method = 'render',headings = FALSE, bootstracp.css = FALSE)
                          })
  # NOC and codes for data
  output$data<-DT::renderDataTable({
                                datatable(NOC,options = list(pageLength = 25))
                              })
                        }