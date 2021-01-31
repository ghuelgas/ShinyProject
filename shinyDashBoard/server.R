

shinyServer(function(input, output){
   
     # show map using googleVis
    output$map <- renderGvis({
        
        gvisGeoChart(mapDF, "State", input$selectedBehavior, 
                     options=list(region="US", 
                                  displayMode="regions", 
                                  resolution="provinces",
                                  width="auto", height="auto",
                                  colorAxis = "{colors:['#E9D6C5', '#593E1A']}")
        )
    })
    
    # show correlation graph in Main
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
    
    
    # show Cause of Death vs Rate graph in State
    
    output$Behavior_plot <-renderPlot({
        JoinDF %>%
            filter(., State == input$selectedState , Year == "2017", !is.na(Behavior))%>%
            mutate(Behavior = fct_reorder(Behavior, desc(Percentage)))%>%
            ggplot(aes( fill = Behavior)) +
            geom_bar( aes( x = Behavior, y = Percentage), stat = "Identity", position = "dodge") +
            theme_light()+
            theme( legend.position = "none") +
            scale_fill_manual(values = BehaviorCol) +
            scale_x_discrete(guide = guide_axis(angle = 45))+
            labs(x = "Behavior/Risk factor",
                 y = "Population %")
        
    })
    
    
    # show Behavior over time
    
    output$BehaviorOverTime_plot <- renderPlot({
        
        JoinDF %>% 
            group_by(., Behavior , State, Year) %>%
            filter(., State == input$selectedState, !is.na(Behavior)) %>%
            summarise(., AvgPercent = mean(Percentage)) %>%
            ggplot(aes(group = Behavior) )+
            geom_line(aes( x = Year, y = AvgPercent, color = Behavior), size = 1 ) +
            scale_color_manual(values = BehaviorCol)  +
            labs(x = "Year",
                 y = "Population %") +
            theme_light() +
            theme(legend.position = "bottom", legend.title = element_blank())
    })
    
    
    # show Population % with the Behavior in Stratification
    
    output$BehaviorStrat_plot <- renderPlot({
    
        JoinDF %>%
            filter(., State == input$selectedState2 , StratificationCategory == input$StratificationCategory,
                   Behavior == input$selectedBehavior2) %>%
            ggplot()+
            geom_boxplot(aes(x= Stratification, y = Percentage , fill = Behavior  )) +
            scale_fill_manual(values = BehaviorCol) +
            scale_x_discrete(guide = guide_axis(angle = 45)) +
            labs(x = NULL,
                 y = "Population %") +
            theme_light()  +
            theme(legend.position = "top", legend.title = element_blank())
    
        
    })
        
        
    # show data using DataTable
    output$table <- DT::renderDataTable({
        datatable(JoinDF, rownames=FALSE) %>% 
            formatStyle(input$selected, background="skyblue", fontWeight='bold')
    })
    
})