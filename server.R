my.server <- function(input, output) {
  filtered <- reactive({
    data <- Data.long %>% 
    filter(Crime == input$type)
    return(data)
  })
  
  # Changed part for final 
  find.sum <- function(column) {
    column <- as.numeric(gsub(",", "", as.character(column)))
    column <- as.numeric(column)
    return (column)
  }
  
  output$table.info <- renderText({
    print("This table shows...")
  })
  
  output$table <- renderDataTable({
    filter(us.data, us.data$Year >= input$range[1] & us.data$Year <= input$range[2]) %>%  
    select(Year,input$type) 
  })
  # Changed part for final 
  output$trend.crimeGraph <- renderPlotly ({
    Data.long$Cases <- find.sum(Data.long$Cases)
    p <- plot_ly(data = filtered(), x = ~Year, y = ~Cases, mode= "lines",type = "scatter",
           text = ~paste0("Year: ", Year, " ", "Number of Cases: ", Cases)) %>%
      layout(title = paste0(input$type, " case rates in the United States"), margin = 200)
    return(p)
    })
  # Changed part for final 
  output$graph.info <- renderText({
    paste0("The graph shows the trend of various crimes committed over 
          the past 20 years in the United States. The graph representing 
          murder case rates shows that from the years 1994 
          to 1999 there was a general decrease in the number of murders. 
          However, from 1999 to 2007, the number of cases gradually rose 
          again until it fell at a much quicker rate from 2007 to 2013,", 
          "The 'rape' cases graph shows that between 1994 and 1999, the 
          number of rape cases dramatically decreased. However, it 
          increased steadily between the years of 1999 and 2006 before 
          dropping off steadily per year until 2013.", "The 'robbery' cases 
          graph shows an almost linear decline in robbery cases between
          1994 and 1999. However, post-1999, the number of cases overall
          increases until 2008 at which the point the rate slows down gradually
          until 2013.", "The 'aggravated assault' graph shows that the number of   
          cases has steadily decreased from 1994 until 2013. However, there is 
          one portion of the graph that shows that the number briefly increased
          2004 to 2006 before again decreasing as before until 2013.", "The 
          'property' graph shows a steep decline in the number of cases from
          1994 to 1999. The number briefly increases from 1999 to 2001 before
          declining at roughly a uniform rate until 2013.", "The 'burglary'  
          case graph has a very inconsistent trend as it dramatically decreases
          from 1994 to 2000. Following this, the number of cases increases slowly
          but gradually until 2011 at which point it undergoes a very steep dropoff
          until 2013.", "The 'larceny' graph follows a uniform decrease from 1994 to 
          2013 with a small positive increase in the number of cases from 1999 to 2001.
          From 2001 to 2013, the number of cases steadily decreases just as before.", 
          "In the 'motor vehicle' graph, there is effectively a constant decrease in the 
          number of accidents from 1994 to 1999. From 1999 to 2003, there was a very 
          slight increase in the number of accdients before it begins a dramatic decrease
          until 2013.") 
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
