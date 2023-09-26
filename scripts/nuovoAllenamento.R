# Define variavbles
### Folder
d <- "09/25/2023"
date <- lubridate::mdy(d)
n <- 5
### File
categories <- c("U12F", "2023-2024", "Pre-season")
palestra <- c("Ubertini")
assenti <- c("Rissone")
vincitori <- c(8,6,2,3)
impegno <- 0.7
obiettivo <- 0.8
allenatore <- 0.8
miglioramenti <- 0.7
voto <- 0.8
obiettivi <- "Ricezione, Attacco"
url <- "https://youtu.be/im0hjRnDxg4"

# Prepare the folder
dd <- lubridate::wday(date, label = TRUE)
if(dd == "Mon"){
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
           "  vincitori: ['", paste0(vincitori, collapse = "', '"), "']\n",
           "  impegno: ", impegno, "\n",
           "  obiettivo: ", obiettivo, "\n",
           "  allenatore: ", allenatore, "\n",
           "  miglioramenti: ", miglioramenti, "\n",
           "  voto: ", voto, "\n",
           "  url: ", url, "\n",
           "execute:\n",
           "  echo: false\n",
           "  warning: false\n",
           "  message: false\n",
           "---\n\n",
           "## Obiettivi: ", obiettivi, "\n",
           "{{< include ../../_contents/_allenamento.qmd >}}"),
    file = paste0(pat, "/index.qmd"))
