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
                            shiny::plotlyOutput("graph"),
                            shiny::textOutput("wash.graph.info")),
                          
                   tabPanel("Map",
                            shiny::textOutput("map.info"),
                            shiny::plotOutput("map", hover= 'plot.hover'),
                            p("Selected County: ",strong(textOutput('selected', inline = TRUE)))),
                   tabPanel("Socioeconomic Correlations",
                            shiny::textOutput("soc.intro"),
                            shiny::plotlyOutput("high.school.dropout"),
                            shiny::textOutput("high.school.paragraph"),
                            shiny::plotlyOutput("household.income"),
                            shiny::textOutput("income.paragraph"),
                            shiny::plotlyOutput("median.age"),
                            shiny::textOutput("age.paragraph"))
                   
                   
                   
                 )
        ),
        tabPanel("United States", 
                 tabsetPanel(
                   tabPanel("Graph",
                            shiny::plotlyOutput("trend.crimeGraph"),
                            shiny::textOutput("graph.info")),
                   tabPanel("Table",
                            shiny::textOutput("table.info"),
                            shiny::dataTableOutput("table"))
                   
                   
                   
                 )
        )
        
      )
    )
  )
)
