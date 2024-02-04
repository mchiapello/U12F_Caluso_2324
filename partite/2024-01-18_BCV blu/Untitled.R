ov_scouter(x, video_file = "partite/2024-01-18_BCV Blu/giulia.mp4",
           video_file2 = "partite/2024-01-18_BCV Blu/marco.mp4", 
           video2_offset = 0,
           # court_ref = readRDS(paste0(out, "/mrefx.RDS")),
           scouting_options = list(transition_sets = TRUE,
                                   attack_table = read_csv("data/myAttacks.csv")),
           app_styling = list(review_pane_width = 50),
           # shortcuts = sc,
           launch_browser = TRUE)


# Sure - start ov_scouter with two extra parameters: video_file2 = "/video2.mp4", video2_offset = Z where Z is the 
# time difference in seconds between video_file2 and video_file. I can't remember which way around it goes, but 
# I think a positive value means that an action at time t in video 1 happens at time t + Z in video 2. 
# You can also set that time offset via the "Video setup" button in the UI, but it's a bit clunky. 
# You'll need to set the court reference for both videos. Then you can switch between them 
# (s key by default, or use the button in the UI).