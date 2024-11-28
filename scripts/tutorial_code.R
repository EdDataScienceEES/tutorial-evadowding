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
library(tidyr)  # Data tidying package

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

# Check initial value 
phenology$X2005[1]

# Change the month from April to May
month(phenology$X2005[1]) <- 5

# Check final value
phenology$X2005[1]

# Creating a period
period <- years(13) + months(1) + days(39)
# Look at the period
period

# Adding a period to a date
phenology$X2006[1]  # View the initial date
phenology$X2006[1] + period  # View the new date

# Measuring the period between two dates
as.period(phenology$X2006[2] - phenology$X2006[1])

# Creating a duration
duration <- dyears(13) + dmonths(1) + ddays(39)
# Look at the duration - how is it shown in R?
duration

# Adding a duration to a date
phenology$X2006[1]  # View the initial date
phenology$X2006[1] + duration  # View the new date - is it the same as when we added the period?

# Measuring the duration between two dates
as.duration(phenology$X2006[2] - phenology$X2006[1])

########################################

# Creating an interval
interval1 <- interval(phenology$X2005[1], phenology$X2005[2])
# Look at interval 1
interval1

# Does Quercus robus leaf unfolding occur within interval 1 in 2005?
phenology$X2005[3] %within% interval1

# Create a second interval
interval2 <- interval(phenology$X2005[3], phenology$X2005[4])
# Look at interval 2
interval2

# Do these intervals overlap?
int_overlaps(interval1, interval2)


# Section 3 ----

glimpse(emissions)

# Getting the data into the correct form
long_emissions <- emissions %>% 
  pivot_longer(cols = Jan:Dec,
               names_to = "Month",
               values_to = "CO2_emission_kton") %>%  # Pivot data to long form 
  mutate(date = ym(paste(Year, Month)))  # Create a date with ym() function from Year and Month columns

# Finding top 5 emitters
total_emissions <- long_emissions %>%
  group_by(Name) %>%  # Group by country
  mutate(Total_emissions = sum(CO2_emission_kton)) %>%  # Make a new column for total emission
  ungroup() %>%  # Ungroup
  arrange(desc(Total_emissions))  # Arrange from highest emission to lowest
  
# Not working atm
# slice_max(order_by = Total_emissions, n = 5, with_ties = TRUE, na_rm = TRUE)

unique(total_emissions$Name)  # Print the countries in order of total emission
# Top countries are China, United States, Russian Federation, Japan and India

# Filtering data for plotting
plot_emissions <- long_emissions %>% 
  filter(Name == c("China", "United States", "Russian Federation", "Japan", "India")) %>% 
  select(c(Name, date, CO2_emission_kton))

# Basic plotting of data
(plot <- ggplot(plot_emissions, aes(x = date,  # Date on the X axis
                                    y = CO2_emission_kton,  # CO2 on the Y axis
                                    colour = Name)) +  # Colour by country 
  geom_line())

# Making this a bit nicer
(nice_plot <- ggplot(plot_emissions, aes(x = date, 
                                         y = CO2_emission_kton/1000,  # Convert emission to megatons
                                         colour = Name)) +
    geom_line() +
    theme_bw() +
    xlab("") +  # Date is self explanatory! 
    ylab("Monthly CO2 emission (Mton)") +  # Y is now in Megatons
    labs(colour = "Country") +  # Change legend title
    scale_x_date(date_labels = "%b %Y",  # Using the table from earlier! Label formatting
                 date_breaks = "5 years",  # How spaced are the axis labels?
                 date_minor_breaks = "1 year",  # How spaced are the minor gridlines?
                 limit = c(ym("1980 Jan"), NA)) +  #  Limiting date range from 1980 to maximum
  theme(axis.text.x=element_text(angle=60, hjust=1)))  # Angle axis labels for readability


