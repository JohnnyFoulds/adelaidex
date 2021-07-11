library(tidyverse)
library(nycflights13)

airlines

flights <- left_join(flights, airlines, by = "carrier")

flights %>% select(year, month, day, carrier, name)

