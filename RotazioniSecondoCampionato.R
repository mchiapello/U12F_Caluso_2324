library(tidyverse)
library(gt)
library(gtExtras)

# Create the tibble
volleyball_schedule <- tibble(
  Match = c("20240224", "20240224", "20240224", "20240323", "20240323", "20240323", "20240309", "20240309", "20240309", "20240316", "20240316", "20240316", 
            "20240323", "20240323", "20240323", "20240406", "20240406", "20240406", "20240413", "20240413", "20240413", "20240420", "20240420", "20240420", 
            "20240427", "20240427", "20240427", "20240505", "20240505", "20240505"),
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

dd <- volleyball_schedule |>
  mutate(Match = lubridate::ymd(Match),
         Match = paste0(lubridate::day(Match), " ", lubridate::month(Match, label = TRUE)),
         Match = factor(Match, levels = c("24 Feb", "2 Mar", "9 Mar", "16 Mar", "23 Mar", "6 Apr",
                                        "13 Apr", "20 Apr", "27 Apr", "5 May"))) |>
  group_by(Match) |>
  gt()|>
  tab_header(
    title = md("**UISP Under12F 2023/2024**"),
    subtitle = "Organizzazione delle partite della seconda fase"
  )

htmltools::browsable(
  htmltools::tagList(
    htmltools::HTML(custom_css),
    dd
  )
)

tmp <- volleyball_schedule |>
  pivot_longer(cols = starts_with("Gio"),
               names_to = "Giocatore",
               values_to = "Name") |> filter(!Name %in% c("Isabella", "Adele", "Sharon B")) |> 
  count(Name, Match) |> 
  select(-n) |>
  group_by(Name) |>
  nest()


x <- tmp$data[[1]]


dai <- function(x){
  out <- x |>
    mutate(Match = lubridate::ymd(Match),
           data = paste0(lubridate::day(Match), " ", lubridate::month(Match, label = TRUE)),
           data = factor(data, levels = c("24 Feb", "2 Mar", "9 Mar", "16 Mar", "23 Mar", "6 Apr",
                                          "13 Apr", "20 Apr", "27 Apr", "5 May"))) |>
    summarise(Data = paste(data, collapse = ", "))
}

tmp |>
  mutate(Data = map(data, dai)) |>
  unnest(Data) |>
  select(-data) |>
  ungroup() |>
  gt()

volleyball_schedule |>
  pivot_longer(cols = starts_with("Gio"),
               names_to = "Giocatore",
               values_to = "Name") |> 
  select(-Set) |> 
  mutate(Giocatore = "X") |> 
  unique() |> 
  pivot_wider(names_from = Match,
              values_from = Giocatore) |> 
  gt()

