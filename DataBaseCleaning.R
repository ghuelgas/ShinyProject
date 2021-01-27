library(dplyr)


CauseOfDeath = read.csv("DataBases/NCHS_-_Leading_Causes_of_Death__United_States.csv")

HealthHabits = read.csv(
  "DataBases/Nutrition__Physical_Activity__and_Obesity_-_Behavioral_Risk_Factor_Surveillance_System.csv"
)

#Delete columns that won't be useful for analysis

CauseOfDeath = CauseOfDeath %>% select(., -X113.Cause.Name)
head(CauseOfDeath)


#Check if data values and alt are redundant
DataValues = HealthHabits %>%
  filter(., !is.na(Data_Value)) %>%
  mutate(., redundant = ifelse(Data_Value == Data_Value_Alt, 0, 1)) %>%
  summarise(., n_red = sum(redundant)) #They are, so delete Data_Value_Alt

YearValues = HealthHabits %>%
  filter(., !is.na(YearStart)) %>%
  mutate(., redundant = ifelse(YearStart == YearEnd, 0, 1)) %>%
  summarise(., n_red = sum(redundant))#They are, so delete YearEnd
#and rename YearStart as Year

unique(HealthHabits$Data_Value_Type)
unique(HealthHabits$Data_Value_Unit)
unique(HealthHabits$Data_Value_Footnote_Symbol)
unique(HealthHabits$Data_Value_Footnote)

#Datasource will be cited, Topic is similar to Class, Location Abbr is not
#needed, DataValueUnit is NA, DataValueType is value, Footnote_symbol is not
#informative, all the ID variables are not informative/redundant
#Add a note, that data NA had insufficient sample size

HealthHabits = HealthHabits %>%
  select(
    .,
    -c(
      Data_Value_Alt,
      YearEnd,
      Datasource,
      Topic,
      LocationAbbr,
      Data_Value_Unit,
      Data_Value_Footnote_Symbol,
      ClassID,
      TopicID,
      QuestionID,
      DataValueTypeID,
      LocationID,
      StratificationCategoryId1,
      StratificationID1,
      Data_Value_Footnote,
      Data_Value_Type
    ),
    Year = YearStart
  )

head(HealthHabits)

#Summarize questions 

unique(HealthHabits$Question)

HealthHabits = HealthHabits %>%
  mutate(., Question = case_when( 
    Question == "Percent of adults aged 18 years and older who have obesity" ~ "Obesity",
    Question =="Percent of adults aged 18 years and older who have an overweight classification" ~ "Overweight",
    Question =="Percent of adults who achieve at least 300 minutes a week of moderate-intensity aerobic physical activity or 150 minutes a week of vigorous-intensity aerobic activity (or an equivalent combination)"
    ~ "Vigorous physical activity",
    Question =="Percent of adults who achieve at least 150 minutes a week of moderate-intensity aerobic physical activity or 75 minutes a week of vigorous-intensity aerobic physical activity and engage in muscle-strengthening activities on 2 or more days a week"
    ~"Moderate physical activity",
    Question == "Percent of adults who engage in no leisure-time physical activity" ~ "No physical activity",
    Question == "Percent of adults who engage in muscle-strengthening activities on 2 or more days a week"
    ~"Light physical activity",
    Question == "Percent of adults who report consuming fruit less than one time daily"
    ~ "Low fruit consumtion",
    Question == "Percent of adults who report consuming vegetables less than one time daily" 
    ~"Low vegetable consumtion"
    ))

#Write Data Bases

write.csv(HealthHabits, "DataBases/HealthHabits.csv")

write.csv(CauseOfDeath, "DataBases/CauseOfDeath.csv")

