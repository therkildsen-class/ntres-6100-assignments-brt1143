## Data wrangling part 1 

library(skimr) #install.packages("skimr")
library(tidyverse)

coronavirus <- read_csv('https://raw.githubusercontent.com/RamiKrispin/coronavirus/master/csv/coronavirus.csv')
  
  # the tidyverse version of read.csv is read_csv which creates a tbl

summary(coronavirus)
skim(coronavirus)
  # skim package shows a nicer summary that splits into variable types (numeric, character) and shows histogram
view(coronavirus)
head(coronavirus$cases) #view variables at top of dataset 

#dplyr is a package commonly used for data wrangling with 5 common functions

## `filter()` function
filter(coronavirus, cases > 0) #cases represents the condition you want to filter to

coronoavirus_US <- filter(coronavirus, country == "US") # the == is a logical expression, e.g. if country == US, include in tbl
  # use the above notation to assign an object and store the tbl

filter(coronavirus, country != "US")

filter(coronavirus, country == "US" | country == "Canada") # either US OR Canada using `|`
filter(coronavirus, country == "US" & type == "death") # subset country AND death

# Rather than using `==` every time, it is more convenient to use `%in%`
filter(coronavirus, country %in% c("US", "Canada"))

# Exercise: Subset the data to only show the death counts in three European countries on today’s date in 2021.
filter(coronavirus, country %in% c("US", "Italy", "Spain"), type == "death", date == "2021-09-16")

## `select()` function
select(coronavirus, country, lat, long)
  # first specify the data frame, then select columns of interest 


