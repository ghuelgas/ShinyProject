

shinyUI(dashboardPage(
    
    dashboardHeader(title = "Health and behavior", titleWidth = 300),
    
    dashboardSidebar(
        sidebarUserPanel( name = "Menu", image = icon("heartbeat")),
        sidebarMenu(
            menuItem("Map", tabName = "map", icon = icon("map")),
            menuItem("State", tabName = "state", icon = icon("map-pin")),
            menuItem("Behavior", tabName = "behavior", icon = icon("running")),
            menuItem("Data", tabName = "data", icon = icon("database"))
        )
    ),
    
    dashboardBody(
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ),
        tabItems(
            tabItem(tabName = "map",
                    fluidRow(box( title= "Heath effects of our behaviors", status = "primary", solidHeader = TRUE,
                                  "The relationship between the Cause of Death Rates and the incidence of particular behaviors/risk factors in the USA population is represented by a correlation coefficient. A strong nevative linear relation will have a correlation coeffitient close to -1, whereas a strong positive one will be close to 1.",
                                  plotOutput("CauseBehaCor_plot"), width =  12),
                             box(background = "navy", selectizeInput(inputId = "selectedBehavior",
                                                label = "Select Behavior/Risk factor",
                                                choices = colnames(mapDF)[-1]
                                            ), width =  2, height = 500),
                             box(title= sprintf("Percent of adults who present the selected behavior/risk factor"),
                                 background = "navy", solidHeader = TRUE, htmlOutput("map"), width =  10, "The percent values shown here are an average of the data collected from 2011 to 2017.")
                             )
                    ),
            tabItem(tabName = "state",
                    fluidRow(box(selectizeInput(inputId = "selectedState",
                                                label = "Select State",
                                                choices = unique(JoinDF$State)), width = 12)),
                             box(plotOutput("CauseDeath_plot"), width = 6),
                             box(plotOutput("DeathOverTime_plot"), width = 6)
                    ),
            tabItem(tabName = "behavior",
                    fluidRow(box(selectizeInput(inputId = "selectedState2",
                                                label = "Select State",
                                                choices = unique(JoinDF$State)), width = 6),
                             box(selectizeInput(inputId = "StratificationCategory",
                                                label = "Select Stratification Category",
                                                choices = unique(JoinDF$StratificationCategory)), width = 6),
                             box(plotOutput("BehaviorStrat_plot"), height = 300, width = 600))
                    ),
    
            tabItem(tabName = "data",
                    fluidRow(box(DT::dataTableOutput("table"), width = 12))),
        
            tabItem(tabName = "sources",
                fluidRow(box("Centers for Disease Control and Prevention",
                             "https://chronicdata.cdc.gov/Nutrition-Physical-Activity-and-Obesity/Nutrition-Physical-Activity-and-Obesity-Behavioral/hn4x-zwk7",
                             "https://data.cdc.gov/NCHS/NCHS-Leading-Causes-of-Death-United-States/bi63-dtpu"))
                )
)
)
))