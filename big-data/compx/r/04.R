library("tidyverse")

ggplot(mpg) +
  geom_point(mapping = aes(x  = displ, y = cty))

ggplot(mpg, aes(x=displ, y=cty)) +
  geom_point()

ggplot(mpg) + geom_point(mapping = aes(x = displ, y = cty, colour = drv))

ggplot(mpg) + 
  geom_point(mapping = aes(x  = displ, y = cty)) +
  geom_smooth(mapping = aes(x  = displ, y = cty)) 

ggplot(mpg, mapping = aes(x  = displ, y = cty)) + 
  geom_point() +
  geom_smooth() 

ggplot(mpg, mapping = aes(x = displ, y = cty, colour = drv)) + 
  geom_point() + 
  geom_smooth() 

ggplot(mpg, mapping = aes(x = displ, y = cty)) + 
  geom_point() + 
  geom_smooth() +
  facet_wrap( ~ drv) 
