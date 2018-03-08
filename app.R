# install.packages("shiny")
# install.packages("ggplot2")
# install.packages("tidyr")
# install.packages("plotly")
# install.packages("shinythemes")

library("rsconnect")
library('shinythemes')
library("shiny")
library("dplyr")
library("rsconnect")
library("ggplot2")
library("tidyr")
library("plotly")
library("maps")

# UI and Server
source("ui.R")
source("server.R")

# creates the app displaying data 
options(shiny.sanitize.errors= FALSE)
shinyApp(ui = my.ui, server = my.server)