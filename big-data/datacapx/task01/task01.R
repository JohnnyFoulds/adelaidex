# Import Libraries
library("tidyverse")

# --- Data Load
reddit <- read.csv("RS_2017-09_filtered70.csv")
reddit <- as_tibble(reddit)
reddit

# --- Data Clean

# Remove the first column
reddit <- select(reddit, -X)
reddit
