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
date <- "2023-12-16"

pp <- ma(date = date, 
         opp = opp,
         type = "partita",
         time = "15:00:00",
         season = "2022-2023",
         league = "U12 - UISP",
         phase = "Ritorno",
         home_away = TRUE,
         day_number = 6,
         match_number = 122114,
         set_won = c(1, 2),
         home_away_team  = c("a", "*"),
         won_match = c(FALSE, TRUE),
         coach = c("Chiapello", "Ferrando"),
         assistent = c("", ""))

# Create variables
out <- pp[[1]]
match <- pp[[2]]
teams <- pp[[3]]

