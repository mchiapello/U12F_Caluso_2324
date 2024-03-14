library(tidyverse)
library(gt)
library(gtExtras)

# Create the tibble
volleyball_schedule <- tibble(
  Match = c("XA", "XA", "XA", "XB", "XB", "XB", "XC", "XC", "XC", "XD", "XD", "XD", 
            "XE", "XE", "XE", "XF", "XF", "XF", "XG", "XG", "XG", "XH", "XH", "XH", 
            "XI", "XI", "XI", "XL", "XL", "XL"),
  Set = rep(1:3, 10),
  Giocatore_1 = "Isabella",
  Giocatore_2 = "Adele",
  Giocatore_3 = c("Sharon B", "Sharon B", "Sharon B", 
                  "Martina", "Martina", "Martina", 
                  "Sharon B", "Sharon B", "Sharon B", 
                  "Sharon B", "Sharon B", "Sharon B", 
                  "Sharon B", "Sharon B","Sharon B",
                  "Sharon B", "Sharon B", "Sharon B", 
                  "Sharon B", "Sharon B", "Sharon B", 
                  "Arianna G", "Arianna G", "Arianna G",  
                  "Sharon B", "Sharon B", "Sharon B", 
                  "Valeria", "Valeria", "Valeria"),
  Giocatore_4 = c("Arianna T", "Arianna T", "Sharon M", 
               "Sharon M", "Sara", "Sara", 
               "Martina", "Martina", "Margherita", 
               "Margherita", "Aurora", "Aurora", 
               "Greta", "Greta", "Erika", 
               "Erika", "Arianna G", "Arianna G", 
               "Valeria", "Valeria", "Matilde", 
               "Matilde", "Sharon M", "Sharon M", 
               "Arianna T", "Arianna T", "Sara", 
               "Sara", "Martina", "Martina"),
  Giocatore_5 = c("Margherita", "Margherita", "Aurora", 
               "Aurora", "Greta", "Greta", 
               "Erika", "Erika", "Arianna G", 
               "Arianna G", "Valeria", "Valeria", 
               "Matilde", "Matilde", "Arianna T", 
               "Arianna T", "Sharon M", "Sharon M", 
               "Sara", "Sara", "Martina", 
               "Martina", "Aurora", "Aurora", 
               "Margherita", "Margherita", "Greta", 
               "Greta", "Erika", "Erika"),
  Giocatore_6 = c("Arianna G", "Arianna G", "Valeria", 
               "Valeria", "Matilde", "Matilde", 
               "Arianna T", "Arianna T", "Sharon M", 
               "Sharon M", "Sara", "Sara", 
               "Martina", "Martina", "Margherita", 
               "Margherita", "Aurora", "Aurora", 
               "Greta", "Greta", "Erika", 
               "Erika", "Valeria", "Valeria", 
               "Arianna G", "Arianna G", "Matilde", 
               "Matilde", "Arianna T", "Arianna T")
)

custom_css <- "
<style>
.gt_group_heading {
  text-align: center !important;
  font-size: 20px !important;
  background-color: grey !important;
}
</style>
"

# dd <- volleyball_schedule |>
#   mutate(Match = lubridate::ymd(Match),
#          Match = paste0(lubridate::day(Match), " ", lubridate::month(Match, label = TRUE)),
#          Match = factor(Match, levels = c("24 Feb", "2 Mar", "9 Mar", "16 Mar", "23 Mar", "6 Apr",
#                                         "13 Apr", "20 Apr", "27 Apr", "5 May"))) |>
#   group_by(Match) |>
#   gt()|>
#   tab_header(
#     title = md("**UISP Under12F 2023/2024**"),
#     subtitle = "Organizzazione delle partite della seconda fase"
#   )

