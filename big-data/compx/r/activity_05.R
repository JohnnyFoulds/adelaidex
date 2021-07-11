library(tidyverse)
library(nycflights13)

flights

mean_delay <- group_by(flights, carrier) %>% 
  summarize(mean=mean(dep_delay, na.rm=TRUE), num_flights = n()) %>%
  arrange(desc(mean))

mean_delay

mean_delay %>% arrange(desc(num_flights))

mean_delay %>% ggplot(mapping=aes(x=num_flights, y=mean)) +
  geom_point() +
  geom_smooth()
  
                       