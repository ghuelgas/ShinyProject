library(tidyverse)
library(dplyr)
library(dlookr)
library(ggplot2)

CauseOfDeath = read_csv("./DataBases/CauseOfDeath.csv")
CauseOfDeath = CauseOfDeath %>%
  select(., -X1, Cause = Cause.Name, Rate = Age.adjusted.Death.Rate) %>%
  filter(., !(Cause %in% c("All causes", "Unintentional injuries", "Influenza and pneumonia", "CLRD", "Suicide")))
CauseOfDeathPlot = CauseOfDeath %>%
  ggplot(aes( fill = Cause)) +
  geom_bar( aes( x = State, y = Rate), stat = "Identity", position = "fill")
CauseOfDeathPlot

# Western diet my affect Alzheimers https://www.tandfonline.com/doi/full/10.1080/07315724.2016.1161566