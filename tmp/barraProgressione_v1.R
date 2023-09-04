library(tidyverse)

dt <- tibble(x = rep(1:4, 4),
       y = rep(4:1, each = 4),
       fill = rep(c(rep("grey", 3), "green"), 4)) 
dt |> 
  bind_rows(dt) |> 
  bind_rows(dt) |> 
  mutate(month = rep(c("Settembre", "Ottobre", "Novembre"), each = 16),
         fill = ifelse(month == "Novembre", "white", fill),
         fill = ifelse(month == "Novembre" & x < 3 & y == 4, "grey", fill)) |> 
  ggplot(aes(x, y, fill = fill)) +
  geom_tile(color = "black", linewidth = .2) +
  scale_fill_identity() +
  facet_wrap(vars(month)) +
  theme_void()



library(calendR)
library(lubridate)



library(calendR)
library(lubridate)
# Vector of NA of the same length of the number of days of the year
events <- rep(NA, interval("2023-10-01", "2024-05-31") %/% days(1) + 1)

# Set the corresponding events
events[c(1, 7,8,14,15,21,22,28,29,35,36)] <- "weekend"
events[c(rbind(seq(2,100,7),seq(5,105,7)))] <- "Training"
events[7] <- "Partita"
events[40:45] <- "Marco Assente"

# Creating the calendar with a legend
calendR(start_date = "2023-10-01", # Custom start date
        end_date = "2024-05-31",
        start = "M",
        special.days = events,
        special.col = c("red", "pink", "green", "grey"),
        legend.pos = "bottom",
        weeknames = c("Lu", "Ma",  # Week names
                      "Me", "Gi",
                      "Ve", "Sa",
                      "Do"),
        title.size = 40,
        text.size = 3,
        months.size = 7,
        weeknames.size = 3.5,
        day.size = 2,
        orientation = "l")