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

# Explore the data
glimpse(phenology)

# Parsing dates and date-times in base R
date <- as.Date("2015-06-13")  # Defining a date
datetime <- as.POSIXlt("2016/03/30 13:40:05")  # Defining a date-time

# Now try converting them to numbers. What do you get?
as.numeric(date)

as.numeric(datetime)

# Formatting
as.Date("August 7th, 1989")  # This just produces an NA!

as.Date("August 7th, 1989", format = "%B %dth, %Y")  # We have to tell R what format the date is in.

# Or for another date-time format:
as.POSIXlt("15 Jan 2002 03:15", format = "%d %b %Y %H:%M")

# Create a vector of character dates
date_vec <- c("3 Dec 2020", "10 Dec 2021", "15 Dec 2025")

# Convert to dates, format and print
(date_vec <- as.Date(date_vec, format = "%d %b %Y"))

glimpse(phenology)

# Column X2005 is in the format day/month/year, so we can use the dmy() function
dmy(phenology$X2005)
# This should output dates in a standard format

# Column X2006 has times as well! It is in the format day/month/year h:m, so use the dmy_hm() function
dmy_hm(phenology$X2006)
# Check the output here!

# Specifying the time zone the data were collected in
dmy_hm(phenology$X2006, tz = "Europe/London")  # These data were collected in Hampshire, England
# See how some data are set to British Summer Time (BST) and some are set to Greenwich Mean Time (GMT)

# First we should set the data type in the phenology set to date or date-time
phenology$X2005 <- dmy(phenology$X2005)

# Check the days of the month recorded in 2005
day(phenology$X2005)

# Check the month that phenological events occurred in 2005
month(phenology$X2005)

# Check that the years are all correct in the 2005 column
year(phenology$X2005)

# Check which week of the year phenological events occurred in 2005
week(phenology$X2005)

# Check the weekday of the 2005 records
wday(phenology$X2005)

# We can do the same with a date-time!
# First set column X2006 to date-time
phenology$X2006 <- dmy_hm(phenology$X2006, tz = "Europe/London")

# Look at the date component of a date-time
date(phenology$X2006)

# Check the hour
hour(phenology$X2006)

# Check the minute
minute(phenology$X2006)

# Check the second
second(phenology$X2006)

# Check the time zone
tz(phenology$X2006)
