my.ui <- fluidPage(
  titlePanel(h2("Crime Data in the United States and Washington")),
  sidebarLayout(
    sidebarPanel(
      selectInput("year", "Choose a year: ", c("Over 20 years",1994:2013)),
      checkboxGroupInput("type", "Type of Crime", c("Murder", "Rape", "Robbery", "Aggravated", "Property", 
                                                    "Burglary", "Larceny","Motor")),
      sliderInput("range", "Threshold", 0, 1000, c(100,500), round = FALSE)
    ),
    mainPanel(
      tabsetPanel(
        type = "tabs",
        tabPanel("United States", 
                 tabsetPanel(
                   tabPanel("Table",
                            textOutput("table.info"),
                            dataTableOutput("table")),
                   tabPanel("Graph",
                            textOutput("graph.info"),
                            plotOutput("trend.graph"),
                            plotOutput("bar.graph"))
                 )
        ),
        tabPanel("Washington",
                 tabsetPanel(
                   tabPanel("Graph",
                            textOutput("wash.graph.info"),
                            plotOutput("graph")),
                   tabPanel("Map",
                            textOutput("map.info"),
                            plotOutput("map"))
                 )
        )
      )
    )
  )
)