# htmltools::browsable(
#   htmltools::tagList(
#     htmltools::HTML(custom_css),
#     dd
#   )
# )
# 
# tmp <- volleyball_schedule |>
#   pivot_longer(cols = starts_with("Gio"),
#                names_to = "Giocatore",
#                values_to = "Name") |> filter(!Name %in% c("Isabella", "Adele", "Sharon B")) |> 
#   count(Name, Match) |> 
#   select(-n) |>
#   group_by(Name) |>
#   nest()
# 
# 
# x <- tmp$data[[1]]
# 
# 
# dai <- function(x){
#   out <- x |>
#     mutate(Match = lubridate::ymd(Match),
#            data = paste0(lubridate::day(Match), " ", lubridate::month(Match, label = TRUE)),
#            data = factor(data, levels = c("24 Feb", "2 Mar", "9 Mar", "16 Mar", "23 Mar", "6 Apr",
#                                           "13 Apr", "20 Apr", "27 Apr", "5 May"))) |>
#     summarise(Data = paste(data, collapse = ", "))
# }
# 
# tmp |>
#   mutate(Data = map(data, dai)) |>
#   unnest(Data) |>
#   select(-data) |>
#   ungroup() |>
#   gt()

vs1 <- volleyball_schedule |>
  pivot_longer(cols = starts_with("Gio"),
               names_to = "Giocatore",
               values_to = "Name") |> 
  select(-Set) |> 
  mutate(Giocatore = 1) |> 
  unique() |> 
  pivot_wider(names_from = Match,
              values_from = Giocatore) %>%
  replace(is.na(.), 0) |> 
  select(Name, XA, XG, XC, XB,XD,XE,XF,XL,XH,XI)

column_name <- names(vs1)[11]
vs1 |> 
  # mutate(!!column_name := .data[[column_name]] + 0) |>
  rowwise() |> 
  mutate(Tot = sum(c_across(starts_with("X")))) |> 
  gt()


################################################################################
# Partite giocate


tibble(Nome = vs1$Name,
       "G1" = vs1$XA,
       "G2" = c(0,0,1,0,1,1,0,0,1,1,1,1,1,1),
       "G3" = c(1,1,1,1,1,0,1,0,0,0,1,1,1,0),
       "G4" = c(1,1,0,0,0,0,0,1,1,1,0,0,0,1),
       "G5" = c(1,1,0,1,1,1,1,1,1,0,1,0,0,0),
       "G6" = vs1$XE,
       "G7" = vs1$XF,
       "G8" = vs1$XL,
       "G9" = vs1$XI,
       "G10" = vs1$XH) |> 
  janitor::adorn_totals("row") |> 
  rowwise() |> 
  mutate(Tot = sum(c_across(starts_with("G")))) |> 
  gt() |> 
  cols_label(
    "G1" = md("Allotreb<br>(24/02)"),
    "G2" = md("Canavolley<br>(09/03)"),
    "G3" = md("AltoCanavese<br>(16/03)"),
    "G4" = md("Sangone<br>(17/03)"),
    "G5" = md("Fortitudo<br>(23/03)"),
    "G6" = md("Allotreb<br>(06/04)"),
    "G7" = md("Sangone<br>(13/04)"),
    "G8" = md("Canavolley<br>(20/04)"),
    "G9" = md("AltoCanavese<br>(05/05)"),
    "G10" = md("Fortitudo<br>(11/05)")) |> 
  tab_style(
    style = cell_text(align = "center"),
    list(
      cells_column_labels(),        # Target column headers
      cells_body())                 # Target the data rows
  ) |> 
  data_color(
    columns = c(G1, G2), # Replace with your column names
    colors = c("#FF5A33")
  ) |> 
  data_color(
    columns = G5:G10, # Replace with your column names
    colors = c("#44803F")
  ) |> 
  data_color(
    columns = G3:G4, # Replace with your column names
    colors = c("#FFEC5C")
  ) |> 
  data_color(
    columns = Tot, # Replace with your column names
    colors = c("#28403D")
  ) 
)
