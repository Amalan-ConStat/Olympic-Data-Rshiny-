
# load the data
load("Data/data.RData")

# starting the rshiny ui
fluidPage(
  
          # Application title
          titlePanel("OLYMPIC DATA FROM KAGGLE : AN RSHINY PERSPECTIVE"),
  
          # sidebar which incldues the image and title, information
          sidebarLayout(
                        sidebarPanel(
                                     h3("Olympic & Countries From 1896 Until 2016",align="center"),
                                     img(src='Logo.png', align= "center",height='75%',width='95%'),
                                     h4("How to Navigate the Olympic Rshiny App"),
                                     helpText("1. Choose your country which is represented by a three letter code"),
                                     selectInput('NOC',"Choose Your Country:",
                                                 choices = sort(unique(Olympic$NOC)),
                                                 selected = "SRI",selectize = TRUE),
                                     helpText(" For Example the code SRI is the representation to Sri Lanka"),
                                     helpText("2. If you do not know the Code use the *NOC CODE* tab."),
                                     helpText("3. Click on *GRAPH* tab to see how the medals were won 
                                                  for each year for the chosen country with respective to Gender."),
                                     checkboxInput("NoNA", label = "Remove NA", value = FALSE),
                                     helpText("Choose if you want to to remove the NA values from the plot in *GRAPH* tab."),
                                     helpText("4. Show the data of the chosen country using *DATA* tab."),
                                     helpText("5. Print a Summary Table of the chosen country using the *DESCRIBE* tab."),
                                     helpText("6. Use *G/Years* tab to understand how Gender representation has changed over
                                                  the years of participation for the chosen country."),
                                     helpText("7. Finally Use *S/Years* to understand how Gender representation has changed over
                                                  sports participated by the attendees for the chosen country."),
                                     helpText("* Do the above steps for different countries and observe them for your amusement.")
                                    ),
          # tabs for 4 types
          mainPanel(
                    tabsetPanel(type="tabs",
                                tabPanel("NOC CODE",DT::dataTableOutput("data")),
                                tabPanel("GRAPH",plotOutput("plot")),
                                tabPanel("DATA",DT::dataTableOutput("table")), 
                                tabPanel("DESCRIBE",htmlOutput("summary")),
                                tabPanel("G/Years",plotOutput("barplot")),
                                tabPanel("S/Years",plotOutput("SportsBarplot"))
                               ) 
                  )
                      ,fluid = FALSE)
          )