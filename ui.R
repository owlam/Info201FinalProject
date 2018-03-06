my.ui <- fluidPage(
  titlePanel(h2("Crime Data in the United States and Washington")),
  sidebarLayout(
    sidebarPanel(
      selectInput("year", "Choose a year: ", c(1994:2013)),
      radioButtons("type", "Type of Crime", widget.names, selected = selected.type),
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
                            plotlyOutput("trend.crimeGraph"))
                            # p("Crime Type:", strong(textOutput('selected', inline = TRUE))),
                            # p("Year:", strong(textOutput('selected', inline = TRUE))),
                            # p("Number of cases:" , strong(textOutput('selected', inline = TRUE))))
                            
                 
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



