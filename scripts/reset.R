.rs.restartR()
library(fs)
library(tidyverse)

# Delete everything in doc folder
ll <- dir_ls(paste0(here::here(), "/docs"))
dir_delete(ll[!grepl("html|json|css", ll)])
file_delete(ll[grepl("html|json|css", ll)])

# Clean presenze
presenze <- readr::read_csv(paste0(here::here(), "/data/elencoAtlete.csv"), show_col_types = FALSE)
presenze |> 
  mutate(date = NA,
         assenti = NA) |> 
  write_csv(paste0(here::here(), "/data/presenze.csv"))
presenze |> 
  mutate(date = NA,
         assenti = NA) |> 
  write_csv(paste0(here::here(), "/data/presenze_old.csv"))

# Clean Classifica
presenze |> 
  mutate(vincitori = NA,
         date = NA,
         assenti = NA) |> 
  write_csv(paste0(here::here(), "/data/classificaRaw.csv"))
presenze |> 
  mutate(vincitori = NA,
         date = NA,
         assenti = NA) |> 
  write_csv(paste0(here::here(), "/data/classificaRaw_old.csv"))


