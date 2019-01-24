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
                              McolScale<-scale_color_manual(name="Medal",values=Medal_color,na.value="red")
                              
                              if(input$NoNA == FALSE)
                              {
                              subset(Olympic,NOC==input$NOC) %>%
                              ggplot(.,aes(x=Season,y=Sex,color=factor(Medal)))+
                              geom_jitter()+facet_wrap(~factor(Year))+
                              xlab("Years of Participation")+
                              ylab("Gender")+ McolScale
                              }
                              else
                              {
                              subset(Olympic[!is.na(Olympic$Medal),],NOC==input$NOC) %>%
                              ggplot(.,aes(x=Season,y=Sex,color=factor(Medal)))+
                              geom_jitter()+facet_wrap(~factor(Year))+
                              xlab("Years of Participation")+
                              ylab("Gender")+
                              McolScale
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
  # Gender Count over the year
  output$barplot <- renderPlot({
                              Gender_color<-c("#DEA1C0","#6BA5DE")
                              names(Gender_color)<-levels(factor(Sex))
                              GcolScale<-scale_color_manual(name="Sex",values=Gender_color)
                              
                              subset(Olympic,NOC==input$NOC,select = c(Sex,Year,Season)) %>%
                              ggplot(.,aes(x=factor(Year),fill=factor(Sex),group=factor(Sex)))+
                              geom_bar(position = "dodge")+
                              xlab("Years")+ylab("Frequency")+coord_flip()+ GcolScale+
                              labs(fill="Gender")+
                              geom_text(stat='count',aes(y=..count..,label=..count..),
                                        position=position_dodge(width = 1),hjust=1,
                                        color="#696969",size=4)
                              },height = 1200,width = 1200)
  # Gender Count for Events
  output$SportsBarplot<-renderPlot({
                                    Gender_color<-c("#DEA1C0","#6BA5DE")
                                    names(Gender_color)<-levels(factor(Sex))
                                    GcolScale<-scale_color_manual(name="Sex",values=Gender_color)
                                    
                                    subset(Olympic,NOC==input$NOC,select = c(Sex,Sport,Season)) %>%
                                    ggplot(.,aes(x=fct_infreq(factor(Sport)),fill=factor(Sex),
                                                 group=factor(Sex)))+
                                    geom_bar(position = "dodge")+
                                    xlab("Sport")+ylab("Frequency")+coord_flip()+
                                    labs(fill="Gender")+GcolScale+
                                    geom_text(stat='count',aes(y=..count..,label=..count..),
                                              position=position_dodge(width = 1),hjust=1,
                                              color="#696969",size=3)
     
                                  },height = 1200,width = 1200)
  
                        }