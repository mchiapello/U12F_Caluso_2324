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
opp <- "Alto Canavese"
us <- "BCV Caluso"
date <- "2024-03-16"

pp <- ma(date = date, 
         opp = opp,
         type = "partita",
         time = "15:00:00",
         season = "2023-2024",
         league = "U12 - Coppa UISP",
         phase = "Andata",
         home_away = FALSE,
         day_number = 2,
         match_number = 122111,
         set_won = c(1,2),
         home_away_team  = c("*", "a"),
         won_match = c(FALSE, TRUE),
         coach = c("Chiapello", "Citarelli"),
         assistent = c("", ""))

# Create variables
out <- pp[[1]]
match <- pp[[2]]
teams <- pp[[3]]

