
# load the data
load("Data/data.RData")

# starting the rshiny ui
fluidPage(
  
          # Application title
          titlePanel("OLYMPIC DATA FROM KAGGLE : AN RSHINY PERSPECTIVE"),
  
          # sidebar which incldues the image and title, information
          sidebarLayout(
                        sidebarPanel(
                                     h3("Olympic & Countries From Beginning Until 2016",align="center"),
                                     img(src='Logo.png', align= "center",height='75%',width='95%'),
                                     selectInput('NOC',"Choose Your Country:",
                                                 choices = sort(unique(Olympic$NOC)),
                                                 selected = "SRI",selectize = TRUE),
                                     checkboxInput("NoNA", label = "Remove NA", value = FALSE),
                                     helpText("* Choose your country which is represented by a three letter code"),
                                     helpText("* For Example the code SRI is the representation to Sri Lanka")
                                    ),
          # tabs for 4 types
          mainPanel(
                    tabsetPanel(type="tabs",
                                tabPanel("NOC CODE",DT::dataTableOutput("data")),
                                tabPanel("GRAPH",plotOutput("plot")),
                                tabPanel("DATA",DT::dataTableOutput("table")), 
                                tabPanel("DESCRIBE",htmlOutput("summary"))
                               ) 
                  )
                      ,fluid = FALSE)
          )