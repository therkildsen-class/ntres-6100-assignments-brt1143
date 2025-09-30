## data import 

library(tidyverse)
library(readxl)
library(googlesheets4) #install.packages("googlesheets4")
library(janitor) #install.packages("janitor")


#load in dataset 
lotr <- read_csv("https://raw.githubusercontent.com/jennybc/lotr-tidy/master/data/lotr_tidy.csv")


write_csv(lotr, file = "data/lotr.csv") #specify folder the file gets written to

#best practice rather than writing out entire directory (don't use set_wd)

#read csv
lotr <- read_csv("data/lotr.csv") 

#read excel 
lotr_excel <- read_xlsx("data/data_lesson11.xlsx")

## default is to grab the first tab if there are several in an excel sheet 

lotr_excel <- read_xlsx("data/data_lesson11.xlsx", sheet = "FOTR") #specify which sheet

#load in google sheet
gs4_deauth() #remove need to provide authorization to access google account 

lotr_google <- read_sheet("https://docs.google.com/spreadsheets/d/1X98JobRtA3JGBFacs_JSjiX-4DPQ0vZYtNl_ozqF6IE/edit#gid=754443596", sheet = "deaths", range = "A5:F15") #specify rows



# Janitor function --------------------------------------------------------

msa <- read_tsv("https://raw.githubusercontent.com/nt246/NTRES-6100-data-science/main/datasets/janitor_mymsa_subset.txt")

colnames(msa)

msa_clean <- clean_names(msa)


