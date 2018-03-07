my.server <- function(input, output) {
  find.sum <- function(column) {
    column <- as.numeric(gsub(",", "", as.character(column)))
    column <- as.numeric(column)
    return(column)
  }
  data.type <- c("Violent Crime","Rape","Robbery","Aggravated Assault","Property Crime","Burglary","Larceny","Motor Vehicle Theft")
  sum <- c(sum(find.sum(wash.data$`Violent Crime`)),
           sum(find.sum(totalRape)),
           sum(find.sum(wash.data$Robbery)),
           sum(find.sum(wash.data$`Aggravated Assault`)),
           sum(find.sum(wash.data$`Property Crime`)),
           sum(find.sum(wash.data$Burglary)),
           sum(find.sum(wash.data$Larceny)),
           sum(find.sum(wash.data$`Motor Vehicle Theft`))
  )
  data.sum <- data.frame(data.type, sum)
  total <- sum(sum)
  row.names(data.sum) <- data.type
  
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
    trend <- ggplot(us.data) 
  })
  
  output$wash.graph.info <- renderText({
    print("This graph shows...")
  })
  
  output$graph <- renderPlotly({
    p <- plot_ly(
      data.sum, type = "bar", x = data.type, y = sum,
      color = data.type 
    ) %>% 
      layout(
        title = "Number of Crime Cases in Washington State in 2013"
      )
  })
  
  #creates map text
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
