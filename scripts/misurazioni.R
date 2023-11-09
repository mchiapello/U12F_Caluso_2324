library(tidyverse)

tmp <- tibble(date = lubridate::dmy("06/11/2023"),
       misure = c("Altezza", "Reach", "Muro", "Rincorsa"),
       "Chimienti-Martina" = c(143,181,203,207),
       "Fragonas-Matilde" = c(138,174,196,200),
       "Cireddu-Adele" = c(155,195,212,222),
       "Budau-Erika" = c(141,176,195,201),
       "Panetto-Margherita" = c(148,187,210,213),
       "Gerace-Valeria" = NA,
       "Boni-Isabella" = c(166,203,229,241),
       "Beretta-Sharon" = c(158,197,229,237),
       "Gillone-Arianna" = c(170, 210, 232, 237),
       "Mauro-Sharon" = c(167, 202, 227, 234),
       "La Monaca-Greta" = NA,
       "Torchia-Arianna" = c(161,203,221,227),
       "Deluca-Aurora" = NA,
       "Celeste-Sara" = c(149,183,212,218),
       "De Luca-Aurora" = NA) |> 
  pivot_longer(cols = contains("-"),
               names_to = "atleta",
               values_to = "value") |> 
  pivot_wider(names_from = misure,
              values_from = value) |> 
  mutate(saltoFerma = Muro - Reach,
         saltoMovimento = Rincorsa - Reach) 

x <- read_csv(paste0(here::here(), "/data/misurazioni.csv"), show_col_types = FALSE)

x |> 
  bind_rows(tmp) |> 
  write_csv(paste0(here::here(), "/data/misurazioni.csv"))
