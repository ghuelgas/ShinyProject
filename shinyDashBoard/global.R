library(DT)
library(shiny)
library(shinydashboard)
library(googleVis)
library(tidyr)
library(maps)
library(ggplot2)
library(forcats)
library(dplyr)


JoinDF = read.csv("./DataBases/JoinDF.csv", stringsAsFactors = FALSE)


BehaviorCol = c("Light physical activity" = "lightblue4", "Low fruit consumption" = "salmon3","Low vegetable consumption" = "burlywood2",
                "Moderate physical activity" = "lightblue3", "No physical activity" = "salmon1","Obesity" = "salmon4","Overweight" = "azure2",
                "Vigorous physical activity" = "lightblue2" )


CofDeathCol = c("Alzheimer's disease" = "skyblue4", "Diabetes" = "paleturquoise" , "Heart disease" = "bisque2", "Kidney disease" = "gray20",
                "Stroke" = "peru")

mapDF = JoinDF %>% group_by (., State, Behavior) %>% 
  filter(., !is.na(Behavior) ) %>%
  summarize(., PopulationPercentage = mean(Percentage)) %>%
  pivot_wider(., names_from = Behavior, values_from = PopulationPercentage)