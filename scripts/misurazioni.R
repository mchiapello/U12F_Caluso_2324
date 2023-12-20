library(tidyverse)

tmp <- tibble(date = lubridate::dmy("18/12/2023"),
       misure = c("Altezza", "Reach", "Muro", "Rincorsa"),
       "Chimienti-Martina" = c(143,182,201,207),
       "Fragonas-Matilde" = c(140,173,196,204),
       "Cireddu-Adele" = c(157,195,218,228),
       "Budau-Erika" = c(141,177,197,204),
       "Panetto-Margherita" = c(148,190,210,217),
       "Gerace-Valeria" = c(164,202,225,230),
       "Boni-Isabella" = c(160,203,233,242),
       "Beretta-Sharon" = c(157,196,231,242),
       "Gillone-Arianna" = NA,
       "Mauro-Sharon" = c(164, 200, 228, 236),
       "La Monaca-Greta" = c(157, 199, 213, 219),
       "Torchia-Arianna" = c(160,203,221,228),
       "Celeste-Sara" = NA,
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
