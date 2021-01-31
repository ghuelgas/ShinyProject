

shinyUI(dashboardPage(
    
    dashboardHeader(title = "Health and behavior", titleWidth = 300),
    
    dashboardSidebar(
        sidebarUserPanel( name = "MENU", img(src="healthy.jpg", height =45 )),
        sidebarMenu(
            menuItem("Home", tabName = "main", icon = icon("home")),
            menuItem("Bevahior and Cause of Death", tabName = "bevahiorAndCause", icon = icon("heart")),
            menuItem("Map", tabName = "map", icon = icon("map")),
            menuItem("State", tabName = "state", icon = icon("map-pin")),
            menuItem("Behavior", tabName = "behavior", icon = icon("running")),
            menuItem("Data", tabName = "data", icon = icon("database")),
            menuItem("Sources", tabName = "sources", icon = icon("book")),
            menuItem("About me", tabName = "aboutme", icon = icon("user-circle"))
        )
    ),
    
    dashboardBody(
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ),
        tabItems(
            
            tabItem(tabName = "main",
                    fluidRow(box(title= "Heath effects of our behaviors", status = "primary", solidHeader = TRUE, width =  12,
                                  p("Chronic diseases, such as heart disease and diabetes, are leading causes of death and disability
                                    in the USA. They are also a leading driver of health care costs(1). Most of these diseases have strong environmental components. 
                                    Hence, we can prevent them by adjusting our behaviors to avoid risk factors and promote healthy lifestyles. Therefore, Health
                                    Organizations are shifting towards the development of care models that encourage disease prevention and health promotion(2).
                                    Here, I analyze the prevalence of specific behaviors linked to leading causes of death with two goals:"),
                                  p("- Help prioritize which behaviors should be addressed with disease-prevention policies and interventions"),
                                  p("- Aid to better allocate the resources where they're needed most, by examining the prevalence of different behaviors 
                                       in a location-specific, population-based manner")),
                             box(img(src="BehaviorsRiskFact.jpg", width = "90%", height = "90%"), status = "primary", width = 12, align="center"),
                             box(title= "References",
                                  p("1. Buttorff C, Ruder T, Bauman M. Multiple Chronic Conditions in the United States, Santa Monica, CA: Rand Corp.; 2017"),
                                  p("2. http://www.emro.who.int/about-who/public-health-functions/health-promotion-disease-prevention.html"), width =  12))
                    ),
            tabItem(tabName = "bevahiorAndCause",
                    fluidRow(box(p("The relationship between the Cause of Death Rates and the incidence of particular behaviors/risk factors in the USA population is represented here by a correlation coefficient. A strong nevative linear relation will have
                                    a correlation coeffitient close to -1, whereas a strong positive one will be close to 1."),
                    plotOutput("CauseBehaCor_plot"),  width =  12))
                    ),
            tabItem(tabName = "map",
                    fluidRow(box( title= "Percent of adults who present the selected behavior/risk factor", status = "primary",
                                  htmlOutput("map", width = "80%", height = "80%"), width =  12, background = "navy", solidHeader = TRUE, 
                                  p("The percent values shown here are an average of the data collected from 2011 to 2017.")),
                             box(background = "navy", selectizeInput(inputId = "selectedBehavior",
                                                                     label = "Select Behavior/Risk factor",
                                                                     choices = colnames(mapDF)[-1]), width =  12))
                    ),
            tabItem(tabName = "state",
                    fluidRow(box(selectizeInput(inputId = "selectedState",
                                                label = "Select State",
                                                choices = unique(JoinDF$State)), width = 12)),
                             box(plotOutput("CauseDeath_plot"), width = 6),
                             box(plotOutput("DeathOverTime_plot"), width = 6),
                             box(p("The death rates are age-adjusted per 100,000 people"), width = 12)
                    ),
            tabItem(tabName = "behavior",
                    fluidRow(box(selectizeInput(inputId = "selectedState2",
                                                label = "Select State",
                                                choices = unique(JoinDF$State)), width = 6),
                             box(selectizeInput(inputId = "StratificationCategory",
                                                label = "Select Stratification Category",
                                                choices = unique(JoinDF$StratificationCategory)), width = 6),
                             box(plotOutput("BehaviorStrat_plot"), width = 12),
                             box(p('The "Population %" represents the average percent, from 2011 to 2017, of adults presenting the specific behavior/risk factor'), width = 12))
                    ),
    
            tabItem(tabName = "data",
                    fluidRow(box(DT::dataTableOutput("table"), width = 12))),
        
            tabItem(tabName = "sources",
                    fluidRow(box(p(h4("Centers for Disease Control and Prevention")),
                             p("https://chronicdata.cdc.gov/Nutrition-Physical-Activity-and-Obesity/Nutrition-Physical-Activity-and-Obesity-Behavioral/hn4x-zwk7"),
                             p("https://data.cdc.gov/NCHS/NCHS-Leading-Causes-of-Death-United-States/bi63-dtpu"), width = 12))
                    ),
            tabItem(tabName = "aboutme",
                    fluidRow(box(img(src="GHM.jpeg", height="20%", width="20%"),
                                 p(h4("Gabriela Huelgas Morales, PhD")),
                                 br(),
                                 p("GitHub : https://github.com/ghuelgas"),
                                 br(),
                                 p("LinkedIn: https://www.linkedin.com/in/gabriela-huelgas-morales-0896b8b3/?locale=en_US"),
                                 br(),
                                 p("GoogleScholar : https://scholar.google.com/citations?user=SG6xGIYAAAAJ&hl=en "), width = 12))
            )
                    )
            ),
    tags$head(tags$style(HTML('* {font-family: "Helvetica"};')))
        ))