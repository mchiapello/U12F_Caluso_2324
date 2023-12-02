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
opp <- "PoliVenaria"
us <- "BCV Caluso"
date <- "2023-12-02"

pp <- ma(date = date, 
         opp = opp,
         type = "partita",
         time = "11:00:00",
         season = "2022-2023",
         league = "U12 - UISP",
         phase = "Andata",
         home_away = TRUE,
         day_number = 4,
         match_number = 122112,
         set_won = c(3, 0),
         home_away_team  = c("a", "*"),
         won_match = c(TRUE, FALSE),
         coach = c("Chiapello", "Mennaoui"),
         assistent = c("", ""))

# Create variables
out <- pp[[1]]
match <- pp[[2]]
teams <- pp[[3]]
