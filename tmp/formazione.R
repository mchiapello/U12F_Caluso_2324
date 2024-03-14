library(gtools) # for combinations
library(tidyverse)

# Player data
players <- read_csv("data/fond_score_calculation.csv") |> 
  rename("Nome" = player_name,
         "Ricezione" = Reception_score,
         "Battuta" = Serve_score,
         "Attacco" = Attack_score,
         "Difesa" = Dig_score)

# Filter for the current match
players <- players |> 
  filter(grepl("Beretta|LaMonaca|Gillone|Panetto|Mauro|Torchia|Fragonas|Celeste", Nome))

# Weights
weights <- c(Ricezione = 2, Battuta = 2, Attacco = 1.5, Difesa = 1.5)

# Apply weights
for (skill in names(weights)) {
  players[[skill]] <- players[[skill]] * weights[skill]
}

# Exclude SharonB and Adele for combination purposes
other_players <- players[!players$Nome %in% c("Isabella Boni", "Adele Cireddu"), ] |> 
  mutate(players = row_number())

# Get all combinations of 4 players on court (since Isabella and Adele are fixed)
combinations_of_six <- combinations(nrow(other_players), 4)


tmp2 <- NULL
for(i in 1:nrow(combinations_of_six)){
  tmp <- other_players |> 
    filter(players %in% combinations_of_six[i,]) |> 
    mutate(Team = paste0("T", i)) |> 
    select(-players) |> 
    pivot_longer(cols = c("Ricezione", "Battuta", "Attacco", "Difesa"),
                 names_to = "Fond",
                 values_to = "Score") 
  tmp0 <- tmp |> 
    select(Nome, Team) |> 
    distinct() |> 
    group_by(Team) |> 
    summarise(Atlete = paste0(Nome, collapse = ", ")) 
  
  tmp1 <- tmp |> 
    summarise(MEAN = mean(Score),
              SE = sd(Score)/sqrt(n()),
              MEDIAN = median(Score),
              .by = c(Team, Fond)) |> 
    left_join(tmp0) |> 
    mutate(TOT = sum(MEAN),
           TOT_SE = sd(MEAN)/sqrt(n())) |> 
    relocate(TOT, TOT_SE, .before = Atlete)
  
  tmp2 <- tmp2 |> 
    rbind(tmp1)
}

tmp2 |> 
  arrange(desc(TOT)) |> 
  print(n=30)


sql <- tmp2 |> 
  group_by(Team, TOT, TOT_SE, Atlete) |> 
  nest() |> 
  arrange(desc(TOT)) |> 
  print(n = Inf) 

ft <- tmp2 |> 
  mutate(Team = factor(Team)) |>
  arrange(desc(TOT)) |>
  mutate(Team = fct_reorder(Team, desc(TOT))) |>
  pull(Team) |> 
  unique()

ft <- c("T17", "T34")

tmp2 |> 
  mutate(Team = factor(Team)) |>
  arrange(desc(TOT)) |>
  mutate(Team = fct_reorder(Team, desc(TOT))) |>
  # slice(1:90) |>
  filter(Team %in% ft) |>
  ggplot(aes(x = Team,
             y = MEAN,
             fill = Fond)) +
  geom_col(position = "dodge") +
  geom_errorbar(
    aes(ymin = MEAN-SE, ymax = MEAN+SE),
    position = position_dodge2(width = 0.5, padding = .5)) +
  geom_pointrange(aes(x = Team,
                    y = TOT,
                    ymin = TOT - TOT_SE,
                      ymax = TOT + TOT_SE),
                  position = position_dodge(width = .01),
                  data = tmp2 |> 
                    mutate(Team = factor(Team)) |> 
                    arrange(desc(TOT)) |> 
                    mutate(Team = fct_reorder(Team, desc(TOT))) |> 
                    filter(Team %in% ft) |>
                    select(Team, Fond, TOT, TOT_SE) |> 
                    distinct(),
                    show.legend = FALSE) +
  geom_point(aes(x = Team,
                    y = TOT),
                data = tmp2 |> 
                  mutate(Team = factor(Team)) |> 
                  arrange(desc(TOT)) |> 
                  mutate(Team = fct_reorder(Team, desc(TOT))) |> 
                  filter(Team %in% ft) |>
                  select(Team, Fond, TOT, TOT_SE) |> 
                  distinct(),
                  show.legend = FALSE) +
  theme_linedraw() +
  scale_fill_manual(breaks = c("Attacco", "Battuta",
                               "Difesa", "Ricezione"),
                    values = c("#F3B562", "#F06060", "#0FC2C0", "#008F8C"))



sql |> print(n= Inf)

sql |> 
  filter(grepl("Celeste", Atlete)) |> 
  filter(grepl("Panetto", Atlete)) |> 
  filter(grepl("Fragonas", Atlete)) |> 
  filter(grepl("Beretta", Atlete)) |> 
  print(n = Inf)