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


# Select function ---------------------------------------------------------

select(coronavirus, country, lat, long)
  # first specify the data frame, then select columns of interest 

select(coronavirus, contains('y'), everything()) #`contains` shorthand to gather specified variables or text

# to both filter and subset columns

coronavirus_us <- filter(coronavirus, country == "US") #`<-` assignment operator, can use opt - for shortcut
coronavirus_us2 <- select(coronavirus_us, -lat, -long, -province)
  #clunky to continually subset objects rather than linking the functions 
  # this is where the pipe operator `|>` comes in (used to be `%>%`) shortcut: shift-command-m

# takes object we are operating on, and consider it as an `and then` 

coronavirus |> 
  filter(type == "death", country %in% c("US", "Mexico", "Canada")) |> 
  select(country, date, cases) |> #pipe directly into ggplot
  ggplot() + #data for plot is already selected #we add `+`, not `|>` when using ggplot
  geom_line(mapping = aes(x = date, y = cases, color = country)) #we want diff countries w diff colors 

# Mutate function  ------------------------------------------------------------
vacc <- read_csv("https://raw.githubusercontent.com/RamiKrispin/coronavirus/main/csv/covid19_vaccine.csv")

max(vacc$date)

vacc |> 
  filter(date == max(date)) |> 
  select(country_region, continent_name, people_at_least_one_dose, population) |> 
  mutate(vaxxrate = round(people_at_least_one_dose / population, 2)) 

# create new variable for total doses: take num doses administered / num people at least one dose

vacc |> 
  filter(date == max(date)) |> 
  select(country_region, continenet_name, doses_admin, people_at_least_one_dose, population) |> 
  mutate(totaldoses = doses_admin / people_at_least_one_dose) |>   #mutate(new variable you want name = how to get that variable)
  ggplot() +
  geom_histogram(mapping = aes(x = totaldoses))
  
# same thing but subset to 

vacc |> 
  filter(date == max(date)) |> 
  select(country_region, continent_name, doses_admin, people_at_least_one_dose, population) |> 
  mutate(totaldoses = doses_admin / people_at_least_one_dose) |> 
  filter(totaldoses > 3) |> 
  arrange(-totaldoses) #adding in `-` sorts from low to high 

# In how many countries do >90% of the population have at least one dose and which five countries 
# have the highest vaccination rates (proportion of their population given at least one dose),
# according to this dataset?
  
vacc |> 
  filter(date == max(date)) |> 
  select(country_region, continent_name, people_at_least_one_dose, population) |> 
  mutate(most_doses = people_at_least_one_dose / population) |> 
  filter(most_doses > 0.9) |> #countries with > 90% w at least one dose 
  arrange(-most_doses) |> #organize by variable we just created 
  head(5) #only show the ones we've just arranged


# Summarize function ------------------------------------------------------

coronavirus |> 
  filter(type == "confirmed") |> 
  group_by(country) |> 
  summarize(total = sum(cases),
            n = n()) |> 
  arrange(-total)

coronavirus |> 
  group_by(date, type) |> 
  summarize(total = sum(cases)) |> 
  filter(date == "2023-01-01")

#Which day has had the highest total death count globally reported in this dataset?
## Pipe your global daily death counts into ggplot to visualize the trend over time.

coronavirus |> 
  filter(type == "death") |> 
  group_by(date) |> 
  summarize(total = sum(cases)) |> 
  arrange(-total) 

gg_base <- coronavirus |> 
  filter(type == "confirmed") |> 
  group_by(date) |> 
  summarize(total_cases = sum(cases)) |> 
  ggplot(mapping = aes(x = date, y = total_cases)) 


# Plot types --------------------------------------------------------------

gg_base +
  geom_line() #line 

gg_base +
  geom_col(color = "goldenrod") #colors in area under the curve

gg_base +
  geom_area(color = "firebrick") # fills in the outline of the geom, need to use `fill` to fill whole thing

gg_base +
  geom_line(
    color = "goldenrod", #change color of line
    linetype = "dashed") #change type of line 

gg_base +
  geom_point(, #mapping variable to diff aesthetics
    color = "darkgreen",
    shape = 17, #shape of points
    size = 1,
    alpha = 0.5, #transparency of points
  )


gg_base +
  geom_point(mapping = aes(size = total_cases, color = total_cases), #mapping variable to diff aesthetics
             alpha = 0.5, 
  ) +
  theme_bw() +
  theme(legend.background = element_rect( #legend theme and shape  
    fill = "lightgrey", #background of legend
    color = "black", #border of rectangle 
    linewidth = 0.3 #linewidth of legend border 
  ))


gg_base +
  geom_point(mapping = aes(size = total_cases, color = total_cases), #mapping variable to diff aesthetics
             alpha = 0.5, 
  ) +
  theme_bw() +
  theme(legend.background = "none") #if you want to remove legend 


gg_base +
  geom_point(mapping = aes(size = total_cases, color = total_cases), #mapping variable to diff aesthetics
             alpha = 0.5, 
  ) +
  theme_bw() +
  labs(x = "Date", y = "Total Confirmed Cases", 
       title = str_c("Daily counts of new covid cases", max(coronavirus$date) sep = " "), #will give us largest value df has for date
       subtitle = "Global sums")

coronavirus |> 
  filter(type == "confirmed") |> 
  group_by(country, date) |> 
  summarize(total = sum(cases)) |> 
  ggplot(mapping = aes(x = date, y = total, color = country)) +
           geom_line() 

coronavirus |> 
  filter(type == "confirmed") |> 
  group_by(country) |> 
  summarize(total = sum(cases)) |> 
  arrange(-total) |> 
  head(5) |> 
  pull(country) #`pull` creates vector of selected variable

top5_countries <- coronavirus |>
  filter(type == "confirmed") |>
  group_by(country) |>
  summarize(total = sum(cases)) |>
  arrange(-total) |>
  head(5) |>
  pull(country)


top5_countries <- coronavirus |>
  filter(type == "confirmed", country %in% top5_countries, cases >= 0) |>
  group_by(country) |>
  summarize(total = sum(cases)) |>
  ggplot() +
  geom_line(mapping = aes(x = date, y = total, color = country)) +
  facet_wrap(~ country, ncol = 1)


