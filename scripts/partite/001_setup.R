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
opp <- "GianFerr"
us <- "BCV Caluso"
date <- "2023-11-11"

pp <- ma(date = date, 
         opp = opp,
         type = "partita",
         time = "14:30:00",
         season = "2022-2023",
         league = "U12 - UISP",
         phase = "Andata",
         home_away = TRUE,
         day_number = 5,
         match_number = 122101,
         set_won = c(2, 1),
         home_away_team  = c("*", "a"),
         won_match = c(TRUE, FALSE),
         coach = c("Chiapello", "Ferrando"),
         assistent = c("", ""))

# Create variables
out <- pp[[1]]
match <- pp[[2]]
teams <- pp[[3]]
