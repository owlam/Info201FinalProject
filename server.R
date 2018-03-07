library("plotly")
my.server <- function(input, output) {
  find.sum <- function(column){
    column <-  as.numeric(gsub(",", "", as.character(column)))
    column <- as.numeric (column)
    sum <- sum(column)
    return(sum)
  }
  
  

  
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
  output$trend.graph <- renderPlot({
    trend <- ggplot(us.data, aes(x = Year, y = us.data$Violent, group = 1)) +
      geom_line(color = "blue") +
      geom_point(size=3)
    print(trend)
    
    murder <- ggplot(us.data, aes(x = Year, y = us.data$Murder, group = 1)) +
      geom_line(color = "green") +
      geom_point(size=3)
    print(murder)
    
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
  
  output$graph <- renderPlotly({
    plot_ly(
      data.sum, x = ~data.type, y = ~sum, mode = "Markers", type = "bar",
      text = ~paste0("Number of Cases: ", sum),
      color = ~data.type
    )
    
  })
    # ggplot(data = data.sum, aes(x = data.type, y = sum, fill = sum)) +
    #   scale_fill_gradient(low = "green", high = "red") + 
    #   geom_bar(stat = "identity") +
    #   labs(title = "Crime Rates in Washinton in 2013", 
    #        x = "Types of Crime", y = "Amount of Crime Cases") 
  
  #d <- reactiveValues()
  #d$selected.class <- ""
  #output$selected <- renderText({
    #selected <- data.sum[input$plot_hover$x, "sum"]
    #return (selected)
  #})
  
  output$map <- renderPlot({
    counties <- map_data("county")
    wa_county <- subset(counties, region == "washington")
    state.with.counties <-ggplot(data = wa_county) +  
      geom_polygon(aes(x = long, y = lat, group = group)) +  
      coord_quickmap()
    print(state.with.counties)
    
  })
}
