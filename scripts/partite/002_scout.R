# Read video file
video_file  <- dir_ls(out, regexp = "*mp4$")

# Prepate team players
## BVC Foglizzese
elat("data/elencoAtlete.csv", team = "BCV Caluso", out = out)
## Avversari
elat(paste0(out, "/", teams$team[teams$team != "BCV Caluso"], ".csv"), team = teams$team[teams$team != "BCV Caluso"], out = out)


x <- dv_create(match = match, 
               teams = teams, 
               players_v = readRDS(paste0(out, "/", teams$team[teams$team != "BCV Caluso"], ".RDS")), 
               players_h = readRDS(paste0(out, "/BCV Caluso.RDS")))
x$meta$teams <- teams

## Court ref
refx <- ovideo::ov_shiny_court_ref(video_file = video_file, t = 1)
saveRDS(refx, paste0(out, "/mrefx.RDS"))

## enter the team lineups for set 1
x <- dv_set_lineups(x, set_number = 1, 
                    lineups = list(c(11,4,16,12,6,15), 
                                   c(13,20,12,21,16,7)), 
                    setter_positions = c(1, 1))

# Subset the attacks
x$meta$attacks <- read_csv("data/myAttacks.csv")

# Do the scouting
ov_scouter(x, video_file = video_file,
           court_ref = readRDS(paste0(out, "/mrefx.RDS")),
           scouting_options = list(transition_sets = TRUE,
                                   attack_table = read_csv("data/myAttacks.csv")),
           app_styling = list(review_pane_width = 50),
           launch_browser = TRUE)

# Restart scouting
ov_scouter(dir_ls(out, regexp = "ovs$"),
           scouting_options = list(transition_sets = TRUE,
                                   attack_table = read_csv("data/myAttacks.csv")),
           app_styling = list(review_pane_width = 50),
           launch_browser = TRUE)

# Update court reference
# refx <- ovideo::ov_shiny_court_ref(video_file = video_file, t = 2800)
# out <- "/Users/chiapell/Documents/personale/PALLAVOLO/U14F_blog_2223/data/002_Partite/2023-03-05_To.volley"

# Link Youtube video with scout
dvw <- dir_ls(out, regexp = "dvw$")
x <- dv_read(dvw)
dv_meta_video(x) <- "https://youtu.be/zE0gixhzaO0"
dv_write(x, dvw)
file_copy(dir_ls(out, regexp = "dvw$"), here("partite", "all"))

# Remove video file
file_delete(dir_ls(out, regexp = "mp4$"))














