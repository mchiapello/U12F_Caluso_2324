px |> 
  filter(team == noi,
         set_number == 2,
         skill == "Serve") |> 
  ggplot(aes(start_coordinate_x, start_coordinate_y,
             xend = end_coordinate_x, yend = end_coordinate_y,
             colour = evaluation)) +
  geom_segment(arrow = arrow(length = unit(2, "mm"), type = "closed", angle = 20)) +
  # scale_colour_manual(values = c(Ace = "limegreen", Error = "firebrick", Other = "dodgerblue"),
  #                     name = "Evaluation") +
  ggcourt(labels = c("Serving team", "Receiving team")) +
  facet_wrap(vars(player_name))



px |> 
  filter(team == noi,
         set_number == 3,
         skill == "Serve") |>
  ggplot(aes(end_coordinate_x, end_coordinate_y, colour = evaluation)) +
  ggcourt(labels = NULL, court = "full") +
  geom_point()


library(volleyreport)
## generate the report
rpt <- vr_match_summary(x, style = "default", format = "paged_pdf")



recep <- function(x, squadra = noi, set = 1){
  # Define if the team is home/away
  if(which(x$meta$teams$team == squadra) == 1){
    loc <- "home"
  } else {
    loc <- "visiting"
  }
  tmp <- plays(x) |> 
    filter(team == squadra,
           set_number == set,
           skill == "Reception") |> 
    select(team, skill, player_number, evaluation, matches(paste0(loc, "_p[123456]"))) |> 
    pivot_longer(cols = starts_with(loc),
                 names_to = "Position",
                 values_to = "Player") |> 
    filter(player_number == Player) |> 
    arrange(player_number) |> 
    mutate(evaluation2 = case_when(evaluation %in% c("OK, no first tempo possible",
                                                     "Positive, attack") ~ "Positive",
                                   evaluation %in% c("Poor, no attack",
                                                     "Negative, limited attack") ~ "Negative",
                                   evaluation == "Perfect pass" ~ "Perfect",
                                   TRUE ~ evaluation)) |> 
    count(player_number, evaluation2, Position, team) |> 
    unite("prReception", evaluation2, n, sep = ":") |> 
    group_by(player_number, Position, team) |> 
    summarise(prReception = paste(prReception, collapse = "\n"))
    if(squadra == "BCV Caluso"){
      tmp |> 
        mutate(prReception = paste0("Reception:\n", prReception),
               x = case_when(grepl("p1", Position) ~ 3,
                             grepl("p2", Position) ~ 3,
                             grepl("p3", Position) ~ 2,
                             grepl("p4", Position) ~ 1,
                             grepl("p5", Position) ~ 1,
                             grepl("p6", Position) ~ 2),
               y = case_when(grepl("p1", Position) ~ 1,
                             grepl("p2", Position) ~ 2,
                             grepl("p3", Position) ~ 2,
                             grepl("p4", Position) ~ 2,
                             grepl("p5", Position) ~ 1,
                             grepl("p6", Position) ~ 1))
    } else {
      tmp |> 
        mutate(prReception = paste0("Reception:\n", prReception),
               x = case_when(grepl("p1", Position) ~ 1,
                             grepl("p2", Position) ~ 1,
                             grepl("p3", Position) ~ 2,
                             grepl("p4", Position) ~ 3,
                             grepl("p5", Position) ~ 3,
                             grepl("p6", Position) ~ 2),
               y = case_when(grepl("p1", Position) ~ 4,
                             grepl("p2", Position) ~ 3,
                             grepl("p3", Position) ~ 3,
                             grepl("p4", Position) ~ 3,
                             grepl("p5", Position) ~ 4,
                             grepl("p6", Position) ~ 4))
    }
}



