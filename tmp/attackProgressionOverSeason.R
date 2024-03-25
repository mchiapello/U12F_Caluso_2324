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


px |> count(match_id, team)

px |> 
  filter(match_id == "493e908508ba55e1fd4746b93408b25a",
         skill == "Attack") |> 
  count(team, skill_subtype)


px2 <- px |> 
  mutate(time = lubridate::ymd(str_sub(time, 1L, 10))) |> 
  group_by(match_id, time) |> 
  nest() |> 
  arrange(time) |> 
  mutate(Attack = map(data, \(x) x |> filter(skill == "Attack") |> count(team, skill_subtype))) |> 
  mutate(Plot = map(Attack, \(x) x |> ggplot(aes(x = team, 
                                                 y = n,
                                                 fill = skill_subtype)) +
                      geom_col() ))


px2 |> 
  unnest(Attack) |> 
  filter(team == "BCV Caluso") |> 
  ggplot(aes(x = time,
             y = n)) +
  geom_vline(aes(xintercept = time), color = "lightgrey", linetype = "dashed") +
  geom_line(aes(color = skill_subtype)) +
  geom_point() +
  geom_smooth(aes(color = skill_subtype), se = FALSE) +
  geom_label(aes(label = team), data = px2 |> 
                             ungroup() |> 
                             unnest(Attack) |> 
                             filter(team != "BCV Caluso") |> 
                             select(time, team) |>
                             unique() |> 
                             mutate(n = rep(c(-1, -3.5, -6), 4))) +

  ggthemes::theme_few()
  
  

px3 <- px |> 
  mutate(time = lubridate::ymd(str_sub(time, 1L, 10))) |> 
  group_by(match_id, time) |> 
  nest() |> 
  arrange(time) |> 
  mutate(Attack = map(data, \(x) x |> filter(skill == "Attack") |> count(team, skill_subtype, evaluation))) |> 
  unnest(Attack) |> 
  filter(team == "BCV Caluso") |> 
         mutate(evaluation = case_when(evaluation == "Error" ~ "Error",
                                       evaluation == "Winning attack" ~ "Point",
                                       TRUE ~ "Other")) 

px3 |> 
  ggplot(aes(x = time,
             y = n, color = evaluation)) +
  geom_point(data = px3 |> 
               filter(evaluation == "Point",
                    skill_subtype == "Hard spike")) +
  geom_line(data = px3 |> 
              filter(evaluation == "Point",
                     skill_subtype == "Hard spike")) +
  geom_point(data = px3 |> 
               filter(evaluation == "Error",
                      skill_subtype == "Hard spike")) +
  geom_line(data = px3 |> 
              filter(evaluation == "Error",
                     skill_subtype == "Hard spike"))