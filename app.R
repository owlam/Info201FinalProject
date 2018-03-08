# install.packages("shiny")
# install.packages("ggplot2")
# install.packages("tidyr")
# install.packages("plotly")
# install.packages("shinythemes")

library(shinythemes)
library("shiny")
library("dplyr")
library("rsconnect")
library("ggplot2")
library("tidyr")
library("plotly")

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

#Rape data was missing during clean up, manually putting in 
wash.data$Rape[5] <- 3
wash.data$Rape[10] <- 20
wash.data$Rape[20] <- 37
wash.data$Rape[40] <- 6
wash.data$Rape[47] <- 10
wash.data$Rape[52] <- 42
wash.data$Rape[65] <- 0
wash.data$Rape[70] <- 5
wash.data$Rape[85] <- 12
wash.data$Rape[87] <- 3
wash.data$Rape[88] <- 12
wash.data$Rape[102] <- 4
wash.data$Rape[103] <- 2
wash.data$Rape[105] <- 3
wash.data$Rape[138] <- 4
wash.data$Rape[139] <- 36
wash.data$Rape[145] <- 24
wash.data$Rape[148] <- 166
wash.data$Rape[149] <- 35
wash.data$Rape[151] <- 2
wash.data$Rape[153] <- 0
wash.data$Rape[177] <- 8



# Reading in and cleaning US data
us.data <- read.csv("USData.csv", stringsAsFactors = FALSE)

colnames(us.data) <- c("Year", "Population", "Violent", "V2", "Murder", "Murder2", "Rape", "Ra2",
                       "Robbery", "Ro2", "Aggravated_Assault", "A2", "Property", "P2", "Burglary", "B2", 
                       "Larceny", "L2", "Motor_Vehicle", "M2")
widget.names <- c(colnames(us.data[3:10]))
us.data <- us.data[, c(1:20)]
us.data <- select(us.data, -Population, -V2, -Murder2, -Ra2, -Ro2, -A2, -P2, -B2, -L2, - M2)
us.data <- us.data[c(4:23), ]

selected.type <- colnames(us.data[3])

Data.long <- gather(us.data, 
                    key = Crime,
                    value = Cases, Murder, Rape, Robbery, Aggravated_Assault, Property, Burglary, Larceny, Motor_Vehicle)
Data.long$Cases <- find.sum(Data.long$Cases)
#Reading in highschool dropout rate data
HS.dropout.data <- read.csv("High_School_Dropout_Statistics_by_County_2012-2013.csv", stringsAsFactors = FALSE)

#Reading in city to county data
city.to.county.data <- read.csv("city_to_county_data - Sheet1.csv", stringsAsFactors = FALSE)

#Read in population data
population.data <- read.csv("Wa_county_population_data.csv", stringsAsFactors = FALSE)

#join washington data to add counties
wash.data.with.counties <- left_join(wash.data, city.to.county.data, by="City")

#Reading in Median Income
median.income <- read.csv("median_income_by_county - Sheet1.csv", stringsAsFactors = FALSE)

#Gets county data by adding crime values in each city 
Washington.crime.totals.by.county<- wash.data.with.counties %>% 
  group_by(County) %>% 
  summarise (Murder = sum(as.numeric(gsub(",","",Murder))),
             Rape = sum(as.numeric(gsub(",","",Rape))),
             Robbery = sum(as.numeric(gsub(",","",Robbery))),
             `Aggravated Assault` = sum(as.numeric(gsub(",","",`Aggravated Assault`))),
             Property = sum(as.numeric(gsub(",","",Property))),
             Burglary = sum(as.numeric(gsub(",","",Burglary))),
             Larceny = sum(as.numeric(gsub(",","",Larceny))),
             `Motor Vehicle` = sum(as.numeric(gsub(",","",`Motor Vehicle`)))
             )

HS.dropout.data <- select(HS.dropout.data, County, Cohort.Dropout.Rate)
Data.for.dropout.and.county.plot <- left_join(Washington.crime.totals.by.county,HS.dropout.data, by= 'County')
population.data$County <- trimws(population.data$County, which = "right")
full.data <- left_join(Data.for.dropout.and.county.plot, population.data, by= "County")
full.data <- left_join (full.data, median.income, by ="County")
colnames(full.data)[5] <- "Aggravated_Assault"
colnames(full.data)[9] <- "Motor_Vehicle"
#Normalize the crime values by population
full.data.normalized <- mutate(full.data, Murder = Murder/Total.population)
full.data.normalized <- mutate(full.data.normalized, Rape = Rape/Total.population)
full.data.normalized <- mutate(full.data.normalized, Robbery = Robbery/Total.population)
full.data.normalized <- mutate(full.data.normalized, Aggravated_Assault = `Aggravated Assault`/Total.population)
full.data.normalized <- mutate(full.data.normalized, Property  = Property /Total.population)
full.data.normalized <- mutate(full.data.normalized, Burglary =  Burglary/Total.population)
full.data.normalized <- mutate(full.data.normalized, Larceny = Larceny/Total.population)
full.data.normalized <- mutate(full.data.normalized, Motor_Vehicle = `Motor Vehicle`/Total.population)


#Data for SOC. tab #1 
Soc.graphs.data <- gather(full.data.normalized, 
                    key = Crime,
                    value = Cases, Murder, Rape, Robbery, Aggravated_Assault, Property, Burglary, Larceny, Motor_Vehicle)

#Making datafram for WA cloropleth map
cloropleth.map.data <- gather(full.data, 
                              key = Crime,
                              value = Cases, Murder, Rape, Robbery, Aggravated_Assault, Property, Burglary, Larceny, Motor_Vehicle)

cloropleth.map.data <- mutate(cloropleth.map.data, County = tolower(cloropleth.map.data$County))
cloropleth.map.data <- left_join(cloropleth.map.data, wa_county, by =c('County' ='subregion'))


# creates the app displaying data 

shinyApp(ui = my.ui, server = my.server)

