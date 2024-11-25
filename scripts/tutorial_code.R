## Tutorial base script on dates and times

# Tutorial on dates and date-times
# Your name here
# Current date here
# Any important notes

# Load libraries ----
# install.packages("lubridate")  # Run this if you haven't got lubridate installed already
library(lubridate)  # Date and time manipulation
library(dplyr)  # Data manipulation package
library(ggplot2)  # Data visualisation package

# Load data
phenology <- read.csv("data/messy_phenology.csv")  # Loading in Alice Holt Phenology data
emissions <- read.csv("data/CO2_1970_2023.csv")  # Loading in IEA EDGAR CO2 data

# Explore data
glimpse(phenology)

## Base R ----
# Creating dates and date-times in base R
date <- as.Date("2015-06-13")  # Defining a date
weekdays(dt)
days(dt)
months(dt)
quarters(dt)

# Now try converting them to numbers. What do you get?
as.numeric(date)

as.numeric(datetime)

datetime <- as.POSIXlt("2016/03/30 13:40:05")  # Defining a date-time
str(dttime)
weekdays(dttime)
as.numeric(dttime)

names(datetime)


as.Date("August 7th, 1989", format = "%B %dth, %Y")
as.POSIXlt("15 Jan 2002 03:15", format = "%d %b %Y %H:%M")
