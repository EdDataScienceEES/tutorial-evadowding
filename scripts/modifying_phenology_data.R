# This script was created by Eva Dowding on 23/11/2024
# It's purpose is to modify the Observations from the International Phenology Garden 
# at Alice Holt, Hampshire (2005-2015) data from the Forestry Commission (Open Government Licence v3.0)
# for use in a tutorial.

# Load in libraries ----
library(dplyr)  # Data manipulation
library(tidyr)  # Tidying data
library(lubridate)  # Date manipulation

# Loading in data
phen <- read.csv("source_data/phenology_data_original.csv")

# Investigating structure
glimpse(phen)
str(phen)

# Selecting and simplifying data ----
mod_phen <- phen %>% 
  select(Year, Species, UL, BF, FF, RF, CL, FL) %>%  # Removing extra columns
  rename(leaf_unfolding = UL,
         begins_flowering = BF,
         general_flowering = FF,
         ripe_fruit = RF,
         autumn_colouring = CL,
         leaf_fall = FL) %>%  # Set more meaningful event names
  pivot_longer(cols = 3:8,
               names_to = "event",
               values_to = "date") %>%  # Pivot to long form
  filter(date != "NA") %>%  # Remove empty entries 
  pivot_wider(names_from = Year,
              values_from = date)  # Pivot to wide form with year columns

# Messing up dates ----
mess_phen <- mod_phen %>% 
  mutate(`2005` = ymd("2005-01-01") + days(`2005`),
         `2006` = ymd("2006-01-01") + days(`2006`),
         `2007` = ymd("2007-01-01") + days(`2007`),
         `2008` = ymd("2008-01-01") + days(`2008`),
         `2009` = ymd("2009-01-01") + days(`2009`),
         `2010` = ymd("2010-01-01") + days(`2010`),
         `2011` = ymd("2011-01-01") + days(`2011`),
         `2012` = ymd("2012-01-01") + days(`2012`),
         `2013` = ymd("2013-01-01") + days(`2013`),
         `2014` = ymd("2014-01-01") + days(`2014`),
         `2015` = ymd("2015-01-01") + days(`2015`)) %>%  # Converting to normal date format
  mutate(`2006` = `2006` + hours(12),
         `2007` = paste(day(`2007`), "th", month(`2007`, label = TRUE), year(`2007`)),
         `2008` = paste0(year(`2008`), month(`2008`), day(`2008`)),
         `2009` = paste(month(`2009`, label = TRUE), day(`2009`), "th", year(`2009`)),
         `2010` = `2010` + hours(15) + minutes(35) + seconds(30),
         `2011` = paste0(day(`2011`), "/", month(`2011`), "/", year(`2011`), " 10.20.35"),
         `2012` = paste(month(`2012`, label = TRUE), year(`2012`))) %>% 
  select(-c(`2013`:`2015`)) %>% 
  mutate(`2007` = case_when(grepl("NA", `2007`) ~ NA,
                            !grepl("NA", `2007`) ~ `2007`),
         `2008` = case_when(grepl("NA", `2008`) ~ NA,
                            !grepl("NA", `2008`) ~ `2008`),
         `2009` = case_when(grepl("NA", `2009`) ~ NA,
                            !grepl("NA", `2009`) ~ `2009`),
         `2010` = case_when(grepl("NA", `2010`) ~ NA,
                            !grepl("NA", `2010`) ~ `2010`),
         `2011` = case_when(grepl("NA", `2011`) ~ NA,
                            !grepl("NA", `2011`) ~ `2011`),
         `2012` = case_when(grepl("NA", `2012`) ~ NA,
                            !grepl("NA", `2012`) ~ `2012`)) %>%
  filter(if_any(`2005`:`2012`, ~ !is.na(.)))

write.csv(mess_phen, file = "data/messy_phenology.csv")

