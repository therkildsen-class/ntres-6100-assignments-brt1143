
## tidy data 

library(tidyverse)

## different ways to structure data

table1 #only table actually in tidy format

table2

table3

table4a

table4b

# generate rate of num cases per 10000 people in population
table1 |> 
  mutate(rate = cases / population * 10000) 

# total counts/ year
table1 |> 
  group_by(year) |> 
  summarize(total = sum(cases))

table1 |> 
  group_by(country) |> 
  ggplot(mapping = aes(x = year, y = cases)) +
  geom_line()

# compute rate for table 2

table2_rate <- table2 |> 
  filter(type == "cases") |>
  filter(type == "population") # data is untidy, much harder to sort 
  mutate(rate = cases / population) |> 
  group_by(country) 
  

# Pivot_wider and pivot_longer --------------------------------------------

# use pivot_longer to reshape data frame 
  ## dataset is too wide, we want to make it **longer**
table4a |> 
  pivot_longer(c(`1999`, `2000`), names_to = "year") 

table4b |> 
  pivot_longer(c(`1999`, `2000`), names_to = "population", values_to = "cases")

# use pivot_wider to reshape data frame
  #dataset is too long, we want to make it **wider**

table2 |> 
  pivot_wider(names_from = type, values_from = count)

# as many unique variables are in that column, will produce that amount of new columns  

table3 |> 
  separate(rate, into = c("cases", "population"))

#separate(variable you want separated, into = c(new column names), splits when encounters first non-numeric

table3 |> 
  separate(rate, into = c("cases", "population"), sep = "/", convert = TRUE)


table5 <- table3 |> 
  separate(year, into = c("century", "year"), sep = 2) # can modify parameters by which variables are separated

# if we want to re-combine, use companion function `unite`

table5 |> 
  unite(fullyear, century, year, sep = "")



coronavirus <- read_csv('https://raw.githubusercontent.com/RamiKrispin/coronavirus/master/csv/coronavirus.csv')

coronavirus |> 
  filter(country == "US", cases >= 0) |> 
  ggplot() +
  geom_line(aes(x = date, y = cases, color = type)) +
  theme_bw()

corona_wide <- coronavirus |> 
  pivot_wider(names_from = type, values_from = cases) 


coronavirus_ttd <- coronavirus |> 
  group_by(country, type) |>
  summarize(total_cases = sum(cases)) |>
  pivot_wider(names_from = type, values_from = total_cases)

# Now we can plot this easily
ggplot(coronavirus_ttd) +
  geom_label(mapping = aes(x = confirmed, y = death, label = country))
  
  
  
