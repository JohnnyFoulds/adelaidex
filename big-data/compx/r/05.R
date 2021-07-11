library(tidyverse)
library(tidytext)
library(janeaustenr)
library(stringr)
original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
                                                 ignore_case = TRUE)))) %>%
  ungroup()
tidy_books <- original_books %>%
  unnest_tokens(word, text)

library(dplyr)
tidy_books %>%
  anti_join(stop_words) %>% 
  count(word, sort = TRUE)

tidy_books %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE) %>%
  filter(n > 700) %>%
  ggplot(aes(word, n)) +
  geom_col()


library(gutenbergr)
oliver_twist <- gutenberg_download(730, mirror = "http://mirrors.xmission.com/gutenberg/")
oliver_twist

alice_books <- gutenberg_download(c(11,12), mirror = "http://mirrors.xmission.com/gutenberg/")
alice_books
