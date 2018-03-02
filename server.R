my.server <- function(input, output) {
  output$table.info <- renderText({
    print("This table shows...")
  })
  
  output$table <- renderDataTable({
    
    filter(us.data, us.data$Year >= input$range[1] & us.data$Year <= input$range[2]) %>%  
    #x <- (input$range[1] - 1994) + 1
    #y <- (input$range[2] - 1994) + 1
   # us.table <- us.data[(x:y), ] %>% 
      # filter(Year == c(input$range[1] < range : range > input$range[2])) %>% 
      select(Year,input$type) 
  })
  output$graph.info <- renderText({
    print("This graph shows the trend of crimes over 20 years or ...")
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
    state <- map_data("state", region = "Washington")
    plot <- ggplot(data = state) +
      geom_polygon(aes(x=long, y=lat, group=group))
    print(plot)
    
  })
}
