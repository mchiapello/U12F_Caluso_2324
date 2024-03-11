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
  filter(grepl("Beretta|LaMonaca|Gillone|Chimineti|Panetto|Gerace|Budau|Fragonas|Celeste", Nome))

# Weights
weights <- c(Ricezione = 2, Battuta = 2, Attacco = 1.5, Difesa = 1.5)

# Apply weights
for (skill in names(weights)) {
  players[[skill]] <- players[[skill]] * weights[skill]
}

# Exclude SharonB and Adele for combination purposes
other_players <- players[!players$Nome %in% c("Sharon Beretta", "Margherita Panetto"), ] |> 
  mutate(players = row_number())

# Get all combinations of 4 players (since Isabella and Adele are fixed)
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


tmp2 |> 
  group_by(Team, TOT, TOT_SE, Atlete) |> 
  nest() |> 
  arrange(desc(TOT)) |> 
  print(n = Inf) 

tmp2 |> 
  mutate(Team = factor(Team)) |>
  arrange(desc(TOT)) |>
  mutate(Team = fct_reorder(Team, desc(TOT))) |>
  # slice(1:90) |>
  # filter(Team %in% c("T1", "T35")) |>
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
                    mutate(Team = fct_reorder(Team, desc(TOT)),
                           Fond = "tutte") |> 
                    select(Team, Fond, TOT, TOT_SE) |> 
                    distinct(),
                ) +
  geom_point(aes(x = Team,
                    y = TOT),
                data = tmp2 |> 
                  mutate(Team = factor(Team)) |> 
                  arrange(desc(TOT)) |> 
                  mutate(Team = fct_reorder(Team, desc(TOT)),
                         Fond = "tutte") |> 
                  select(Team, Fond, TOT, TOT_SE) |> 
                  distinct(),
  ) +
  theme_linedraw()


tmp2 |> 
  arrange(desc(TOT))
  separate_rows(Atlete) |> 
  group_by(Team, Fond, MEAN,SD, MEDIAN, TOT) |> 
  nest()




# Function to calculate team strength
team_strength <- function(combination, df) {
  team <- df[c(combination, 1, 2), 2:ncol(df)]
  return(mean(rowSums(team)))
}

# Calculate team strengths for all combinations
team_strengths <- apply(combinations_of_six, 1, function(comb) team_strength(comb, other_players))


tibble(as_tibble(combinations_of_six, .name_repair = "universal"),
       team_strengths) |> 
  rename("P3" = `...1`,
         "P4" = `...2`,
         "P5" = `...3`,
         "P6" = `...4`) |> 
  mutate(P3 = case_when(P3 == 1 ~ other_players[1,1],
                        P3 == 2 ~ other_players[2,1],
                        P3 == 3 ~ other_players[3,1],
                        P3 == 4 ~ other_players[4,1],
                        P3 == 5 ~ other_players[5,1],
                        P3 == 6 ~ other_players[6,1],
                        P3 == 7 ~ other_players[7,1]),
         P4 = case_when(P4 == 1 ~ other_players[1,1],
                        P4 == 2 ~ other_players[2,1],
                        P4 == 3 ~ other_players[3,1],
                        P4 == 4 ~ other_players[4,1],
                        P4 == 5 ~ other_players[5,1],
                        P4 == 6 ~ other_players[6,1],
                        P4 == 7 ~ other_players[7,1]),
         P5 = case_when(P5 == 1 ~ other_players[1,1],
                        P5 == 2 ~ other_players[2,1],
                        P5 == 3 ~ other_players[3,1],
                        P5 == 4 ~ other_players[4,1],
                        P5 == 5 ~ other_players[5,1],
                        P5 == 6 ~ other_players[6,1],
                        P5 == 7 ~ other_players[7,1]),
         P6 = case_when(P6 == 1 ~ other_players[1,1],
                        P6 == 2 ~ other_players[2,1],
                        P6 == 3 ~ other_players[3,1],
                        P6 == 4 ~ other_players[4,1],
                        P6 == 5 ~ other_players[5,1],
                        P6 == 6 ~ other_players[6,1],
                        P6 == 7 ~ other_players[7,1])) |> 
  arrange(desc(team_strengths))




# Find the most balanced teams
average_strength <- mean(team_strengths)
balanced_teams <- combinations_of_six[order(abs(team_strengths - average_strength)), ][1:3, ]

# Get team names
balanced_team_names <- lapply(1:3, function(i) other_players$Nome[balanced_teams[i, ]] %>% c("Isabella", "Adele"))

# Calculate team scores and standard deviation
team_scores <- sapply(balanced_teams, function(team) sum(players[c(team, 1, 2), 2:ncol(players)]))
std_deviation <- sd(team_scores)

list(balanced_team_names = balanced_team_names, team_scores = team_scores, std_deviation = std_deviation)
