library(tidyverse)
library(nycflights13)

mpg[1,]

flights

filter(flights, month == 1)

filter(flights, month == 1, day == 1)

flights %>%  filter(month == 2, day ==1)

flights %>% filter(carrier == "AA")

mpg %>% filter(cyl == 4) %>% nrow()

n1 <- starwars %>% filter(species == "Droid") %>% nrow()
round(n1/nrow(starwars),3)

flights %>% 
  filter(carrier == "AA",month == 1, day == 1) %>% 
  select(flight,dep_time,arr_time)

select(flights, contains("time"))

flights %>% select(contains("time")) # other filters: starts_with() and ends_with()

select(flights, year:day)

starwars_num <- select_if(starwars,is.numeric)

# add a new column
flights %>% mutate(delay = dep_time - sched_dep_time)

flights <- flights %>% mutate(delay = dep_time - sched_dep_time)

storms %>% mutate(storm_id = str_c(str_sub(name,1,3),str_sub(year,3,4)))

by_month <- group_by(flights,month)
by_month

summarise(by_month, delay = mean(dep_delay, na.rm = TRUE))

by_day <- group_by(flights,year,month,day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE)) %>%
  ungroup() %>% 
  mutate(day_num = seq_along(delay)) %>% 
  ggplot(aes(day_num,delay)) + 
  geom_point() + 
  geom_smooth()


summarise(by_day, delay = mean(dep_delay, na.rm = TRUE), num_flights = n()) %>%
  ggplot(aes(num_flights,delay)) + 
  geom_point() + 
  geom_smooth()

