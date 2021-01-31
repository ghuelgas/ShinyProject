library(tidyverse)
library(dplyr)
library(dlookr)
library(ggplot2)
library(googleVis)
library(maps)
library(tidyr)

JoinDF = read.csv("./DataBases/JoinDF.csv", stringsAsFactors = FALSE)


BehaviorCol = c("Light physical activity" = "lightblue4", "Low fruit consumption" = "salmon3","Low vegetable consumption" = "burlywood2",
                "Moderate physical activity" = "lightblue3", "No physical activity" = "salmon1","Obesity" = "salmon4","Overweight" = "azure2",
                "Vigorous physical activity" = "lightblue2" )


CofDeathCol = c("Alzheimer's disease" = "lightgoldenrod1", "Diabetes" = "darkseagreen3" , "Heart disease" = "plum3", "Kidney disease" = "orange2",
                "Stroke" = "rosybrown2")



#Selected for MAIN

CauseBehaCor = JoinDF %>%
  select(., State, CauseDeath, Behavior, Percentage, Rate) %>%
  filter(., !is.na(Rate), !is.na(Percentage),!is.na(Behavior), !is.na(CauseDeath)) %>%
  group_by(., CauseDeath, Behavior, State) %>%
  summarise(., avgPercent = mean (Percentage), avgRate = mean(Rate), .groups = "keep") %>%
  group_by(., CauseDeath, Behavior) %>%
  summarise(., Corr = cor (avgPercent, avgRate, use = "everything")) %>%
  arrange(., desc(Corr))


CauseBehaCorPlot = CauseBehaCor %>%
  mutate(Behavior = fct_reorder(Behavior, Corr))%>%
  ggplot(aes())+
  geom_col(aes(x= CauseDeath, y = Corr, fill = Behavior  ), position = "dodge") +
  scale_fill_manual(values = BehaviorCol) +
  scale_y_continuous(limits = c(-.9,.9), breaks = seq (-.8,.8,0.2)) +
  scale_x_discrete(guide = guide_axis(angle = 45)) +
  labs(x = "Cause of Death",
       y = "Correlation") +
  theme_light()

CauseBehaCorPlot




# Selected on BY STATE -> Cause of death tab

CauseOfDeathPlot2 = JoinDF %>%
  filter(., State == "Minnesota", Year == "2017")%>%
  mutate(CauseDeath = fct_reorder(CauseDeath, desc(Rate)))%>%
  ggplot(aes( fill = CauseDeath)) +
  geom_bar( aes( x = CauseDeath, y = Rate), stat = "Identity", position = "dodge") +
  theme_light()+
  theme( legend.position = "none") +
  scale_fill_manual(values = CofDeathCol) +
  scale_x_discrete(guide = guide_axis(angle = 45))+
  labs(x = "Cause of Death",
       y = "Death rate")
  
CauseOfDeathPlot2

# Selected on BY STATE -> Cause of death tab, over time

CauseOfDeathPlot3 = JoinDF %>% 
  group_by(., CauseDeath , State, Year) %>%
  filter(., State == "Minnesota") %>%
  mutate(., Year = as.factor(Year)) %>%
  summarise(., AvgRate = mean(Rate)) %>%
  ggplot(aes(group = CauseDeath) )+
  geom_line(aes( x = Year, y = AvgRate, color = CauseDeath), size = 1 ) +
  scale_color_manual(values = CofDeathCol)  +
  labs(x = "Year",
       y = "Death rate") +
  theme_light() 
CauseOfDeathPlot3


# Selected on BY STATE -> Behavior tab, over time

CauseOfDeathPlot4 = JoinDF %>% 
  group_by(., Behavior , State, Year) %>%
  filter(., State == "Minnesota") %>%
  summarise(., AvgPercent = mean(Percentage)) %>%
  ggplot(aes(group = Behavior) )+
  geom_line(aes( x = Year, y = AvgPercent, color = Behavior), size = 1 ) +
  scale_color_manual(values = BehaviorCol)  +
  labs(x = "Year",
       y = "Population %") +
  theme_light() 
CauseOfDeathPlot4

CauseOfDeathPlot5 = JoinDF %>%
  filter(., State == "Minnesota", Year == "2017")%>%
  mutate(Behavior = fct_reorder(Behavior, desc(Percentage)))%>%
  ggplot(aes( fill = Behavior)) +
  geom_bar( aes( x = Behavior, y = Percentage), stat = "Identity", position = "dodge") +
  theme_light()+
  theme( legend.position = "none") +
  scale_fill_manual(values = BehaviorCol) +
  scale_x_discrete(guide = guide_axis(angle = 45))+
  labs(x = "Behavior/Risk factor",
       y = "Population %")

CauseOfDeathPlot5


#Selected for BEHAVIOR STRATIFICATION

StratCategory = JoinDF %>%
  filter(., State == "Minnesota", StratificationCategory == "Gender", !is.na(Behavior)) %>%
  group_by(., Stratification , Behavior) %>%
  summarise(., AvgStratPerc = mean(Percentage), .groups = NULL) %>%
  ggplot()+
  geom_col(aes(x= Stratification, y = AvgStratPerc, fill = Behavior  ), position = "dodge") +
  scale_fill_manual(values = QsCol) +
  scale_x_discrete(guide = guide_axis(angle = 45)) +
  labs(x = "Stratification",
       y = "Population %") +
  theme_light() 
  

StratCategory


mapDF = JoinDF %>% group_by (., State, Behavior) %>% 
  filter(., !is.na(Behavior) ) %>%
  summarize(.,`Population Percentage`= mean(Percentage))


mapDF$`Population Percentage`[(mapDF$Behavior == "Obesity")]


G1 = gvisGeoChart(JoinDF, "State", "Percentage", 
                  options=list(region="US", 
                               displayMode="regions", 
                               resolution="provinces",
                               width="auto", height="auto"))

G1



mapDF = JoinDF %>% group_by (., State, Behavior) %>% 
  filter(., !is.na(Behavior) ) %>%
  summarize(., PopulationPercentage = mean(Percentage)) %>%
  pivot_wider(., names_from = Behavior, values_from = PopulationPercentage)





CauseOfDeath %>%
  select(., Cause.Name, Age.adjusted.Death.Rate, Year) %>%
  filter(., !is.na(Age.adjusted.Death.Rate), !is.na(Cause.Name), !(Cause.Name =="All causes"), Year %in% c("2011", "2012","2013","2014","2015","2016","2017")) %>%
  group_by(., Cause.Name) %>%
  summarise(., AvgTotalRate = mean(Age.adjusted.Death.Rate)) %>%
  arrange(., desc(AvgTotalRate))
 

unique(JoinDF$Education)


CauseBeha_splot
