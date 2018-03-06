my.server <- function(input, output) {
  filtered <- reactive({
    data <- Data.long %>% 
    filter(Crime == input$type)
    return(data)
  })
  output$table.info <- renderText({
    print("This table shows...")
  })
  
  output$table <- renderDataTable({
    filter(us.data, us.data$Year >= input$range[1] & us.data$Year <= input$range[2]) %>%  
    select(Year,input$type) 
  })
  output$graph.info <- renderText({
    print("This graph shows the trend of crimes over 20 years or ...")
  })
  output$trend.crimeGraph <- renderPlotly ({
    p <- plot_ly(data = filtered(), x = ~Year, y = ~Cases, mode= "lines",type = "scatter",
           text = ~paste0("Year: ", Year, " ", "Number of Cases: ", Cases))
    return(p)
    })
  
  output$wash.graph.info <- renderText({
    print("This graph shows...")
  })
  
  #output$bar.graph <- renderPlot({
    #g <- ggplot(dfname, aes(category))
   # g + geom_bar()
  #})
  
  output$map.info <- renderText({
    print("This map shows...")  
  })
  
  output$map <- renderPlot({
    counties <- map_data("county")
    wa_county <- subset(counties, region == "washington")
    state.with.counties <-ggplot(data = wa_county) +  
      geom_polygon(aes(x = long, y = lat, group = group)) +  
      coord_quickmap()
    print(state.with.counties)
    
  })
  
  # Store all the reacted values in a variable 

  # Within the variable where all the reactive values are stored, assign a 
  # default selected variable 

  # Make the click function output a country when that country is clicked on.
  
}
