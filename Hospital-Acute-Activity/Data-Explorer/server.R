#Syntax to create the data explorer
#Jaime Villacampa October 17

#TODO:
#Fix issues with selection of dates (max date and order)
#Order quarter variable in tables based on date (use date variable instead?)
#Add visualization for specialty (time trend, bar chart)

#Figure out colors scale for map/fix legend image
# Make map outpatients work (need to check raw data, add switch or merge datasets)
# Include los, dna rate and avlos in map, deprivation, age-sex?

# Include bed time trend might require merging datasets
#Fix formatting numbers tooltip
#Set labels for time trend (to avoid cases with decimals)

#Alignment download boxes
#Think about color palette for trend

############################.
## Server ----
############################.

function(input, output) {
  
  ##############################################.             
  ##############Time trend----   
  ##############################################.  
  #Reactive dropdowns for this tab
  #They will provide a list of locations filtered by geography type
  output$geotype_ui_trend <- renderUI({
    selectInput("geotype_trend", label = "Select the type of location", 
                choices = geo_types_trend, selected =  "Scotland")
  })
  
  output$locname_ui_trend <- renderUI({
    selectInput("locname_trend", "Select the location", 
                choices =unique(data_trend$loc_name[data_trend$geo_type == input$geotype_trend]),
                selectize = TRUE, selected = "Scotland")
  })
  
  #Reactive datasets
  #reactive dataset for the trend plot

  data_trend_plot <- reactive({
    data_trend %>% 
      subset(loc_name == input$locname_trend & measure %in% input$service_trend &
               geo_type == input$geotype_trend) %>% 
      rename("Total length of stay (days)" = los, "Mean length of stay (days)" = avlos,
             "Number of stays/appointments" = count, "Did not attend rate (%)" = rate)
      
    })

  #Table data
  table_trenddata <- reactive({
    data_trend %>% 
      subset(loc_name == input$locname_trend & measure %in% input$service_trend &
               geo_type == input$geotype_trend) %>% 
      select(c(loc_name, quarter_name, measure, count, rate, los, avlos))

    
  })
  
  #Plotting 
  output$trend_plot <- renderPlotly({
    #If no data available for that quarter then plot message saying data is missing
    if (is.data.frame(data_trend_plot()) && nrow(data_trend_plot()) == 0)
    {
      #plotting empty plot just with text
      text_na <- list(x = 5, y = 5, text = "No data available" ,
                      xref = "x", yref = "y",  showarrow = FALSE)
      
      plot_ly() %>%
        layout(annotations = text_na,
               #empty layout
               yaxis = list(showline = FALSE, showticklabels = FALSE, showgrid = FALSE),
               xaxis = list(showline = FALSE, showticklabels = FALSE, showgrid = FALSE)) %>% 
        config( displayModeBar = FALSE) # taking out plotly logo and collaborate button
      
    }
    else {

    #Text for tooltip
    tooltip <- c(paste0(data_trend_plot()$measure, "<br>",
                        data_trend_plot()$quarter_name, "<br>",
                        input$measure_trend, ": ", data_trend_plot()[[input$measure_trend]]))

    #Plotting time trend
    plot_ly(data=data_trend_plot(), x=~quarter_date2, 
            y = ~get(input$measure_trend), 
            text=tooltip, hoverinfo="text",
            type = 'scatter', mode = 'lines+markers',
            color=~measure, colors = trend_pal) %>% 
      #Layout
      layout(annotations = list(), #It needs this because of a buggy behaviour
             yaxis = list(title = input$measure_trend, rangemode="tozero"), 
             xaxis = list(title = "Time period"),  #axis parameter
             hovermode = 'false') %>%  # to get hover compare mode as default
      config(displaylogo = F, collaborate=F, editable =F) # taking out plotly logo and collaborate button
    }
    
    }) 

  ######Table
  output$table_trend <- DT::renderDataTable({
    DT::datatable(table_trenddata(), style = 'bootstrap', class = 'table-bordered table-condensed', rownames = FALSE,
                  options = list(pageLength = 16, dom = 'tip'),
                  colnames = c("Location", "Quarter", "Type of activity", "Number", "DNA rate",
                               "Total length of stay", "Mean length of stay")  
    )
  })
  
  #####################################.    
  #### Downloading data ----
  output$download_trend <- downloadHandler(
    filename =  'trend_data.csv',
    content = function(file) {
      write.csv(data_trend_plot(), file) 
    }
  )
  
  ##############################################.             
  ##############Population pyramid----   
  ##############################################.  
  #Reactive dropdowns for this tab
  #They will provide a list of locations filtered by geography type
  output$geotype_ui_pyramid <- renderUI({
    selectInput("geotype_pyramid", label = "Select the type of location", 
                choices = geo_types, selected =  "Scotland")
  })
  
  output$locname_ui_pyramid <- renderUI({
    selectInput("locname_pyramid", "Select the location", 
                choices =unique(data_pyramid$loc_name[data_pyramid$geo_type == input$geotype_pyramid]),
                selectize = TRUE, selected = "Scotland")
  })
  
  #Reactive datasets
  data_pyramid_plot <- reactive({data_pyramid %>% 
      subset(loc_name == input$locname_pyramid & 
               measure == input$measure_pyramid &
               geo_type == input$geotype_pyramid &
               quarter_name == input$quarter_pyramid) %>% 
      mutate(count = ifelse(sex=="Male", -(count), count)) # so it plots correcttly and no stacked bars
  })
  
  #Table data
  data_table_pyramid <- reactive({
    data_pyramid_plot() %>% 
      select(loc_name, quarter_name, measure, age, sex, count) %>% 
      mutate(count = abs(count)) #to go back to positive values
  })
  
  #Plotting pyramid population chart
  output$pyramid_plot <- renderPlotly({
    #If no data available for that quarter then plot message saying data is missing
    if (is.data.frame(data_pyramid_plot()) && nrow(data_pyramid_plot()) == 0)
    {
    #plotting empty plot just with text
    text_na <- list(x = 5, y = 5, text = "No data available" ,
      xref = "x", yref = "y",  showarrow = FALSE)
    
    plot_ly() %>%
      layout(annotations = text_na,
             #empty layout
             yaxis = list(showline = FALSE, showticklabels = FALSE, showgrid = FALSE),
             xaxis = list(showline = FALSE, showticklabels = FALSE, showgrid = FALSE)) %>% 
      config( displayModeBar = FALSE) # taking out plotly logo and collaborate button
      
    }
    else {
    #Breaks and labels for plot
    breaks <- round(max(abs(data_pyramid_plot()$count))/3)
    max <- round(max(abs(data_pyramid_plot()$count)))
    
    #Calculate breaks and labels for x axis
    brks <- c(seq(-max, 0, breaks), seq(breaks, max, breaks))
    lbls <- paste0(as.character(c(-seq(-max, 0, breaks), 
                                  seq(breaks, max, breaks))))
    
    #Text for tooltip
    tooltip_pyr <- c(paste0(data_pyramid_plot()$sex, " ", data_pyramid_plot()$age, "<br>",
                           "Number: ", abs(data_pyramid_plot()$count)))
    
    plot_ly(data=data_pyramid_plot(), x= ~count, y=~age, color=~sex, colors = trend_pal,
            text=tooltip_pyr, hoverinfo="text") %>% 
      add_bars(orientation = 'h') %>%
      layout(bargap = 0.1, barmode = 'overlay',
             yaxis = list(title = "Age"), 
             xaxis = list(tickmode = 'array', tickvals = brks,
                          ticktext = lbls, showline = TRUE,
                          title = paste("Number of", input$measure_pyramid))) %>% 
      config(displaylogo = F, collaborate=F, editable =F) # taking out plotly logo and collaborate button
    
    }
  }) 

  ######Table
  output$table_pyramid <- DT::renderDataTable({
    DT::datatable(data_table_pyramid(), style = 'bootstrap', class = 'table-bordered table-condensed', rownames = FALSE,
                  options = list(pageLength = 20, dom = 'tip'),
                  colnames = c("Location", "Quarter", "Type of activity", "Age", "Sex", "Number")  
    )
  })
  
  #####################################.    
  #### Downloading data ----
  output$download_pyramid <- downloadHandler(
    filename =  'agesex_data.csv',
    content = function(file) {
      write.csv(data_pyramid_plot(), file) 
    }
  )
  
  ##############################################.             
  ##############Deprivation simd----   
  ##############################################.  
  #Reactive dropdowns for this tab
  #They will provide a list of locations filtered by geography type
  output$geotype_ui_simd <- renderUI({
    selectInput("geotype_simd", label = "Select the type of location", 
                choices = geo_types, selected =  "Scotland")
  })
  
  output$locname_ui_simd <- renderUI({
    selectInput("locname_simd", "Select the location", 
                choices =unique(data_simd$loc_name[data_simd$geo_type == input$geotype_simd]),
                selectize = TRUE, selected = "Scotland")
  })
  
  #Reactive datasets
  #reactive dataset for the simd plot
  data_simd_plot <- reactive({data_simd %>% 
      subset(loc_name == input$locname_simd & 
               measure == input$measure_simd &
               geo_type == input$geotype_simd &
               quarter_name == input$quarter_simd) 
  })
  
  #Table data
  data_table_simd <- reactive({
    data_simd_plot() %>% 
      select(loc_name, quarter_name, measure, simd, count, rate, avlos)
  })
  
  #Plotting simd bar chart
  output$simd_plot <- renderPlotly({
    #If no data available for that quarter then plot message saying data is missing
    if (is.data.frame(data_simd_plot()) && nrow(data_simd_plot()) == 0)
    {
      #plotting empty plot just with text
      text_na <- list(x = 5, y = 5, text = "No data available" ,
                      xref = "x", yref = "y",  showarrow = FALSE)
      
      plot_ly() %>%
        layout(annotations = text_na,
               #empty layout
               yaxis = list(showline = FALSE, showticklabels = FALSE, showgrid = FALSE),
               xaxis = list(showline = FALSE, showticklabels = FALSE, showgrid = FALSE)) %>% 
        config( displayModeBar = FALSE) # taking out plotly logo and collaborate button
      
    }
    else {
    
    #Text for tooltip
    tooltip_simd <- c(paste0("Quintile: ", data_simd_plot()$simd, "<br>",
                            "Number: ", abs(data_simd_plot()$count)))
    
    plot_ly(data=data_simd_plot(), x=~simd , y=~count,
            text=tooltip_simd, hoverinfo="text") %>% 
      add_bars(marker = list(color = "#004785")) %>%
      layout(bargap = 0.1, 
             yaxis = list(title = paste("Number of", input$measure_simd)), 
             xaxis = list(showline = TRUE, title = "Deprivation (SIMD) quintile")) %>% 
      config(displaylogo = F, collaborate=F, editable =F) # taking out plotly logo and collaborate button
    }
  }) 
  
  ######Table
  output$table_simd <- DT::renderDataTable({
    DT::datatable(data_table_simd(), style = 'bootstrap', class = 'table-bordered table-condensed', rownames = FALSE,
                  options = list(pageLength = 20, dom = 'tip'),
                  colnames = c("Location", "Quarter", "Type of activity", "SIMD quintile", 
                               "Number", "DNA rate", "Mean length of stay")  
    )
  })
  
  #####################################.    
  #### Downloading data ----
  output$download_simd <- downloadHandler(
    filename =  'deprivation_data.csv',
    content = function(file) {
      write.csv(data_simd_plot(), file) 
    }
  )
  
  ##############################################.             
  ##############Map ----   
  ##############################################.     
  ###SECTION NOT IN USE AT THE MOMENT, STILL REQUIRES WORK AND RATE DATA  
  #Merging shapefile with dynamic selection of data
  #First for HB
#   hb_pol <- reactive({merge(hb_bound, 
#                             data_mapipdc %>% subset(quarter_name==input$quarter_map
#                                                     & measure==input$measure_map
#                                                     & value_type == input$value_map
#                                                     & substr(loc_name,1,3)=="NHS") %>% #selecting only HB 
#                               droplevels() %>% #dropping missing factor levels to allow merging
#                               rename(HBCode=loc_code), 
#                             by='HBCode') 
#   })   
#   
#   #Now for CA
#   ca_pol <- reactive({merge(ca_bound, 
#                             data_mapipdc %>% subset(quarter_name==input$quarter_map
#                                                     & measure==input$measure_map
#                                                     & value_type == input$value_map
#                                                     & substr(loc_name,1,3)!="NHS") %>% #selecting only HB 
#                               droplevels() %>% #dropping missing factor levels to allow merging
#                               rename(GSS_COD=loc_code) , 
#                             by='GSS_COD')
#   }) 
#   
#   
#   #Palettes for map.
#   pal_hb <- reactive({
#     colorQuantile(c('#004785','#00a2e5', '#99b5ce',  '#99daf5'), hb_pol()$value, n=4)
#   }) 
#   pal_ca <- reactive({
#     colorQuantile(c('#004785','#00a2e5', '#99b5ce',  '#99daf5'), ca_pol()$value, n=4)
#   }) 
#   
#   #title
#   output$title_map <- renderText(paste("Hospital acute care activity - ", input$measure_map, 
#                                        " during ", input$quarter_map))
#   
#   #Plotting map
#   
#   output$map <- renderLeaflet({
#     leaflet() %>% 
#       setView(-5, 56.33148888, zoom = 10) %>% # setting initial view point
#       fitBounds(-7.0, 60.5, 0.25, 55.8)  %>% #limits of map
#       setMaxBounds(-9.0, 62.5, 2.25, 53)  %>% #limits of map
#       addProviderTiles(providers$CartoDB.Positron) %>% #background map
#       #Adding layer control
#       addLayersControl( 
#         baseGroups = c("Health Board", "Council Area"),
#         options = layersControlOptions(collapsed = FALSE)
#       )
#   })
#   #Creating observer to avoid redrawing of map everytime 
#   #a different option (time, measure) is chosen
#   observe({
#     
#     leafletProxy("map") %>%
#       clearShapes() %>% 
#       #Adding polygons with HB
#       addPolygons(data=hb_pol(),  group="Health Board",
#                   color = "#444444", weight = 2, smoothFactor = 0.5, 
#                   label = sprintf(hb_pol()$labs) %>% lapply(HTML), #tooltip for hovering
#                   labelOptions = labelOptions(direction = "left"),
#                   opacity = 1.0, fillOpacity = 0.5,
#                   fillColor = ~pal_hb()(value), # palette
#                   highlightOptions = highlightOptions(color = "white", weight = 2,
#                                                       bringToFront = FALSE) #For highlighting the selection while hovering
#       )%>% 
#       #Adding polygons with HB rate 
#       addPolygons(data=ca_pol(), group="Council Area",
#                   color = "#444444", weight = 2, smoothFactor = 0.5, 
#                   label = sprintf(ca_pol()$labs) %>% lapply(HTML), #tooltip for hovering
#                   labelOptions = labelOptions(direction = "left"),
#                   opacity = 1.0, fillOpacity = 0.5,
#                   fillColor = ~pal_ca()(value), # palette
#                   highlightOptions = highlightOptions(color = "white", weight = 2,
#                                                       bringToFront = FALSE) #For highlighting the selection while hovering
#       ) 
#   })
#   
#   #####################################.    
#   #### Table ----
#   
#   #Table data
#   table_mapdata <- reactive({
#     data_mapipdc %>% subset(quarter_name==input$quarter_map & measure==input$measure_map) %>% 
#       select(loc_name, quarter_name, measure, value_type, value) %>% 
#       dcast(loc_name+quarter_name+measure~value_type, fun.aggregate=sum)
#     
#   })
#   
#   #Actual table.
#   output$table_map <- DT::renderDataTable({
#     DT::datatable(table_mapdata(),style = 'bootstrap', class = 'table-bordered table-condensed', rownames = FALSE,
#                   options = list(pageLength = 14, dom = 'tip'),
#                   colnames = c("Location", "Quarter", "Measure", "Admissions", "Crude Rate")  
#     )
#   })
#   
#   #####################################.    
#   #### Downloading data ----
#   output$download_map <- downloadHandler(
#     filename =  'map_data.csv',
#     content = function(file) {
#       write.csv(data_mapipdc, file) 
#     }
#   )
  
  ##############################################.             
  ##############Cross-boundary ----   
  ##############################################.     
  #Reactive data
  #Creating dynamic selection of dataset.
  data_flow <- reactive({switch(input$datatype_flow,
                                "Inpatients/Day cases" = data_cbfip,
                                "Outpatients" = data_cbfop
  )})
  
  
  #For all HB
  flow_all <- reactive({
    if(input$checkbox_flow == FALSE) {data_flow() %>% 
        subset(quarter_name==input$quarter_flow & count>9 & boundary_ind == 1)
    } else {data_flow() %>% subset(quarter_name==input$quarter_flow & count>9)
    }
  })   
  
  # For only selected HB of residence
  flow_res <- reactive({
    if(input$checkbox_flow == FALSE) {data_flow() %>% 
        subset(quarter_name==input$quarter_flow & hbres_name==input$hb_flow & boundary_ind == 1)
    } else {data_flow() %>% subset(quarter_name==input$quarter_flow & hbres_name==input$hb_flow)
    }
  })   
  
  # For only selected HB of treatment
  flow_treat <- reactive({
    if(input$checkbox_flow == FALSE) {data_flow() %>% 
        subset(quarter_name==input$quarter_flow & hbtreat_name==input$hb_flow & boundary_ind == 1)
    } else {data_flow() %>% subset(quarter_name==input$quarter_flow & hbtreat_name==input$hb_flow)
    }
  })   
  
  ############################.
  # Text
  output$crossb_restext <- renderText({
    flow_textres <- data_flow() %>% 
      subset(quarter_name == input$quarter_flow & hbres_name == input$hb_flow)
    #Percentage of people treated in their own hb
    value_res <- round(flow_textres$count[flow_textres$boundary_ind == 0] / 
                         sum(flow_textres$count) * 100, 1)

  paste0("<b>", value_res, "</b>", "% of the patients from ", input$hb_flow, 
         " were treated in their own health board area.")
  })
  
  output$crossb_treattext <- renderText({
    flow_texttreat <- data_flow() %>% 
      subset(quarter_name == input$quarter_flow & hbtreat_name == input$hb_flow)
    #Percentage of people treated in this hb coming from other hb
    value_treat <- round(sum(flow_texttreat$count[flow_texttreat$boundary_ind == 1]) / 
                           sum(flow_texttreat$count) * 100, 1)
    
    paste0("<b>", value_treat, "</b>", "% of the patients treated in ",
           input$hb_flow, " live in other health board areas.")
  })
  
  ############################.
  # Visualizations
  # This one with all HB at the same time.
  output$sankey_all <- renderGvis({
    
    options(gvis.plot.tag=NULL) #if changed to chart you will get the html code
    gvisSankey(flow_all()[,c('hbres_name','hbtreat_name2','count')],
               options = list(width = "automatic", sankey=opts
               ))
    
  })
  
  #This one with only the selected hb of residence
  output$sankey_res <- renderGvis({
    
    gvisSankey(flow_res()[,c('hbres_name','hbtreat_name2','count')],
               options = list(width = "automatic",
                              gvis.plot.tag=NULL))#if changed to chart you will get the html code
    
  })
  
  #This one with only the selected hb of treatment
  output$sankey_treat <- renderGvis({
    
    gvisSankey(flow_treat()[,c('hbres_name','hbtreat_name2','count')],
               options = list(width = "automatic",
                              gvis.plot.tag=NULL))#if changed to chart you will get the html code
    
  })
  
  #####################################.    
  ### Table ----
  
  #Table data
  table_cbfdata <- reactive({
    #This if statement selects what data to show depending on the checkbox status
    if(input$checkbox_flow == FALSE) {data_flow() %>% 
        subset(quarter_name==input$quarter_flow  & boundary_ind == 1
               & (hbtreat_name==input$hb_flow | hbres_name==input$hb_flow)) %>% 
        select(hbres_name, hbtreat_name, quarter_name, count)
      
    } else {data_flow() %>% subset(quarter_name==input$quarter_flow & 
                                     (hbtreat_name==input$hb_flow | hbres_name==input$hb_flow)) %>% 
        select(hbres_name, hbtreat_name, quarter_name, count)
    }
  })
  
  #Actual table.
  output$table_crossb <- DT::renderDataTable({
    DT::datatable(table_cbfdata(),style = 'bootstrap', class = 'table-bordered table-condensed', rownames = FALSE,
                  options = list(pageLength = 10, dom = 'tip'),
                  colnames = c("Residence board", "Treatment board",  "Quarter", "Number")  
    )
  })
  
  #####################################.    
  #### Downloading data ----
  output$download_flow <- downloadHandler(
    filename =  'crossb_flow_data.csv',
    content = function(file) {
      write.csv(table_cbfdata()(), file) 
    }
  )
  
  ##############################################.             
  ##############Table----   
  ##############################################.  
  #Very simple approach, changing file with a switch, there might be better solutions
  #Formats every dataset to what it requires for the table
  data_table <- reactive({switch(input$filename_table,
                                 "Beds" = data_bed %>% 
                                   rename(Area_name = loc_name,
                                          Specialty = specname,
                                          Time_period = quarter_name,
                                          Occupancy_percentage = p_occ,
                                          All_avail_beds = aasb),
                                "Inpatients/Day cases - Cross boundary flow" = data_cbfip %>% 
                                  select(hbres_name, hbtreat_name, quarter_name, count) %>% 
                                  rename(Health_board_residence = hbres_name,
                                         Health_board_treatment = hbtreat_name,
                                         Time_period = quarter_name,
                                         Stays = count),
                                "Inpatients/Day cases - Time trend" = data_trend %>% 
                                  subset(file == "Inpatients/Day Cases") %>% 
                                  select(geo_type, loc_name, measure, quarter_name, 
                                         count, los, avlos) %>% 
                                  rename(Geography_level = geo_type,
                                         Area_name = loc_name,
                                         Type_case = measure,
                                         Time_period = quarter_name,
                                         Stays = count,
                                         Total_length_stay = los,
                                         Mean_length_stay = avlos), 
                                "Inpatients/Day cases - Age/sex" = data_pyramid %>% 
                                  subset(file == "Inpatients/Day Cases") %>% 
                                  select(geo_type, loc_name, measure, sex, age, quarter_name, 
                                         count, los, avlos) %>% 
                                  rename(Geography_level = geo_type,
                                         Area_name = loc_name,
                                         Type_case = measure,
                                         Sex = sex,
                                         Age_group = age,
                                         Time_period = quarter_name,
                                         Stays = count,
                                         Total_length_stay = los,
                                         Mean_length_stay = avlos) %>% 
                                  mutate(Stays = abs(Stays)) %>% 
                                  droplevels(),
                                "Outpatients - Age/sex" = data_pyramid %>% 
                                  subset(file == "Outpatients") %>% 
                                  select(geo_type, loc_name, measure, sex, age, quarter_name, 
                                         count, rate) %>% 
                                  rename(Geography_level = geo_type,
                                         Area_name = loc_name,
                                         Type_case = measure,
                                         Sex = sex,
                                         Age_group = age,
                                         Time_period = quarter_name,
                                         Appointments = count,
                                         DNA_rate = rate) %>% 
                                  mutate(Appointments = abs(Appointments)) %>% 
                                  droplevels(),
                                "Inpatients/Day cases - Specialty" = data_spec %>% 
                                  subset(file == "Inpatients/Day Cases") %>% 
                                  select(geo_type, loc_name, measure, specialty, quarter_name, 
                                         stays, los, avlos) %>% 
                                  rename(Geography_level = geo_type,
                                         Area_name = loc_name,
                                         Type_case = measure,
                                         Specialty = specialty,
                                         Time_period = quarter_name,
                                         Stays = stays,
                                         Total_length_stay = los,
                                         Mean_length_stay = avlos) %>% 
                                  droplevels(),
                                "Outpatients - Specialty" = data_spec %>% 
                                  subset(file == "Outpatients") %>% 
                                  select(geo_type, loc_name, measure, specialty, quarter_name, 
                                         count, rate) %>% 
                                  rename(Geography_level = geo_type,
                                         Area_name = loc_name,
                                         Type_case = measure,
                                         Specialty = specialty,
                                         Time_period = quarter_name,
                                         Appointments = count,
                                         DNA_rate = rate) %>% 
                                  droplevels(), 
                                "Inpatients/Day cases - Deprivation (SIMD)" = data_simd %>% 
                                  subset(file == "Inpatients/Day Cases") %>% 
                                  select(geo_type, loc_name, measure, simd, quarter_name, 
                                         count, los, avlos) %>% 
                                  rename(Geography_level = geo_type,
                                         Area_name = loc_name,
                                         Type_case = measure,
                                         SIMD_quintile = simd,
                                         Time_period = quarter_name,
                                         Stays = count,
                                         Total_length_stay = los,
                                         Mean_length_stay = avlos) %>% 
                                  droplevels(),
                                "Outpatients - Deprivation (SIMD)" = data_simd %>% 
                                  subset(file == "Outpatients") %>% 
                                  select(geo_type, loc_name, measure, simd, quarter_name, 
                                         count, rate) %>% 
                                  rename(Geography_level = geo_type,
                                         Area_name = loc_name,
                                         Type_case = measure,
                                         SIMD_quintile = simd,
                                         Time_period = quarter_name,
                                         Appointments = count,
                                         DNA_rate = rate) %>% 
                                  droplevels(), 
                                "Outpatients - Cross boundary flow" = data_cbfop %>% 
                                  select(hbres_name, hbtreat_name, quarter_name, count) %>% 
                                  rename(Health_board_residence=hbres_name,
                                         Health_board_treatment=hbtreat_name,
                                         Time_period=quarter_name,
                                         Appointments=count),
                                "Outpatients - Time trend" = data_trend %>% 
                                  subset(file == "Outpatients") %>% 
                                  select(geo_type,loc_name, quarter_name, measure, 
                                         count, rate) %>% 
                                  rename(Geography_level = geo_type,
                                         Area_name = loc_name,
                                         Time_period = quarter_name,
                                         Type_case = measure,
                                         Appointments = count,
                                         DNA_rate = rate)

  )})
  
  #Actual table.
  output$table_explorer <- DT::renderDataTable({
    #to take out underscore from column names shown in table.
    table_colnames  <-  gsub("_", " ", colnames(data_table()))
    
    DT::datatable(data_table(),style = 'bootstrap', class = 'table-bordered table-condensed', 
                  rownames = FALSE, options = list(pageLength = 20, dom = 'tip'), 
                  filter = "top", colnames = table_colnames
    )
  })
  
  #####################################.    
  #### Downloading data ----
  #It downloads selection made by user using the datatable filters
  output$download_table <- 
    downloadHandler(filename = "table_data.csv",
                    content = function(file){
                      write.csv(data_table()[input[["table_explorer_rows_all"]], ],
                                file)
                    }
    )
  
}

###END

