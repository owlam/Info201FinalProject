#install.packages("shiny")
#install.packages("ggplot2")
#install.packages("reshape2")

#install.packages("plotly")

library("shiny")
library("dplyr")
library("rsconnect")
library("ggplot2")
library("reshape2")
library("plotly")


# UI and Server
source("ui.R")
source("server.R")

# Reading in and cleaning washington data
wash.data <- read.csv("washingtonData.csv", stringsAsFactors = FALSE)
colnames(wash.data) <- c("City", "Population", "Violent Crime", "Murder", "Rape", "Rape2", "Robbery", "Aggravated Assault",
                         "Property Crime", "Burglary", "Larceny", "Motor Vehicle Theft", "Arson")
wash.data <- select(wash.data, -Population, -Murder, -Rape2, -Arson) 
wash.data <- wash.data[c(5:186), ] 
wash.data <- wash.data[ ,c(1:9)]

# Reading in and cleaning US data
us.data <- read.csv("USData.csv", stringsAsFactors = FALSE)
colnames(us.data) <- c("Year", "Population", "Violent Crime", "V2", "Murder", "Murder2", "Rape", "Ra2",
                       "Robbery", "Ro2", "Aggravated Assault", "A2", "Property Crime", "P2", "Burglary", "B2", 
                       "Larceny", "L2", "Motor Vehicle Theft", "M2")
us.data <- us.data[, c(1:20)]
us.data <- select(us.data, -Population, -V2, -Murder2, -Ra2, -Ro2, -A2, -P2, -B2, -L2, - M2)
us.data <- us.data[c(4:23), ]

selected.type <- colnames(us.data[3])

# creates the app displaying data 
shinyApp(ui = my.ui, server = my.server)

