library(fs)
library(tidyverse)
library(datavolley)
library(gt)
library(gtExtras)
d <- dir_ls("partite/all/", regexp = "dvw")
lx <- list()
## read each file
for (fi in seq_along(d)) lx[[fi]] <- dv_read(d[fi], insert_technical_timeouts = FALSE)
## now extract the play-by-play component from each and bind them together
px <- list()
for (fi in seq_along(lx)) px[[fi]] <- plays(lx[[fi]])
px <- do.call(rbind, px)



scale_vector <- function(vec) {
  min_val <- min(vec)
  max_val <- max(vec) * 1.1
  
  # Handle cases where all numbers are negative
  if (max_val <= 0) {
    scaled_vec <- -1 * (vec - min_val) / (max_val - min_val) * 10
  } else {
    scaled_vec <- (vec - min_val) / (max_val - min_val) * 10
  }
  
  return(scaled_vec)
}

###############################################################################
# Servizio
serve_score <- px |> 
  filter(team == "BCV Caluso") |>
  filter(skill == "Serve") |> 
  mutate(evaluation2 = case_when(evaluation %in% c("Negative, opponent free attack",
                                                   "OK, no first tempo possible") ~ "Negative",
                                 evaluation %in% c("Positive, no attack",
                                                   "Positive, opponent some attack") ~ "Positive",
                                 TRUE ~ evaluation)) |> 
  count(player_name, evaluation2) |> 
  mutate(n = ifelse(evaluation2 %in% c("Error", "Negative"), n * -1, n * 1)) |> 
  group_by(player_name) |> 
  summarise(Serve_score = sum(n)) |> 
  mutate(Serve_score = scale_vector(Serve_score)) |> 
  arrange(desc(Serve_score))

###############################################################################
# Attacco
attack_score <- px |> 
  filter(team == "BCV Caluso") |>
  filter(skill == "Attack") |> 
  mutate(evaluation2 = case_when(evaluation %in% c("Blocked", "Poor, easily dug") ~ "Negative",
                                 evaluation %in% c("Positive, good attack") ~ "Positive",
                                 TRUE ~ evaluation)) |> 
  count(player_name, evaluation2) |> 
  mutate(n = ifelse(evaluation2 %in% c("Error", "Negative"), n * -1, n * 1)) |> 
  group_by(player_name) |> 
  summarise(Attack_score = sum(n)) |> 
  mutate(Attack_score = scale_vector(Attack_score)) |> 
  arrange(desc(Attack_score))

###############################################################################
# Ricezione
reception_score <- px |> 
  filter(team == "BCV Caluso") |>
  filter(skill == "Reception") |> 
  mutate(evaluation2 = case_when(evaluation %in% c("Negative, limited attack", 
                                                   "Poor, no attack") ~ "Negative",
                                 evaluation %in% c("OK, no first tempo possible",
                                                   "Positive, attack") ~ "Positive",
                                 TRUE ~ evaluation)) |> 
  count(player_name, evaluation2) |> 
  mutate(n = ifelse(evaluation2 %in% c("Error", "Negative"), n * -1, n * 1)) |> 
  group_by(player_name) |> 
  summarise(Reception_score = sum(n)) |> 
  mutate(Reception_score = scale_vector(Reception_score)) |> 
  arrange(desc(Reception_score))

###############################################################################
# Difesa
dig_score <- px |> 
  filter(team == "BCV Caluso") |>
  filter(skill == "Dig") |> 
  mutate(evaluation2 = case_when(evaluation %in% c("Ball directly back over net", 
                                                   "No structured attack possible") ~ "Negative",
                                 evaluation %in% c("Good dig",
                                                   "OK, no first tempo possible") ~ "Positive",
                                 TRUE ~ evaluation)) |> 
  count(player_name, evaluation2) |> 
  mutate(n = ifelse(evaluation2 %in% c("Error", "Negative"), n * -1, n * 1)) |> 
  group_by(player_name) |> 
  summarise(Dig_score = sum(n)) |> 
  mutate(Dig_score = scale_vector(Dig_score)) |> 
  arrange(desc(Dig_score))


serve_score |> 
  left_join(attack_score) |> 
  left_join(reception_score) |> 
  left_join(dig_score) |> 
  write_csv("data/fond_score_calculation.csv")
