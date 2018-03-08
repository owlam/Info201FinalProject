my.ui <- fluidPage(
  titlePanel(h2("Crime Data in the United States and Washington")),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("type", "Select the type of crime:", c("Violent Crime", "Rape", "Robbery", "Aggravated Assault", "Property Crime", 
                                                    "Burglary", "Larceny","Motor Vehicle Theft"), selected = selected.type)),
      sliderInput("range", "Select the range of years:", 1994, 2013,value = c(1994, 2013), sep = "")
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
                            plotlyOutput("graph")),
                   tabPanel("Map",
                            textOutput("map.info"),
                            plotOutput("map"))
                 )
        )
      ) 
    )
  )
)
