my.server <- function(input, output) {
  output$table.info <- renderText({
    print("This table shows...")
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
}