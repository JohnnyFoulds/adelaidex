library(tidyverse)
data(starwars)

table(starwars$eye_color)
prop.table(table(starwars$eye_color))

summary(storms$wind)
sd(storms$wind)

ggplot(storms, aes(wind)) +
  geom_histogram(col = "black")
