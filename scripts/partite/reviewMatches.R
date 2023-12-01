library(tidyverse)
library(ovva)

ovva_shiny(data_path = c(#allenamenti = "data/000_allenamenti/all/",
                         partite = "partite/all"))



library(shiny)
library(ovideo)
playlist <- read_csv(fs::dir_ls("partite/2023-11-25_Vela/playlist/", regex = "csv"))


shinyApp(
  ui = fluidPage(
    ov_video_js(youtube = TRUE, version = 2),
    ov_video_player(id = "yt_player", type = "youtube",
                    version = 2, controller_var = "my_dv",
                    style = "height: 480px; background-color: black;",
                    controls = tagList(tags$input(id = "my_dv_slider", type = "range", min = 0.05, max = 1.5, value = 1, 
                                                                            step = 0.1, title = "Playback rate", style = "width:80px; display:inline;"),
                                       tags$button("Go", onclick = ov_playlist_as_onclick(playlist, "yt_player", controller_var = "my_dv")))
    ),
    tags$script("$('#my_dv_slider').on('input', function(e) { my_dv.set_playback_rate(Number(this.value)) });")
  ),
  server = function(input, output) {},
)

