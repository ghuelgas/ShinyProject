

shinyUI(dashboardPage(
    
    dashboardHeader(title = "Health and behavior", titleWidth = 300),
    
    dashboardSidebar(
        sidebarUserPanel( name = "MENU", img(src="healthy.jpg", height =45 )),
        sidebarMenu(
            menuItem("Home", tabName = "main", icon = icon("home")),
            menuItem("Bevahior and Cause of Death", tabName = "bevahiorAndCause", icon = icon("file-medical-alt")),
            menuItem("Map", tabName = "map", icon = icon("map")),
            menuItem("Stratification", tabName = "stratification", icon = icon("running")),
            menuItem("State trends", tabName = "state", icon = icon("map-pin")),
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
                    fluidRow(box(title = "Relationship between behavior and cause of death", solidHeader = TRUE, status = "primary",
                                 p("The relationship between the incidence of particular behaviors/risk factors and leading causes of death in the USA population is represented here by a correlation coefficient."),
                    plotOutput("CauseBehaCor_plot"),
                    br(),
                    box( p("A strong nevative linear relation will have a correlation coefficient close to -1, whereas a strong positive one will be close to 1."), background = "navy", width = 6),
                    box( p("Correlation coefficients from -0.4 to 0.4 are so weak that conclusions should not be drawn from them."), background = "navy", width = 6), width =  12))
                    ),
            tabItem(tabName = "map",
                    fluidRow(box(selectizeInput(inputId = "selectedBehavior",
                                                label = "Select Behavior/Risk factor",
                                                choices = colnames(mapDF)[-1]), width =  12, status = "primary"),
                             box( title= "Percent of adults who present the selected behavior/risk factor", solidHeader = TRUE, status = "primary",
                                  htmlOutput("map", width = "70%", height = "70%"), width =  9, 
                                  p("The percent values shown here are an average of the data collected from 2011 to 2017.")),
                             box( p("Once the behavior/risk factor of interest has been selected, we can focus on the geographical location where policy or prevention programs are to be implemented. This map provides insights into which States might need the resources the most.",
                                    ), width = 3, background = "navy")
                            )
                    ),
                        
            tabItem(tabName = "stratification",
                    fluidRow(box(selectizeInput(inputId = "selectedState2",
                                                label = "Select State",
                                                choices = unique(JoinDF$State, width= 3 )), status = "primary"),
                             box(selectizeInput(inputId = "selectedBehavior2",
                                                label = "Select Behavior/Risk factor",
                                                choices = unique(JoinDF$Behavior, width= 3 )), status = "primary"),
                             box(selectizeInput(inputId = "StratificationCategory",
                                                label = "Select Stratification Category",
                                                choices = unique(JoinDF$StratificationCategory, width= 3 )), status = "primary"),
                             box(p("To further focus the scope of the policies or programs to be implemented, here the population is gruped in different Stratification Categories."), background = "navy"),
                             box(plotOutput("BehaviorStrat_plot"), width = 12, status = "primary"),
                             box(p('The "Population %" represents the percent of adults presenting the specific behavior/risk factor'), width = 12)
                             )
                    ),
            
            tabItem(tabName = "state",
                    fluidRow( box(selectizeInput(inputId = "selectedState",
                                                 label = "Select State",
                                                 choices = unique(JoinDF$State)), width = 12, status = "primary"),
                              box(p("This section aims to provide a more detailed insight into the trends of the Behavior and Causes of Death of interest in a specific State"), width = 12, background = "navy" ),
                              tabsetPanel(tabPanel("Cause of Death", 
                                                   box(plotOutput("CauseDeath_plot"), width = 6),
                                                   box(plotOutput("DeathOverTime_plot"), width = 6), status = "primary"),
                                          tabPanel("Behaviors",
                                                   box(plotOutput("Behavior_plot"), width = 6),
                                                   box(plotOutput("BehaviorOverTime_plot"), width = 6), status = "primary"
                                          )
                              )
                    )
            ),
    
            tabItem(tabName = "data",
                    fluidRow(box(DT::dataTableOutput("table"), width = 12))),
        
            tabItem(tabName = "sources",
                    fluidRow(box(p(h4("Centers for Disease Control and Prevention")),
                             br(),
                             p("CDC/NCHS, National Vital Statistics System, mortality data"),
                             p("https://chronicdata.cdc.gov/Nutrition-Physical-Activity-and-Obesity/Nutrition-Physical-Activity-and-Obesity-Behavioral/hn4x-zwk7"),
                             br(),
                             p("Division of Nutrition, Physical Activity, and Obesity"),
                             p("https://data.cdc.gov/NCHS/NCHS-Leading-Causes-of-Death-United-States/bi63-dtpu"), width = 12), status = "primary")
                    ),
            tabItem(tabName = "aboutme",
                    fluidRow(box(img(src="GHM.jpeg", height="20%", width="20%"),
                                 p(h4("Gabriela Huelgas Morales, PhD")),
                                 br(),
                                 p("GitHub : https://github.com/ghuelgas"),
                                 br(),
                                 p("LinkedIn: https://www.linkedin.com/in/gabriela-huelgas-morales-0896b8b3/?locale=en_US"),
                                 br(),
                                 p("GoogleScholar : https://scholar.google.com/citations?user=SG6xGIYAAAAJ&hl=en "), width = 12), status = "primary")
            )
                    )
            ),
    tags$head(tags$style(HTML('* {font-family: "Helvetica"};')))
        ))