
mapDF = JoinDF %>% group_by (., State, Behavior) %>% 
    filter(., !is.na(Behavior) ) %>%
    summarize(., PopulationPercentage = mean(Percentage)) %>%
    pivot_wider(., names_from = Behavior, values_from = PopulationPercentage)

mapDF

shinyServer(function(input, output){
   
     # show map using googleVis
    output$map <- renderGvis({
        
        gvisGeoChart(mapDF, "State", input$selectedBehavior, 
                     options=list(region="US", 
                                  displayMode="regions", 
                                  resolution="provinces",
                                  width="auto", height="auto"))
        
    })
    
    # show correlation graph in MAP
    output$CauseBehaCor_plot <- renderPlot({ 
        
        JoinDF %>%
            select(., State, CauseDeath, Behavior, Percentage, Rate) %>%
            filter(., !is.na(Rate),!is.na(Percentage),!is.na(Behavior),
                   !is.na(CauseDeath) ) %>%
            group_by(., CauseDeath, Behavior, State) %>%
            summarise(., avgPercent = mean (Percentage), avgRate = mean(Rate),
                    .groups = "keep" ) %>%
            group_by(., CauseDeath, Behavior) %>%
            summarise(., Corr = cor (avgPercent, avgRate, use = "everything")) %>%
            arrange(., desc(Corr)) %>%
            mutate(Behavior = fct_reorder(Behavior, Corr)) %>%
            ggplot(aes()) +
            geom_col(aes(x = CauseDeath, y = Corr, fill = Behavior), position = "dodge") +
            scale_fill_manual(values = BehaviorCol) +
            scale_y_continuous(limits = c(-.9, .9),
                               breaks = seq (-.8, .8, 0.2)) +
            scale_x_discrete(guide = guide_axis(angle = 45)) +
            labs(x = "Cause of Death",
                 y = "Correlation") +
            theme_light()
    
    })
    
    # show Cause of Death vs Rate graph in State
    output$CauseDeath_plot <- renderPlot({ 
        
        JoinDF %>%
            filter(., Year == "2017" , State ==  input$selectedState)%>%
            mutate(CauseDeath = fct_reorder(CauseDeath, desc(Rate)))%>%
            ggplot(aes( fill = CauseDeath)) +
            geom_bar( aes( x = CauseDeath, y = Rate), stat = "Identity", position = "dodge") +
            theme_light()+
            theme( legend.position = "none") +
            scale_fill_manual(values = CofDeathCol) +
            scale_x_discrete(guide = guide_axis(angle = 45))+
            labs(x = "Cause of Death",
                 y = "Death rate")
    
    })
    
    # show Cause of Death over time
    output$DeathOverTime_plot <- renderPlot({
        JoinDF %>% 
            group_by(., CauseDeath , State, Year) %>%
            filter(., State == input$selectedState ) %>%
            mutate(., Year = as.factor(Year)) %>%
            summarise(., AvgRate = mean(Rate)) %>%
            ggplot(aes(group = CauseDeath) )+
            geom_line(aes( x = Year, y = AvgRate, color = CauseDeath), size = 1 ) +
            scale_color_manual(values = CofDeathCol)  +
            labs(x = "Year",
                 y = "Death rate") +
            theme_light() +
            theme(legend.position = "bottom", legend.title = element_blank())
    })
    
    # show Population % with the Behavior in Stratification
    
    output$BehaviorStrat_plot <- renderPlot({
    
        JoinDF %>%
            filter(., State == input$selectedState2 , StratificationCategory == input$StratificationCategory, !is.na(Behavior)) %>%
            group_by(., Stratification , Behavior) %>%
            summarise(., AvgStratPerc = mean(Percentage), .groups = NULL) %>%
            ggplot()+
            geom_col(aes(x= Stratification, y = AvgStratPerc, fill = Behavior  ), position = "dodge") +
            scale_fill_manual(values = QsCol) +
            scale_x_discrete(guide = guide_axis(angle = 45)) +
            labs(x = "Stratification",
                 y = "Population %") +
            theme_light()     
    
        
    })
        
        
    # show data using DataTable
    output$table <- DT::renderDataTable({
        datatable(state_stat, rownames=FALSE) %>% 
            formatStyle(input$selected, background="skyblue", fontWeight='bold')
    })
    
    # show statistics using infoBox
    output$maxBox <- renderInfoBox({
        max_value <- max(state_stat[,input$selected])
        max_state <- 
            state_stat$state.name[state_stat[,input$selected] == max_value]
        infoBox(max_state, max_value, icon = icon("hand-o-up"))
    })
    output$minBox <- renderInfoBox({
        min_value <- min(state_stat[,input$selected])
        min_state <- 
            state_stat$state.name[state_stat[,input$selected] == min_value]
        infoBox(min_state, min_value, icon = icon("hand-o-down"))
    })
    output$avgBox <- renderInfoBox(
        infoBox(paste("AVG.", input$selected),
                mean(state_stat[,input$selected]), 
                icon = icon("calculator"), fill = TRUE))
})