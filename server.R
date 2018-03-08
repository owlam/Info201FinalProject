my.server <- function(input, output) {
  filtered <- reactive({
    data <- Data.long %>% 
      filter(Crime == input$type)
    return(data)
  })
  filtered2 <- reactive({
    data2 <- Soc.graphs.data %>% 
      filter(Crime == input$type) 
    return(data2)
    
  })
  t <- list(
    color = 'white')
  
 
  ##### Washington Graph Tab ####
  # This function converts strings in columns to integers
  find.sum <- function(column) {
    column <- as.numeric(gsub(",", "", as.character(column)))
    column <- as.numeric(column)
    return(column)
  }
  data.type <- c("Murder","Rape","Robbery","Aggravated Assault","Property Crime","Burglary","Larceny","Motor Vehicle Theft")
  sum <- c(sum(find.sum(wash.data$Murder)),
           sum(find.sum(wash.data$Rape)),
           sum(find.sum(wash.data$Robbery)),
           sum(find.sum(wash.data$`Aggravated Assault`)),
           sum(find.sum(wash.data$Property)),
           sum(find.sum(wash.data$Burglary)),
           sum(find.sum(wash.data$Larceny)),
           sum(find.sum(wash.data$`Motor Vehicle`))
  )
  data.sum <- data.frame(data.type, sum)
  total <- sum(sum)
  row.names(data.sum) <- data.type
  
  # Creates Washington Bar Graph
  output$graph <- renderPlotly({
    p <- plot_ly(
      data.sum, type = "bar", x = data.type, y = sum,
      color = data.type
    ) %>% 
      layout(
        title = "Number of Crime Cases in Washington State in 2013", font= t, 
        paper_bgcolor= 'transparent', plot_bgcolor= 'transparent'
      )
  })
  
  output$table.info <- renderText({
    print("The graph here describes numerically the number of cases of different types 
          of crimes that have been committed in the United States each year. By choosing a 
          certain type of crime, users are able to see, at length, the number of cases pertaining 
          to that crime that they chose to see. Furthermore, the second widget below the “crime type” 
          selection allows users to pan through a certain timespan in years and choose exactly the years 
          and its’ corresponding number of cases on the graph. The widgets included in this tab allow for 
          users to have the most comfortable user experience they can by only viewing the data that 
          pertains to them and interests them the most. ")
  })
  
  
  output$table <- renderDataTable({
    filter(us.data, us.data$Year >= input$range[1] & us.data$Year <= input$range[2]) %>%  
      select(Year,input$type) 
  })
  output$wash.graph.info <- renderText({
    print("This bar graph represents the total number of cases per crime 
reported in Washington state across all counties in 2013. Hover over each bar 
          to view the exact total number of cases reported. The types of crime cases include 
          Murder, Rape, Aggravated Assault, Property Crime, Motor Vehicle Theft, Burglary, Larceny, and Robbery.")
  })
  
  #This graphs the crime rates in the united states, widgets change graph
  ax <- list(
    showgrid = FALSE
  )
  output$trend.crimeGraph <- renderPlotly ({
    Data.long$Cases <- find.sum(Data.long$Cases)
    p <- plot_ly(data = filtered(), x = ~Year, y = ~Cases, mode= "lines",type = "scatter",
                 text = ~paste0("Year: ", Year, " ", "Number of Cases: ", Cases)) %>%
      layout(title= paste0(input$type, " case rates in the United States (1994-2013)"), margin= 200, xaxis = ax, yaxis = ax, 
             paper_bgcolor= 'transparent', plot_bgcolor= 'transparent', font= t)
    return(p)
  })
  
  #Explanation of US Graph
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
  
#### SOCIOECONOMIC CORRELATIONS TAB ####
  #Intro Paragraph
   output$soc.intro <- renderText({
     print("Put in intro about correlations of other factors and crime")
   })
  
  #Highschool dropout rate
  output$high.school.dropout <- renderPlotly ({
    p <- plot_ly(data = filtered2(), x = ~Cohort.Dropout.Rate, 
                 y = ~Cases, color= ~Cohort.Dropout.Rate, text = ~paste0("County: ", County), mode= "markers",type = "scatter") %>% 
      add_lines(y = ~fitted(loess(Cases ~ Cohort.Dropout.Rate)),
                line = list(color = 'rgba(7, 164, 181, 1)'),
                name = "Loess Smoother") %>% 
      layout(title= paste0('Correlation of Highschool Dropout Rate Versus ', input$type, ' Rates'), 
             xaxis = list(title ="High School Dropout Rate (2013)"),
             yaxis = list(title = paste0(input$type, " Rates")), 
             paper_bgcolor= 'transparent', plot_bgcolor= 'transparent', font= t
             )
    return(p)
  })
  #Highschool paragraph
   output$high.school.paragraph <- renderText({
     print("Pragraph about the highschool dropout")
   })
  
  
  #Median Household Income
  output$household.income <- renderPlotly ({
    p <- plot_ly(data = filtered2(), x = ~Median.Income, 
                 y = ~Cases, color= ~Median.Income, text = ~paste0("County: ", County), mode= "markers",type = "scatter") %>% 
      add_lines(y = ~fitted(loess(Cases ~ Median.Income)),
                line = list(color = 'rgba(7, 164, 181, 1)'),
                name = "Loess Smoother") %>% 
      layout(title= paste0('Correlation of Median Household Income Versus ', input$type, " Rates"),
             xaxis = list(title ="Median Household Income (2013)"),
             yaxis = list(title = paste0(input$type, " Rates")), 
             paper_bgcolor= 'transparent', plot_bgcolor= 'transparent', font= t)
    return(p)
  })
  #Income paragraph
   output$income.paragraph <- renderText({
     print(paste("Write about income blah blah blah"))
   })

  # Median Age of the county
  output$median.age <- renderPlotly ({
    p <- plot_ly(data = filtered2(), x = ~Median.age, 
                 y = ~Cases, color= ~Median.age, text = ~paste0("County: ", County), mode= "markers",type = "scatter") %>% 
      add_lines(y = ~fitted(loess(Cases ~ Median.age)),
                line = list(color = 'rgb(0,255,255)'),
                name = "Loess Smoother") %>% 
      layout(title= paste0('Correlation of Median Age Verus ', input$type, ' Rates'),
             xaxis = list(title ="Median Household Income (2013)"),
             yaxis = list(title = paste0(input$type, " Rates")), 
             paper_bgcolor= 'transparent', plot_bgcolor= 'transparent', font= t
    )
    return(p)
  })
  #Age paragraph
   output$age.paragraph <- renderText({
     print(paste("Write about age blah blah blah
                 Now testing the break"))
   })
 #Washington State Map Plot 
  output$map <- renderPlot({
    counties <- map_data("county")
    wa_county <- subset(counties, region == "washington")
    cloropleth.map.data <- filter(cloropleth.map.data, Crime == input$type)
    ggplot(data = cloropleth.map.data) +
      geom_polygon(aes(x = long, y = lat, group = group, fill= Cases))
  })
    output$map.info <- renderText({
      print("This map represents the total amount of a specific crime in Washington state, 
            containing the most recent data in the year 2013 by the FBI. Select a crime on the 
            left to view the varying levels based on the chosen crime and find out which counties 
            in Washington observe the most or least amount of crimes.")  
    
  })
#location <- filter(cloropleth.map.data, lat == cloropleth.map.data[1, 14])
  
 d <- reactiveValues()
 d$selected.class <- ""
 output$selected <- renderText({
   return(paste0(input$plot.hover$x,", ",input$plot.hover$y ))
 })
  # long == input$plot.hover$x && lat == input$plot.hover$y
}
