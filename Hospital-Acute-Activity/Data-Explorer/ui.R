#Syntax to create the data explorer
#Jaime Villacampa October 17

#TODO:
#see server syntax

############################.
### Visual interface ----
############################.
fluidPage(style="width: 100%; height: 100%; max-width: 1200px; ", 
          tags$head( 
            tags$style( #to avoid red text error messages in the whole app, take out for testing
              type="text/css", ".shiny-output-error { visibility: hidden; }", 
              ".shiny-output-error:before { visibility: hidden; }"
              ) 
            ),

   navbarPage("", # Navigation bar
              
##############################################.             
##############Introduction tab ----   
##############################################.     
    tabPanel("Introduction", icon = icon("info-circle"), style="float: top; height: 95%; 
              width: 95%; background-color:#ffffff; border: 0px solid #ffffff;",
      column(2,
             h3("Data explorer")),
      column(10,
             p("The data explorer allows you to find the data you want and visualise 
               it in different ways. Within each of the following five sections there 
               are filters that let you select the data you are interested in:"),
      tags$ul( 
        tags$li(tags$b("Time trend"), " - shows the data over time."),
        tags$li(tags$b("Age/sex"), " - shows the age and sex distribution of the data."),
        tags$li(tags$b("Deprivation"), " - shows activity across different levels of deprivation."),
        tags$li(tags$b("Cross-boundary flow"), " - shows the relationship between where patients live
                and where they are treated."),
        tags$li(tags$b("Table"), " - allows you to view the data in a table.")
        ),
      p("When using the data explorer please take the following factors into consideration:"),
      tags$ul( 
        tags$li("There can be occasions when there are issues with the quality of the data presented. 
                Known issues are summarised in the ", 
                tags$a(href="http://www.isdscotland.org/tpp/data-quality", "data quality"),
                " section. "),
        tags$li("The data for the most recent quarter is provisional. Provisional data 
                is subject to change in future publications as submissions may be updated 
                to reflect a more accurate and complete set of data from NHS Boards."),
        tags$li("Disclosure control methods have been applied to the data in order to 
                protect patient confidentiality therefore figures may not be additive.")
        ),
      p("If you have any trouble using this tool or you have further questions relating to the data, please contact us at: ",
        tags$b(tags$a(href="mailto:maighread.simpson@nhs.net", "maighread.simpson@nhs.net")),
        " and we will be happy to help.")
      )
    ), 
##############################################.             
##############Time trend tab ----   
##############################################.     
tabPanel("Time trend", icon = icon("line-chart"), style="height: 95%; 
          width: 95%; background-color:#ffffff; border: 0px solid #ffffff;",
          h3("Time trend"),
         p("This section allows you to see changes over time. You can use the filters 
           to select the data you are interested in.  To view the data in a table use 
           the ‘show/hide table’ button. To download your data selection as a csv file 
           use the ‘download data’ button. If you hover over the chart you will see a 
           number of buttons which will allow you to select parts of the chart, zoom in 
           or out or save the chart as an image."),
         wellPanel(tags$style(".well {background-color:#ffffff; border: 0px solid #336699;}"),
                   column(6, uiOutput("geotype_ui_trend")),  
                   column(6, uiOutput("locname_ui_trend")),
                   column(6, 
                selectInput("service_trend", label = "Select type of activity", multiple=TRUE, 
                            choices = trend_service, selectize=TRUE,
                            selected = c("All inpatients and daycases"))),
                column(6, selectInput("measure_trend", label = "Select measure", 
                                      choices = trend_measure, selected = "Number")),
                column(6, downloadButton(outputId = 'download_trend', 
                            label = 'Download data', width= "95%"))  
         ),
         mainPanel(width=12,
         plotlyOutput("trend_plot"),
         #Button to show hide div where data table is
         HTML("<button data-toggle='collapse' href='#trend' class='btn btn-primary'>
                  <strong>Show/hide table</strong></button>"),
         HTML("<div id='trend' class='collapse'> "),
         DT::dataTableOutput("table_trend", width="95%"),
         HTML("</div>")
         )
),
##############################################.             
##############Age-sex tab ----   
##############################################.     
tabPanel("Age/sex", icon = icon("bar-chart"), style="float: top; height: 95%; 
          width: 95%; background-color:#ffffff; border: 0px solid #ffffff;",
         h3("Age/sex"),
         p("This section allows you to explore the age and sex distribution of the data. 
           You can use the filters to select the data you are interested in.  To view the 
           data in a table use the ‘show/hide table’ button. To download your data selection 
           as a csv file use the ‘download data’ button. If you hover over the chart you 
           will see a number of buttons which will allow you to select parts of the chart, 
           zoom in or out or save the chart as an image."),
         wellPanel(
                   column(4, uiOutput("geotype_ui_pyramid")),  
                   column(4, uiOutput("locname_ui_pyramid")),
                   column(4, selectInput("quarter_pyramid", label = "Select the time period", 
                               choices = unique(data_pyramid$quarter_name), 
                               selected = latest_quarter, width= "95%")), 
                   column(9, selectInput("measure_pyramid", label = "Select the type of activity", 
                               choices = pyramid_service, selectize=TRUE,
                               selected = c("All inpatients and daycases"))),
                   column(3, br(), downloadButton(outputId = 'download_pyramid', 
                                            label = 'Download data', width= "95%"))  #For downloading the data
         ),
         mainPanel(width=12,
                   plotlyOutput("pyramid_plot"),
                   #Button to show hide div where data table is
                   HTML("<button data-toggle='collapse' href='#pyramid' class='btn btn-primary'>
                        <strong>Show/hide table</strong></button>"),
                   HTML("<div id='pyramid' class='collapse'> "),
                   DT::dataTableOutput("table_pyramid", width="95%"),
                   HTML("</div>")
                   )
),
##############################################.             
##############Deprivation (SIMD) tab ----   
##############################################.     
tabPanel("Deprivation", icon = icon("user-circle-o"), style="float: top; height: 95%; 
         width: 95%; background-color:#ffffff; border: 0px solid #ffffff;",
         h3("Deprivation"),
         p("This section allows you to explore the data by different levels of ", 
           tags$a(href="http://www.gov.scot/Topics/Statistics/SIMD", "deprivation"), 
           ". You can use the filters to select the data you are interested in. 
           To view the data in a table use the ‘show/hide table’ button. To download 
           your data selection as a csv file use the ‘download data’ button. If you hover 
           over the chart you will see a number of buttons which  will allow you to select 
           parts of the chart, zoom in or out or save the chart as an image."),
         wellPanel(
           column(4, uiOutput("geotype_ui_simd")),  
           column(4, uiOutput("locname_ui_simd")),
           column(4, selectInput("quarter_simd", label = "Select the time period", 
                                 choices = unique(data_simd$quarter_name), 
                                 selected=latest_quarter, width= "95%")), 
           column(9, selectInput("measure_simd", label = "Select the type of activity", 
                                 choices = pyramid_service, selectize=TRUE,
                                 selected = c("All inpatients and daycases"))),
           column(3, downloadButton(outputId = 'download_simd', 
                                    label = 'Download data', width= "95%"))  #For downloading the data
         ),
         mainPanel(width=12,
                   plotlyOutput("simd_plot"),
                   #Button to show/hide div where data table is
                   HTML("<button data-toggle='collapse' href='#simd' class='btn btn-primary'>
                        <strong>Show/hide table</strong></button>"),
                   HTML("<div id='simd' class='collapse'> "),
                   DT::dataTableOutput("table_simd", width="95%"),
                   HTML("</div>")
                   )
),
##############################################.             
##############Map tab ----   
##############################################.    
# 
###SECTION NOT IN USE AT THE MOMENT, STILL REQUIRES WORK AND RATE DATA  
# 
# tabPanel("Map", icon = icon("globe"), style="float: top; height: 95%; width: 95%; 
#           background-color:#ffffff; border: 0px solid #ffffff;",
#          h4(textOutput("title_map")),
#          p("There are marked differences among Scottish regions in the numbers of patients 
#               admitted to hospital or treated as day cases. This map allows to explore this regional
#               differences in total and relative volume of hospital acute care activity in Scotland."),
#          div(style="height: 15%; width: 95%;  background-color:#ffffff; border: 0px solid #ffffff;",
#              column(4,
#               selectInput("datatype_map", label = "Select type of patients:", choices = data_type),
#               selectInput("measure_map", label = "Select category:", 
#                       choices=unique(data_mapipdc$measure), width= "95%"),
#              downloadButton(outputId = 'download_map', label = 'Download data', 
#                             width= "95%")  #For downloading the data
#              ),
#           column(4,   
#             selectInput("value_map", label = "Select measure:", 
#                 choices=c("Admissions", "Crude rate"), width= "95%"),
#             selectInput("quarter_map", label = "Select quarter:", 
#                         choices = unique(data_cbfip$quarter_name), 
#                         selected=tail(data_cbfip$quarter_name, n=1), width= "95%") #to be fixed properly
#             ),
#           column(4,
#             h5(style="font-weight: bold;", "Percentile", width= "95%"),
#             img(src='legend.png', width= "95%", style="vertical-align:middle; max-width:200px")
#         )),
#         div(style="float:left; height: 80%; width: 95%; background-color:#ffffff; border: 0px solid #ffffff;",
#           leafletOutput("map"),
#           HTML("<button data-toggle='collapse' data-target='#map_collaps' class='btn btn-primary'>
#                   <strong>Show/hide table</strong></button>"),
#           HTML("<div id='map_collaps' class='collapse'> "),
#           DT::dataTableOutput("table_map", width="95%"),
#           HTML("</div>"),
#           p("To embed this graphic in your website include this code:"),
#           p("<iframe src='https://scotland.shinyapps.io/hospcare_ipdcmap/' style='border: none; 
#               width: 100%; height: 100%;'></iframe>")
#         )
# ),
##############################################.             
##############Cross boundary tab ----   
##############################################.     
tabPanel("Cross-boundary", icon = icon("exchange"), style="float: top; height: 95%; 
          width: 95%; background-color:#ffffff; border: 0px solid #ffffff;",
         h3("Cross-boundary flow"),
         p("This section allows you to see where patients are treated. The top chart 
           shows where patients living in each NHS Board are treated. The bottom charts 
           show data specific to the NHS Board selected in the ‘Board of Interest’ filter. 
           The left chart shows where patients living in the NHS Board of interest are 
           treated. The right chart shows where patients treated in the NHS Board of 
           interest come from. To exclude patients treated in their own NHS Board from 
           the charts, use the ‘flows within own Health Board’ tick box." ),
         p("You can use the filters to select the data you are interested in. To view the 
           data in a table use the ‘show/hide table’ button. To download your data selection 
           as a csv use the ‘download data’ button. If you hover over the chart you will see 
           a number of buttons which  will allow you to select parts of the chart, zoom in 
           or out or save the chart as an image."),
         wellPanel(
           column(4,
                    selectInput("datatype_flow", label = "Select the hospital service", 
                                choices = data_type),
                  checkboxInput("checkbox_flow", label = "Include flows within same board?", value = FALSE)
             ),
             column(4,  
                    selectInput("hb_flow", label = "Select the board of interest", 
                                choices = unique(data_cbfip$hbres_name)),
                    downloadButton(outputId = 'download_flow', label = 'Download data') 
             ),
             column(4,
                    selectInput("quarter_flow", label = "Select the time period", 
                                choices = unique(data_cbfip$quarter_name), 
                                selected = latest_quarter) 
             )
         ),
         mainPanel(width=12,
                   htmlOutput("sankey_all", width="96%"),
                   br(),
             column(6,  
                    htmlOutput("crossb_restext"),
                    htmlOutput("sankey_res", width="48%")
             ),
             column(6,
                    htmlOutput("crossb_treattext"),
                    htmlOutput("sankey_treat", width="48%")
             ),
         div(style="width:95%; height:5%",
             #Button to show/hide div where data table is
             HTML("<button data-toggle='collapse' data-target='#crossb' 
                  class='btn btn-primary' style=padding: 6px 12px;>
                  <strong>Show/hide table</strong></button>"),
             HTML("<div id='crossb' class='collapse'> "),
             DT::dataTableOutput("table_crossb", width="95%"),
             HTML("</div>")
             )
         )
),
##############################################.             
##############Table tab ----   
##############################################.     
tabPanel("Table", icon = icon("table"), style="float: top; height: 95%; width: 95%; 
          background-color:#ffffff; border: 0px solid #ffffff;",
         h3("Table"),
         p("This section allows you to view the data in table format. You can use the 
           filters to select the  data you are interested in. You can also download the 
           data as a csv using the download buttons."),
         column(8,
          selectInput("filename_table", label = "Select the data file", 
                     choices = file_types, width="95%")
          ),
         column(4,
           downloadButton(outputId = 'download_table', label = 'Download data',
                        style="margin: 25px 10px 25px 10px ")
         ),  
        DT::dataTableOutput("table_explorer", width="95%"),
        #Footnote for Tayside beds data
        conditionalPanel(
          condition = "input.filename_table == 'Beds'",
          p("Beds data file - NHS Tayside data have issues. Please refer to the",
            tags$a(href="http://www.isdscotland.org/tpp/data-quality", "data quality"),
          "section for more information.")
        )
   )
  )
)


