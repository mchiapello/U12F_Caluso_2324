library(tidyverse)

tmp <- tibble(date = lubridate::dmy("18/09/2023"),
       misure = c("Altezza", "Reach", "Muro", "Rincorsa"),
       "Chimienti-Martina" = c(143,181,200,201),
       "Fragonas-Matilde" = c(138,172,192,200),
       "Cireddu-Adele" = c(154,193,217,218),
       "Budau-Erika" = c(138,176,196,201),
       "Panetto-Margherita" = c(154,188,209,214),
       "Gerace-Valeria" = c(160,201,224,228),
       "Boni-Isabella" = c(160,201,232,239),
       "Beretta-Sharon" = c(156,199,228,234),
       "Gillone-Arianna" = NA,
       "Mauro-Sharon" = NA,
       "La Monaca-Greta" = c(155,197,208,212),
       "Torchia-Arianna" = c(159,201,217,223),
       "Deluca-Aurora" = c(157,201,220,228),
       "Celeste-Sara" = c(145,182,210,215))|> 
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
