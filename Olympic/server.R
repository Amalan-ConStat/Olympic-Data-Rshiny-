# load the packages
library(shiny)
library(magrittr)
library(DT)
library(summarytools)
library(tidyverse)
library(htmlTable)
library(htmlwidgets)

css <- "
.shiny-output-error { visibility: hidden; }
.shiny-output-error:before {
  visibility: visible;
  content: 'The Country you have chosen has not won any medals.'; }
}
"

# load the data
load("Data/data.RData")

function(input, output,session){
    # NOC and codes for data
    output$data<-DT::renderDataTable({
                                      datatable(NOC,options = list(pageLength = 30))
                                    })
  
    # creating the plots
    output$plot <- renderPlot({
    
                              Medal_color<-c("#CD7F32","#FFD700","#C0C0C0")
                              names(Medal_color)<-levels(factor(Olympic$Medal))
                              McolScale<-scale_color_manual(name="Medal",values=Medal_color,na.value="red")
                              
                              if(input$NoNA == FALSE)
                              {
                              subset(Olympic,NOC==input$NOC) %>%
                              ggplot(.,aes(x=Season,y=Sex,color=factor(Medal)))+
                              geom_jitter()+facet_wrap(~factor(Year),ncol = 4)+
                              xlab("Years of Participation")+
                              ylab("Gender")+ McolScale+
                              ggtitle("MEDALS WON OVER THE YEARS ACCORDING TO GENDER")
                              }
                              else
                              {
                              p<-subset(Olympic[!is.na(Olympic$Medal),],NOC==input$NOC) %>%
                                 ggplot(.,aes(x=Season,y=Sex,color=factor(Medal)))+
                                 geom_jitter()+facet_wrap(~factor(Year),ncol=4)+
                                 xlab("Years of Participation")+
                                 ylab("Gender")+McolScale+
                                 ggtitle("MEDALS WON OVER THE YEARS ACCORDING TO GENDER")
                              
                              print(p)
                              }
                               },height = 1400,width = 1200)  
                              
  # creating the table
  output$table<-DT::renderDataTable({
                                   datatable(subset(Olympic,NOC==input$NOC, 
                                                    select = -c(Height,Weight,Team,NOC,Games,City,Sport)),
                                             options = list(pageLength= 30))
                                   })
  # creating the summary for selected variables
  output$summary<-renderUI({
                            print(dfSummary(subset(Olympic,NOC==input$NOC, 
                                                   select =c(Sex,Age,Height,Weight,Year,Season,Sport,Medal))
                                            ),method = 'render',headings = FALSE, bootstracp.css = FALSE)
                          })

  # Gender Count over the year
  output$barplot <- renderPlot({
                              Gender_color<-c("#DEA1C0","#6BA5DE")
                              names(Gender_color)<-levels(factor(Olympic$Sex))
                              GcolScale<-scale_color_manual(name="Gender",values=Gender_color)
                              
                              subset(Olympic,NOC==input$NOC,select = c(Sex,Year,Season)) %>%
                              ggplot(.,aes(x=factor(Year),fill=factor(Sex),group=factor(Sex)))+
                              geom_bar(position = "dodge")+
                              xlab("Years")+ylab("Frequency")+coord_flip()+ GcolScale+
                              labs(fill="Gender")+
                              ggtitle("GENDER RELATED PARTICIPATION OVER THE YEARS")+
                              geom_text(stat='count',aes(y=..count..,label=..count..),
                                        position=position_dodge(width = 1),hjust=1.25,
                                        color="#696969",size=4)
                              },height = 1400,width = 1200)
  # Gender Count for Sports
  output$SportsBarplot<-renderPlot({
                                    Gender_color<-c("#DEA1C0","#6BA5DE")
                                    names(Gender_color)<-levels(factor(Olympic$Sex))
                                    GcolScale<-scale_color_manual(name="Gender",values=Gender_color)
                                    
                                    subset(Olympic,NOC==input$NOC,select = c(Sex,Sport,Season)) %>%
                                    ggplot(.,aes(x=fct_infreq(factor(Sport)),fill=factor(Sex),
                                                 group=factor(Sex)))+
                                    geom_bar(position = "dodge")+
                                    xlab("Sport")+ylab("Frequency")+coord_flip()+
                                    labs(fill="Gender")+GcolScale+
                                    ggtitle("GENDER REPRESENTATION IN SPORTS OF PARTICIPANTS")+
                                    geom_text(stat='count',aes(y=..count..,label=..count..),
                                              position=position_dodge(width = 1),hjust=1.25,
                                              color="#696969",size=3)
     
                                  },height = 1400,width = 1200)
  # Scatter plot for height, Sports and Years with gender
  output$HWSplot<-renderPlot({
                               Gender_color<-c("#DEA1C0","#6BA5DE")
                               names(Gender_color)<-levels(factor(Olympic$Sex))
                               GcolScale<-scale_color_manual(name="Gender",values=Gender_color)
                               
                               subset(Olympic,NOC==input$NOC,select = c(Height,Weight,Sport,Sex)) %>%
                               ggplot(.,aes(x=Weight,y=Height,color=factor(Sex)))+geom_point()+
                               ggtitle("HEIGHT AND WEIGHT OF PARTICIPANTS BASED ON SPORTS")+
                               labs(color="Gender")+xlab("Weight (kg)")+ylab("Height (cm)")+
                               facet_wrap(~Sport,ncol = 4)+GcolScale
                             },height = 1400,width = 1200)
  session$onSessionEnded(stopApp)
                        }