my.ui <- fluidPage(
  titlePanel(h2("Crime Data in the United States and Washington")),
  sidebarLayout(
    sidebarPanel(
      selectInput("year", "Choose a year: ", c(1994:2013)),
      checkboxGroupInput("type", "Type of Crime", c("Murder", "Rape", "Robbery", "Aggravated Assault", "Property", 
                                                    "Burglary", "Larceny","Motor Vehicle"), selected = selected.type),
      sliderInput("range", "Range of Years", 1994, 2013,value = c(1994, 2013), sep = "")
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
