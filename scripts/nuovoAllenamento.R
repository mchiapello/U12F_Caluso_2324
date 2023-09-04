# Define variavbles
### Folder
d <- "08/28/2023"
date <- lubridate::mdy(d)
n <- 5
### File
categories <- c("U14F", "2023-2024", "Pre-season")
palestra <- c("Elementari")
assenti <- c("Randazzo", "Boni")
impegno <- 0.9
obiettivo <- 0.7
allenatore <- 0.6
miglioramenti <- 0.7
voto <- 0.9
obiettivi <- "Difesa"

# Prepare the folder
dd <- lubridate::wday(date, label = TRUE)
if(dd == "Tue"){
  dd <- "M"
} else {
  dd <- "G"
}
pat <- paste0("allenamenti/", date, "_", dd, "_", n)
fs::dir_create(pat)

# Prepare file
library(yaml)
library(tidyverse)
# Create a list with your YAML content
cat(paste0("---\n", 
           "date: ", d, "\n",
           "categories: ['", paste0(categories, collapse = "', '"), "']\n",
           "params:\n",
           "  palestra: '", palestra, "'\n",
           "  date: '", str_replace(as.character(date), 
                                   "(\\d\\d\\d\\d)-(\\d\\d)-(\\d\\d)", 
                                   "\\3/\\2/\\1"), "'\n",
           "  allenamento: '", n, "'\n",
           "  assenti: ['", paste0(assenti, collapse = "', '"), "']\n",
           "  impegno: ", impegno, "\n",
           "  obiettivo: ", obiettivo, "\n",
           "  allenatore: ", allenatore, "\n",
           "  miglioramenti: ", miglioramenti, "\n",
           "  voto: ", voto, "\n",
           "execute:\n",
           "  echo: false\n",
           "  warning: false\n",
           "  message: false\n",
           "---\n\n",
           "## Obiettivi: ", obiettivi, "\n",
           "{{< include ../../_contents/_allenamento.qmd >}}"),
    file = paste0(pat, "/index.qmd"))
