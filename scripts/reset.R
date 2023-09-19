rm(list = ls())
library(tidyverse)
presenze <- readr::read_csv(paste0(here::here(), "/data/elencoAtlete.csv"), show_col_types = FALSE)
presenze |> 
  mutate(date = NA,
         assenti = NA) |> 
  write_csv(paste0(here::here(), "/data/presenze.csv"))
fs::file_delete(paste0(here::here(), "/data/presenze_old.csv"))

presenze |> 
  mutate(vincitori = NA,
         date = NA,
         assenti = NA) |> 
  write_csv(paste0(here::here(), "/data/classificaRaw.csv"))
fs::file_delete(paste0(here::here(), "/data/classificaRaw_old.csv"))

fs::dir_delete(paste0(here::here(), "/docs"))


