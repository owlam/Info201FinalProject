my.ui <- fluidPage(
  theme= shinytheme('darkly'),
  titlePanel(h2("Crime Data in the United States and Washington")),
  sidebarLayout(
    sidebarPanel(
      radioButtons("type", "Type of Crime", c("Murder", "Rape", "Robbery", "Aggravated_Assault", 
                                              "Burglary", "Larceny","Motor_Vehicle"), selected = selected.type),
      sliderInput("range", "Range of Years", 1994, 2013,value = c(1994, 2013), sep = "")
    ),
    mainPanel(
      tabsetPanel(
        type = "tabs",
        tabPanel("Washington",
                 tabsetPanel(
                   tabPanel("Graph",
                            plotlyOutput("graph"),
                            textOutput("wash.graph.info")),
                          
                   tabPanel("Map",
                            textOutput("map.info"),
                            plotOutput("map", hover= 'plot.hover'),
                            p("Selected County: ",strong(textOutput('selected', inline = TRUE)))),
                   tabPanel("Socioeconomic Correlations",
                            textOutput("soc.intro"),
                            span(textOutput("break.1", style="color:red")),
                            plotlyOutput("high.school.dropout"),
                            textOutput("high.school.paragraph"),
                            plotlyOutput("household.income"),
                            textOutput("income.paragraph"),
                            plotlyOutput("median.age"),
                            textOutput("age.paragraph"))
                    
 
                 )
        ),
        tabPanel("United States", 
                 tabsetPanel(
                   tabPanel("Graph",
                            plotlyOutput("trend.crimeGraph"),
                            textOutput("graph.info")),
                   tabPanel("Table",
                            textOutput("table.info"),
                            dataTableOutput("table"))
                   
                   
                   
                 )
        )
        
      )
    )
  )
)
