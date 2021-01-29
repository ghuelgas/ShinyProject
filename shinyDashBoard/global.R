library(DT)
library(shiny)
library(shinydashboard)
library(googleVis)
library(tidyr)
library(maps)
library(ggplot2)
library(forcats)


JoinDF = read.csv("./DataBases/JoinDF.csv", stringsAsFactors = FALSE)
JoinDF = JoinDF %>% filter(., !is.na(Behavior))

# convert matrix to dataframe
state_stat <- data.frame(state.name = rownames(state.x77), state.x77)
# remove row names
rownames(state_stat) <- NULL
# create variable with colnames as choice
choice <- colnames(state_stat)[-1]