library(tidyverse)
library(nycflights13)

flights
planes

airports

flights %>% left_join(airports, by=c("origin" = "faa"))

planes %>% right_join(flights, by="tailnum")

planes %>% right_join(flights, by="tailnum") %>% 
  head(5) %>%
  select(manufacturer, model) %>%
  unique()
