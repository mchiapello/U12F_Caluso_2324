serve_rate <- plays(x) %>%
  filter(skill == "Serve") %>%
  mutate(evaluation2 = case_when(evaluation %in% c("Negative, opponent free attack", 
                                            "OK, no first tempo possible") ~ "Negative",
                          evaluation %in% c("Positive, no attack", 
                                            "Positive, opponent some attack") ~ "Positive",
                          TRUE ~ evaluation)) |> 
  group_by(team, end_zone, evaluation2) %>%
  dplyr::summarize(n_serve = n()) %>%
  mutate(rate = n_serve/sum(n_serve)) %>%
  drop_na() %>%
  ungroup


serve_rate <- cbind(serve_rate, dv_xy(serve_rate$end_zone, end = "lower"))

serve_rate %>%
  filter(team != "BCV Caluso") |> 
  # mutate(rate = range02(rate)) %>%
  mutate(tt = paste0("N: ", n_serve, "\n", round(rate * 100, 0), "%")) |> 
  ggplot(aes(x, y, fill = rate, label = tt)) +
  geom_tile() +
  ggcourt(labels = "", court = "lower") +
  scale_fill_gradient2(low = "white",
                       high = "green",
                       name = "Scala Intensità") +
  geom_text() +
  labs(title = "Battute",
       subtitle = "Zona di arrivo") +
  # annotate(geom = "text", x = 2, y = 0, label = ifelse(teams(x)[1] == noi, "Noi", "Loro"), size = 15) +
  # annotate(geom = "text", x = 2, y = 7, label = ifelse(teams(x)[2] == noi, "Noi", "Loro"), size = 15) +
  theme(plot.title = element_text(hjust = .5, size = 40),
        plot.subtitle = element_text(hjust = .5, size = 30)) +
  facet_wrap(vars(evaluation2))

serve_rate %>%
  filter(team != "BCV Caluso") |> 
  left_join(serve_rate %>%
              filter(team != "BCV Caluso") |> select(team:evaluation2, n_serve) |> 
              pivot_wider(names_from = evaluation2,
                          values_from = n_serve,
                          values_fill = 0) %>%
              rowwise() %>%
              mutate(total = sum(across(Ace:Error), na.rm = TRUE)) %>% 
              mutate(across(Ace:Error , ~round(./total * 100, 0), .names = 'per_{col}')) %>%
              mutate(tt = paste0("N: ", total, "\n",
                                 "Ace: ", Ace, " (", per_Ace, "%)\n",
                                 "Positive: ", Positive, " (", per_Positive, "%)\n",
                                 "Negative: ", Negative, " (", per_Negative, "%)\n",
                                 "Error: ", Error, " (", per_Error, "%)\n")) |> 
              ungroup() |> 
              select(team, end_zone, tt)) |> 
  # mutate(rate = range02(rate)) %>%
  ggplot(aes(x, y, fill = rate, label = tt)) +
  geom_tile() +
  ggcourt(labels = "", court = "lower") +
  scale_fill_gradient2(low = "white",
                       high = "green",
                       name = "Scala Intensità") +
  geom_text() +
  labs(title = "Battute",
       subtitle = "Zona di arrivo") +
  # annotate(geom = "text", x = 2, y = 0, label = ifelse(teams(x)[1] == noi, "Noi", "Loro"), size = 15) +
  # annotate(geom = "text", x = 2, y = 7, label = ifelse(teams(x)[2] == noi, "Noi", "Loro"), size = 15) +
  theme(plot.title = element_text(hjust = .5, size = 40),
        plot.subtitle = element_text(hjust = .5, size = 30))









# ## take just the serves from the play-by-play data
# xserves <- plays(x) |> 
#   filter(skill == "Serve",
#          team == "BCV Caluso") |> 
#   mutate(evaluation2 = case_when(evaluation %in% c("Negative, opponent free attack", 
#                                                   "OK, no first tempo possible") ~ "Negative",
#                                 evaluation %in% c("Positive, no attack", 
#                                                   "Positive, opponent some attack") ~ "Positive",
#                                 TRUE ~ evaluation))
# 
# xserves2 <- cbind(xserves, dv_xy(xserves$end_zone, end = "lower"))
# ggplot(xserves2, aes(start_coordinate_x, start_coordinate_y,
#                     xend = end_coordinate_x, yend = end_coordinate_y)) +
#   geom_segment(arrow = arrow(length = unit(1, "mm"), type = "closed", angle = 20)) +
#   # scale_colour_manual(values = c(Ace = "#238b45", Error = "#a50026", Negative = "#f46d43", 
#   #                                Positive = "#99d8c9"),
#   #                     name = "Evaluation") +
#   ggcourt(labels = c("", "")) +
#   facet_grid(rows = vars(set_number), cols = vars(evaluation2))
# 
# 
# library(datavolley)
# library(volleyreport)
# 
# ## generate the report
# rpt <- vr_match_summary(x, style = "ov1", format = "paged_pdf")
