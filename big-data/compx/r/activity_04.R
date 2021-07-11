library(tidyverse)
library(tidytext)
library(stringr)
library(dplyr)

setwd("/home/rstudio/code/compx")
carroll_books <- as_tibble(read.csv(file = "carroll_books.csv", as.is = c("text")))

tidy_books <- carroll_books %>%
  unnest_tokens(word, text)

word_count <- tidy_books %>%
  anti_join(stop_words) %>% 
  count(word, sort = TRUE)

tidy_books %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE) %>%
  filter(n > 100) %>%
  ggplot(aes(word, n)) +
  geom_col()
