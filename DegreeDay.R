
# Click Source instead of Run

# Load libraries
library(data.table)
library(tidyr)
library(dplyr)

# Import Data
readYear <- function() {
  
  #Create a prompt for user to enter what year of data to import
  FY <- readline(prompt = "Please enter the year of data to import(Ex 2015): ")
  FY <- as.integer(FY)
  
 }

if(interactive()) FY <- readYear()
  
 #Error control
while(FY < 999 || is.na(FY)){
  FY <- readYear()
  }

#Create URL
  CoolingURL <- paste("ftp://ftp.cpc.ncep.noaa.gov/htdocs/degree_days/weighted/daily_data/", 
                    FY, "/ClimateDivisions.Cooling.txt", sep = "")
  HeatingURL <- paste("ftp://ftp.cpc.ncep.noaa.gov/htdocs/degree_days/weighted/daily_data/", 
                    FY, "/ClimateDivisions.Heating.txt", sep = "")
  
  #Download data
  ClimateDivisions.Cooling <- fread(CoolingURL, header = T)
  ClimateDivisions.Heating <- fread(HeatingURL, header = T)

  #Gather columns into rows
  ClimateDivisions.Cooling <- gather(ClimateDivisions.Cooling, "Date", "Days", -Region)
  ClimateDivisions.Heating <- gather(ClimateDivisions.Heating, "Date", "Days", -Region)
  
  #Format Date column to Date format
  ClimateDivisions.Cooling$Date <- as.Date(as.character(ClimateDivisions.Cooling$Date), "%Y%m%d")
  ClimateDivisions.Heating$Date <- as.Date(as.character(ClimateDivisions.Heating$Date), "%Y%m%d")
  
  #Summarize by month, then Change Date rows to columns
  ClimateDivisions.Cooling <- tbl_df(ClimateDivisions.Cooling) %>%
    group_by(Region, Date = cut.Date(Date, breaks = "month")) %>%
    summarise(Days = sum(Days)) %>%
    spread(Date, Days)
  
  ClimateDivisions.Heating <- tbl_df(ClimateDivisions.Heating) %>%
    group_by(Region, Date = cut.Date(Date, breaks = "month")) %>%
    summarise(Days = sum(Days)) %>%
    spread(Date, Days)
  
#Create a prompt to ask user if they want to save it or not 
  exportData <- readline(prompt = "Save data[Y/N]?: ")

if(grepl("^[Y-y]",exportData)) {
  
  # Export Data
  # setwd("C:/Users/sli/Desktop")
  write.csv(ClimateDivisions.Cooling, "ClimateDivisions.Cooling.csv", row.names = F)
  write.csv(ClimateDivisions.Heating, "ClimateDivisions.Heating.csv", row.names = F)

}
