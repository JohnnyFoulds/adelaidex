# activity 7
library(gapminder)

gapminder

write_csv(gapminder, "gapminder.csv")

gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarize(gdpPercap=mean(gdpPercap), lifeExp=mean(lifeExp))

gaps <- gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarize(gdpPercap=mean(gdpPercap), lifeExp=mean(lifeExp))  %>%
  mutate("gdpPercap/lifeExp"=gdpPercap/lifeExp, 
         "log(gdpPercap/lifeExp)"=log(gdpPercap/lifeExp), 
         "log(gdpPercap)/lifeExp)"=log(gdpPercap)/lifeExp)


gaps

# draw bar charts - what a cluster fuck
gaps %>%
  gather(key="measure", value="value", -continent, -gdpPercap, -lifeExp)


gaps %>%
  gather(key="measure", value="value", -continent, -gdpPercap, -lifeExp) %>%
  filter(measure == "gdpPercap/lifeExp") %>%
  ggplot(aes(x=continent, y=value)) + 
  geom_bar(stat="identity")

gaps %>%
  gather(key="measure", value="value", -continent, -gdpPercap, -lifeExp) %>%
  filter(measure == "log(gdpPercap/lifeExp)") %>%
  ggplot(aes(x=continent, y=value)) + 
  geom_bar(stat="identity")


gaps %>%
  gather(key="measure", value="value", -continent, -gdpPercap, -lifeExp) %>%
  filter(measure == "log(gdpPercap)/lifeExp)") %>%
  ggplot(aes(x=continent, y=value)) + 
  geom_bar(stat="identity")




gaps %>%
  gather(key="measure", value="value", -continent, -gdpPercap, -lifeExp) %>%
  filter(measure == "gdpPercap/lifeExp") %>%
  ggplot(aes(x=continent, y=value)) + 
  geom_bar(stat="identity") #+
  #facet_wrap( ~ measure)
  
# draw scatter plot
gapminder %>%
  filter(year == 2007) %>%
  mutate("gdpPercap/lifeExp"=gdpPercap/lifeExp, 
         "log(gdpPercap/lifeExp)"=log(gdpPercap/lifeExp), 
         "log(gdpPercap)/lifeExp)"=log(gdpPercap)/lifeExp) %>%
  ggplot(mapping=aes(x=pop, y="log(gdpPercap)/lifeExp")) +
  geom_point() +
  geom_smooth(method="lm")

gapminder %>%
  filter(year == 2007) %>%
  group_by(continent, pop) %>%
  summarize(pop=mean(pop), gdpPercap=mean(gdpPercap), lifeExp=mean(lifeExp))  %>%
  mutate("gdpPercap/lifeExp"=gdpPercap/lifeExp, 
         "log(gdpPercap/lifeExp)"=log(gdpPercap/lifeExp), 
         "log(gdpPercap)/lifeExp)"=log(gdpPercap)/lifeExp)  %>%
  ggplot(mapping=aes(x=pop, y="log(gdpPercap)/lifeExp")) +
  geom_point() +
  geom_smooth(method="lm")

#ggplot(storms, mapping=aes(x=pressure, y=wind, colour=status)) +
#  geom_point() +
#  geom_smooth() +
#  facet_wrap( ~ status)
