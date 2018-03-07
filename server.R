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
  output$trend.crimeGraph <- renderPlotly ({
    p <- plot_ly(data = filtered(), x = ~Year, y = ~Cases, mode= "lines",type = "scatter",
           text = ~paste0("Year: ", Year, " ", "Number of Cases: ", Cases)) %>%
      layout(title = paste0(input$type, " case rates in the United States"))
    return(p)
    })
  output$graph.info <- renderText({
    print("This graph shows the trend of crimes over 20 years or ...")
  })
  
  output$wash.graph.info <- renderText({
    print("This graph shows...")
  })
  
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
  
}
