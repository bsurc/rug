library(gapminder)
library(dplyr)
library(magrittr)
library(ggplot2)

# Let's start with piping

#create a numeric vector to demonstrate with
x <- c(0.109, 0.359, 0.63, 0.996, 0.515, 0.142, 0.017, 0.829, 0.907)

#To apply multiple functions to a vector
#we can make intermediate objects

y<-log(x)
z<-diff(y)
a<-exp(z)
b<-round(a,1)

#Or we can nest the functions from inside out
round(exp(diff(log(x))), 1)

#This can be difficult to interpret for someone following your code.
#Nesting can also be hard to debug

#Piping is a more straightforward solution to this.

x %>% log() %>%
  diff() %>%
  exp() %>%
  round(1)

# Although the %>% pipe is the standard, magrittr has many other types of pipes for other uses.

#For example, when I run 
x %>% log() %>%
  diff() %>%
  exp() %>%
  round(1)

#It prints out the results but does not assign the resulting values to anything

#The compound assignment opperator %<>% will reassign the new values to x

x %<>% log() %>%
  diff() %>%
  exp() %>%
  round(1)

x


#There's also a T pipe for branching operations

#If I wnt to plot the matrix AND get the colsums, I can;t do this easily with just the regulr pipe
rnorm(200) %>%
  matrix(ncol = 2) %>%
  plot %>% 
  colSums


#It only plots the results but does not return the colsums

#Using the %T>% pipe lets us branch the operations
rnorm(200) %>%
  matrix(ncol = 2) %T>%
  plot %>% 
  colSums


#Exposition pipe operator 
#The following code does not workbecause we are trying to call "Sepal.Width"
#which is inside the iris dataset, but we have not pulled it unto the pipe
iris %>%
  subset(Sepal.Length > mean(Sepal.Length)) %>%
  cor(Sepal.Length, Sepal.Width)

#If we want to refrence objects from inside the original object "iris"
#then we need to use the exposition pipe %$%
iris %>%
  subset(Sepal.Length > mean(Sepal.Length)) %$%
  cor(Sepal.Length, Sepal.Width)


#Moving forward, we will use only the main pipe operator %>% 
#To look at the functionality of dplyr

#We will look at the following functions: select, filter, group_by, summarize, count, mutate

gapminder #subset gapminder to include only year,country, gdp

year_country_gdp <- select(gapminder,year,country,gdpPercap) #we can do this with the select function alone

year_country_gdp

year_country_gdp <- gapminder %>% select(year,country,gdpPercap) #or we can do this using piping

year_country_gdp


#it becomes more clear why piping is useful when I want to not only get the year,country
#and gdp, but also look at only european countries

year_country_gdp_euro <- gapminder %>%
  filter(continent=="Europe") %>%
  select(year,country,gdpPercap)


#Let's talk about group_by

str(gapminder)

#notice that it is a 'data.frame'

str(gapminder %>% group_by(continent))

#Notice that it now says 'grouped_df'

#a grouped_df is a list where each object in the list is a seperate dataframe which contains only rows 
#which match the grouping variable

#Show fig. 1

#Now let's add in 'summarize'

#Notice that here, we are creating a new variable for the first time
gdp_bycontinents <- gapminder %>%
  group_by(continent) %>%
  summarize(mean_gdpPercap=mean(gdpPercap)) #mean_gdpPercap is the new variable to be stores in the gdp_bycontinents df

#Show Fig 2


#Let's try to group_by multiple variables
gdp_bycontinents_byyear <- gapminder %>%
  group_by(continent,year) %>%
  summarize(mean_gdpPercap=mean(gdpPercap))

#Think about fig 1/2 in this multi variable context

#Now, let's create multiple columns with various summary stats
gdp_pop_bycontinents_byyear <- gapminder %>%
  group_by(continent,year) %>%
  summarize(mean_gdpPercap=mean(gdpPercap),
            sd_gdpPercap=sd(gdpPercap),
            mean_pop=mean(pop),
            sd_pop=sd(pop))

#Let's move on to 'count'

#Count is useful when we want to know how many observations in a df meet a specific condition
#Say from the gapminder dataset, I want to know how many observations there are 
# for each continent in 2002
gapminder %>%
  filter(year == 2002) %>%
  count(continent, sort = TRUE)

#notice that the summary output is n here#

#we can call the 'n' column in the pipe where is it created

#we are going to calculate the std error for the life expectancy for each continent
gapminder %>%
  group_by(continent) %>%
  summarize(se_le = sd(lifeExp)/sqrt(n())) #notice that we name the new standard error variable here

#Let's show how we would chain together multiple summary stats for 'n'
gapminder %>%
  group_by(continent) %>%
  summarize(
    mean_le = mean(lifeExp),
    min_le = min(lifeExp),
    max_le = max(lifeExp),
    se_le = sd(lifeExp)/sqrt(n()))


#Let's move on to mutate

#we can create new variables prior to summarizing our information using 'mutate'
gdp_pop_bycontinents_byyear <- gapminder %>%
  mutate(gdp_billion=gdpPercap*pop/10^9) %>% #create a new column here
  group_by(continent,year) %>%
  summarize(mean_gdpPercap=mean(gdpPercap), #now let's summarize from this column
            sd_gdpPercap=sd(gdpPercap),
            mean_pop=mean(pop),
            sd_pop=sd(pop),
            mean_gdp_billion=mean(gdp_billion),
            sd_gdp_billion=sd(gdp_billion))


#link with ifelse statements
## keeping all data but "filtering" after a certain condition
# calculate GDP only for people with a life expectation above 25
gdp_pop_bycontinents_byyear_above25 <- gapminder %>%
  mutate(gdp_billion = ifelse(lifeExp > 25, gdpPercap * pop / 10^9, NA)) %>%
  group_by(continent, year) %>%
  summarize(mean_gdpPercap = mean(gdpPercap),
            sd_gdpPercap = sd(gdpPercap),
            mean_pop = mean(pop),
            sd_pop = sd(pop),
            mean_gdp_billion = mean(gdp_billion),
            sd_gdp_billion = sd(gdp_billion))


#We can also link dplyr to ggplot

#we could do it like this, with intermediate steps......

# Get the start letter of each country
starts.with <- substr(gapminder$country, start = 1, stop = 1)
# Filter countries that start with "A" or "Z"
az.countries <- gapminder[starts.with %in% c("A", "Z"), ]
# Make the plot
ggplot(data = az.countries, aes(x = year, y = lifeExp, color = continent)) +
  geom_line() + facet_wrap( ~ country)



#But it is also possible to do it with dplyr like this
gapminder %>%
  # Get the start letter of each country
  mutate(startsWith = substr(country, start = 1, stop = 1)) %>%
  # Filter countries that start with "A" or "Z"
  filter(startsWith %in% c("A", "Z")) %>%
  # Make the plot
  ggplot(aes(x = year, y = lifeExp, color = continent)) +
  geom_line() +
  facet_wrap( ~ country)

#we can also remove one more step like this
gapminder %>%
  # Filter countries that start with "A" or "Z"
  filter(substr(country, start = 1, stop = 1) %in% c("A", "Z")) %>%
  # Make the plot
  ggplot(aes(x = year, y = lifeExp, color = continent)) +
  geom_line() +
  facet_wrap( ~ country)
