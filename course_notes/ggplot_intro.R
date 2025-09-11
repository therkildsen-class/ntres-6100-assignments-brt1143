## 1610 notes for intro to ggplot

library(tidyverse)

mpg 
?mpg
# in tidyverse, most objects come in the form of tibbles, where are basically upgraded data frames 
# mpg dataset includes descriptions of data type (chr, dbl, int)

?cars
cars

View(mpg) #shows table in new page #generally not useful to use view in a quarto document
head(cars) #shows headers
tail(cars) #shows bottom lines 

# All ggplot2 graphs share the same few components:
    ## theme, coordinates, statistics, facets, geometries, aesthetics, data

#aesthetics: how the data is displayed (e.g. positioning along x and y, size of dots)
#theme: background
#geometrics: data points
#shape of geometric objects: shape of data point

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = cyl, y = hwy)) # mapping aesthetic variable from dataset to x + y 

ggplot(data = mpg) +
  geom_point(mapping = aes(x = class, y = drv)) # for these variables, not a good way to visualize these data

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class, size = cyl), shape = 1) 

?geom_point # useful to identify description and different parameters we can use 
  # color, size, and shape are other parameters that add customization
  # to apply a parameter to all variables, must apply it **outside** the aesthetic 

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = year))

# here, because year is a numeric datatype, there is a natural datatype that sorts into a color gradient 

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# again, to apply the same parameter (color = "blue") to all variables, they need to be outside the aes 
  # otherwise the color will default to the first color, in this case red 

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class, size = cyl), shape = 1) +
  geom_smooth(mapping = aes(x = displ, y = hwy)) # add trend line 

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class, size = cyl), shape = 1) +
  geom_smooth() + # add trend line
  facet_wrap(~ year) # split by variable

# including the mapping in the first line will automatically apply it to each new parameter
# facet_wrap will allow us to split by a particular variable 

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class) + # create plots for a particular variable, (here it is class)
  theme_bw() # apply a new background theme for a particlar style 

  