df |> 
  mutate(rot2 = case_when(x == 1 & y == 4 ~ "P1",
                          x == 1 & y == 3 ~ "P2",
                          x == 2 & y == 3 ~ "P3",
                          x == 3 & y == 3 ~ "P4",
                          x == 3 & y == 4 ~ "P5",
                          x == 2 & y == 4 ~ "P6",
                          x == 3 & y == 1 ~ "P1",
                          x == 3 & y == 2 ~ "P2",
                          x == 2 & y == 2 ~ "P3",
                          x == 1 & y == 2 ~ "P4",
                          x == 1 & y == 1 ~ "P5",
                          x == 2 & y == 1 ~ "P6")) |> 
  left_join(prServe) |> 
  left_join(prReception) |> 
  mutate(x2 = case_when(serve == "yes" & team != home ~ 1,
                        serve == "yes" & team == home ~ 3),
         y2 = case_when(serve == "yes" & team != home ~ 4.5,
                        serve == "yes" & team == home ~ .5)) |> 
  mutate(coord_X = case_when(!is.na(prServe) ~ x - .48),
         coord_Y = case_when(!is.na(prServe) ~ y + .3)) |>
  mutate(coord_X2 = case_when(!is.na(prReception) & serve != "yes" ~ x + .45),
         coord_Y2 = case_when(!is.na(prReception) & serve != "yes" ~ y + .3)) |>
  ggplot(aes(x, y, label = player_number)) +
  annotate(geom = "rect", xmin = 0.5, xmax = 3.5, 
           ymin = 0.5, ymax = 4.5, 
           fill = court_colour, 
           colour = "black") +
  annotate(geom = "rect", xmin = 0.3, xmax = 3.7, 
           ymin = 2.48, ymax = 2.6, 
           fill = grid_colour) +
  annotate("segment", x = 1.5, xend = 1.5, y = .5, yend = 4.5,
           colour = grid_colour) +
  annotate("segment", x = 2.5, xend = 2.5, y = .5, yend = 4.5,
           colour = grid_colour) +
  annotate("segment", x = .5, xend = 3.5, y = 1.5, yend = 1.5,
           colour = grid_colour) +
  annotate("segment", x = .5, xend = 3.5, y = 3.5, yend = 3.5,
           colour = grid_colour) +
  geom_point(aes(x2, y2), 
             size = 5) +
  geom_text(aes(coord_X, coord_Y, label = prServe), size = 2,
            lineheight = .6, hjust = 0) +
  geom_text(aes(coord_X2, coord_Y2, label = prReception), size = 2,
            lineheight = .6, hjust = 1) +
  geom_text(size = 7) +
  theme_void() +
  facet_wrap(vars(rot)) 



px |> 
  filter(team == loro,
         # player_number == 21,
         skill == "Serve",
         set_number == 3) |> 
  # mutate(y = dv_flip_y(end_coordinate_y)) |> 
  ggplot(aes(start_coordinate_x, start_coordinate_y,
                 xend = end_coordinate_x, yend = end_coordinate_y, colour = evaluation)) +
           geom_segment(arrow = arrow(length = unit(2, "mm"), type = "closed", angle = 20)) +
           scale_colour_manual(values = c(Ace = "limegreen", Error = "firebrick", Other = "dodgerblue"),
                               name = "Evaluation") +
           ggcourt(labels = "") +
  facet_wrap(vars(player_number))
        

px |> 
  filter(team == loro,
         skill == "Reception",
         player_number != 0) |>
  filter(evaluation == "Error") |> 
  # count(evaluation) |> 
  ggplot(aes(end_coordinate_x, end_coordinate_y, label = player_number)) +
  geom_point()+
  ggrepel::geom_text_repel() +
  ggcourt(labels = "")





px |> 
  filter(team == loro,
         # player_number == 7,
         skill == "Serve",
         set_number == 1) |> 
  ggplot(aes(start_coordinate_x, start_coordinate_y,
             xend = end_coordinate_x, yend = end_coordinate_y, colour = evaluation)) +
  geom_segment(arrow = arrow(length = unit(2, "mm"), type = "closed", angle = 20)) +
  scale_colour_manual(values = c(Ace = "limegreen", Error = "firebrick", Other = "dodgerblue"),
                      name = "Evaluation") +
  ggcourt(labels = "") +
  facet_wrap(vars(player_number))
