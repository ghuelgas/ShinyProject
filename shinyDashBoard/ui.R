

shinyUI(dashboardPage(
    
    dashboardHeader(title = "Heath effects of our behaviors"),
    
    dashboardSidebar(
        sidebarUserPanel( name = "Menu", image = ""),
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
                    fluidRow(box(plotOutput("CauseBehaCor_plot"), width =  600),
                             box(selectizeInput(inputId = "selectedBehavior",
                                                label = "Select Behavior/Risk factor",
                                                choices = colnames(mapDF)[-1]
                                            )),
                             box(htmlOutput("map"), height = 300)
                             )
                    ),
            tabItem(tabName = "state",
                    fluidRow(box(selectizeInput(inputId = "selectedState",
                                                label = "Select State",
                                                choices = unique(JoinDF$State)))),
                             box(plotOutput("CauseDeath_plot")),
                             box(plotOutput("DeathOverTime_plot"))
                    ),
            tabItem(tabName = "behavior",
                    fluidRow(box(selectizeInput(inputId = "selectedState2",
                                                label = "Select State",
                                                choices = unique(JoinDF$State))),
                             box(selectizeInput(inputId = "StratificationCategory",
                                                label = "Select Stratification Category",
                                                choices = unique(JoinDF$StratificationCategory))),
                             box(plotOutput("BehaviorStrat_plot"), height = 300, width = 600))
                    ),
            tabItem(tabName = "data",
                    fluidRow(box(DT::dataTableOutput("table"), width = 12)))
        )
    )
)
)