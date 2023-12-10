library(tidyverse)

x <- tibble(x = c(3, 3, 2, 1, 1, 2),
       y = c(1, 2, 2, 2, 1, 1),
       lab = c(4, 11, 5, 15, 1, 12), 
       rot = "R1") 

add <- function(x){
  tmp <- x$lab
  x |> 
    bind_rows(tibble(x = c(3, 3, 2, 1, 1, 2),
                     y = c(1, 2, 2, 2, 1, 1),
                     lab = tmp[c(2, 3, 4, 5, 6, 1)], 
                     rot = "R2")) |> 
    bind_rows(tibble(x = c(3, 3, 2, 1, 1, 2),
                     y = c(1, 2, 2, 2, 1, 1),
                     lab = tmp[c(3, 4, 5, 6, 1, 2)], 
                     rot = "R3")) |> 
    bind_rows(tibble(x = c(3, 3, 2, 1, 1, 2),
                     y = c(1, 2, 2, 2, 1, 1),
                     lab = tmp[c(4, 5, 6, 1, 2, 3)], 
                     rot = "R4")) |> 
    bind_rows(tibble(x = c(3, 3, 2, 1, 1, 2),
                     y = c(1, 2, 2, 2, 1, 1),
                     lab = tmp[c(5, 6, 1, 2, 3, 4)], 
                     rot = "R5")) |> 
    bind_rows(tibble(x = c(3, 3, 2, 1, 1, 2),
                     y = c(1, 2, 2, 2, 1, 1),
                     lab = tmp[c(6, 1, 2, 3, 4, 5)], 
                     rot = "R6"))
}

x2 <- add(x)
court_colour <- "white"
grid_colour <- "black"
x2 |> 
  ggplot(aes(x, y, label = lab)) +
  annotate(geom = "rect", xmin = 0.5, xmax = 3.5, 
           ymin = 0.5, ymax = 2.5, 
           fill = court_colour, 
           colour = "black") +
  annotate(geom = "rect", xmin = 0.3, xmax = 3.7, 
                  ymin = 2.48, ymax = 2.6, 
                  fill = grid_colour) +
  annotate("segment", x = 1.5, xend = 1.5, y = .5, yend = 2.5,
           colour = grid_colour) +
  annotate("segment", x = 2.5, xend = 2.5, y = .5, yend = 2.5,
           colour = grid_colour) +
  annotate("segment", x = .5, xend = 3.5, y = 1.7, yend = 1.7,
           colour = grid_colour) +
  geom_text(size = 10) +
  theme_void() +
  facet_wrap(vars(rot)) 




