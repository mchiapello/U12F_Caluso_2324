# Needed libraries
library(datavolley)
library(ovscout2)
library(tidyverse)
library(fs)
library(here)
setwd(here())
source("scripts/999_functions.R")

###############################################################################
# Create match/allenamento
opp <- "Frassati"
us <- "BCV Caluso"
date <- "2024-01-13"

pp <- ma(date = date, 
         opp = opp,
         type = "partita",
         time = "15:00:00",
         season = "2022-2023",
         league = "U12 - UISP",
         phase = "Ritorno",
         home_away = TRUE,
         day_number = 7,
         match_number = 122121,
         set_won = c(2, 0),
         home_away_team  = c("*", "a"),
         won_match = c(TRUE, FALSE),
         coach = c("Chiapello", "Muscarà"),
         assistent = c("", ""))

# Create variables
out <- pp[[1]]
match <- pp[[2]]
teams <- pp[[3]]

