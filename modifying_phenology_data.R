# This script was created by Eva Dowding on 23/11/2024
# It's purpose is to modify the Observations from the International Phenology Garden 
# at Alice Holt, Hampshire (2005-2015) data from the Forestry Commission (Open Government Licence v3.0)
# for use in a tutorial.

# Load in libraries ----
library(dplyr)  # Data manipulation
library(tidyr)  # Tidying data
library(lubridate)  # Date manipulation

# Loading in data
phen <- read.csv("data/phenology_data_original.csv")

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
  