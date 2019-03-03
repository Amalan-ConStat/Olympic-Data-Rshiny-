library(shinythemes)
library(shinybusy)

# load the data
load("Data/data.RData")

# starting the rshiny ui
fluidPage(theme = shinytheme("flatly"),
          
          add_busy_spinner(spin = "fading-circle"),
          # Application title
          titlePanel("OLYMPIC DATA FROM KAGGLE : AN RSHINY PERSPECTIVE",windowTitle = "Olympic : Rshiny"),
          
          # sidebar which incldues the image and title, information
          sidebarLayout(
                        sidebarPanel(
                                     h3("Olympic & Countries From 1896 Until 2016",align="center"),
                                     br(),
                                     img(src='Logo.png', align= "center",height='75%',width='95%'),
                                     br(),
                                     h4("How to Navigate the Olympic Rshiny App",align="center"),
                                     br(),
                                     h5("1. Choose your country which is represented by a three letter code"),
                                     selectInput('NOC',"Choose Your Country:",
                                                 choices = sort(unique(Olympic$NOC)),
                                                 selected = "SRI",selectize = TRUE,width='200px'),
                                     helpText(" For Example the code SRI is the representation to Sri Lanka"),
                                     br(),
                                     h5("2. If you do not know the Code use the *NOC CODE* tab."),
                                     br(),
                                     h5("3. Click on *MEDAL GRAPH* tab to see how the medals were won 
                                                  for each year for the chosen country with respective to Gender."),
                                     checkboxInput("NoNA", label = "Remove NA", value = FALSE),
                                     helpText("Choose if you want to to remove the NA values from the plot in *MEDAL GRAPH* tab."),
                                     br(),
                                     h5("4. Show the data of the chosen country using *DATA* tab."),
                                     br(),
                                     h5("5. Print a Summary Table of the chosen country using the *DESCRIBE* tab."),
                                     br(),
                                     h5("6. Use *G/Years* tab to understand how Gender representation has changed over
                                                  the years of participation for the chosen country."),
                                     br(),
                                     h5("7. Use *S/Years* to understand how Gender representation has changed over
                                                  sports participated by the attendees for the chosen country."),
                                     br(),
                                     h5("8. Finally, Use the *H/W/Sport* tab to explore how participants
                                                 Height and Weight relationship for each Sporting event with respective
                                                 to gender for the chosen country."),
                                     br(),
                                     helpText("*Do the above steps for different countries and observe them for your amusement.*"),
                                     br(),
                                     h4("Thank You",align="center")
                                    ),
          # tabs for 4 types
          mainPanel(
            tags$style(type="text/css", css),
            tags$head(tags$style(".shiny-output-error{color: blue;}")),
                    tabsetPanel(type="tabs",
                                tabPanel("NOC CODE",DT::dataTableOutput("data")),
                                tabPanel("MEDAL GRAPH",plotOutput("plot")),
                                tabPanel("DATA",DT::dataTableOutput("table")), 
                                tabPanel("DESCRIBE",htmlOutput("summary")),
                                tabPanel("G/Years",plotOutput("barplot")),
                                tabPanel("S/Years",plotOutput("SportsBarplot")),
                                tabPanel("H/W/Sport",plotOutput("HWSplot"))
                               ) 
                  )
                      ,fluid = FALSE)
          )