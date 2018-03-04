# install.packages("shiny")
#install.packages("ggplot2")

library("shiny")
library("dplyr")
library("rsconnect")
library("ggplot2")

# UI and Server
source("ui.R")
source("server.R")

# Reading in and cleaning washington data
wash.data <- read.csv("washingtonData.csv", stringsAsFactors = FALSE)
colnames(wash.data) <- c("City", "Population", "Violent", "Murder", "Rape", "Rape2", "Robbery", "Aggravated Assault",
                         "Property", "Burglary", "Larceny", "Motor Vehicle", "Arson")
wash.data <- select(wash.data, -Population, -Violent, -Rape2, -Arson) 
wash.data <- wash.data[c(5:186), ] 
wash.data <- wash.data[ ,c(1:9)]

# Reading in and cleaning US data
us.data <- read.csv("USData.csv", stringsAsFactors = FALSE)
colnames(us.data) <- c("Year", "Population", "Violent", "V2", "Murder", "Murder2", "Rape", "Ra2",
                       "Robbery", "Ro2", "Aggravated Assault", "A2", "Property", "P2", "Burglary", "B2", 
                       "Larceny", "L2", "Motor Vehicle", "M2")
us.data <- us.data[, c(1:20)]
us.data <- select(us.data, -Population, -V2, -Murder2, -Ra2, -Ro2, -A2, -P2, -B2, -L2, - M2)
us.data <- us.data[c(4:23), ]

selected.type <- colnames(us.data[3])

# creates the app displaying data 
shinyApp(ui = my.ui, server = my.server)

