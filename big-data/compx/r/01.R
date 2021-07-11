library(tidyverse)
table(mpg$manufacturer)
prop.table(table(mpg$manufacturer))

ggplot(mpg,aes(manufacturer)) +
  geom_bar() +
  theme(text = element_text(size = 30), axis.text.x = element_text(angle = 90))
