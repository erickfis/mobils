#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(rCharts)




# Use a fluid Bootstrap layout
fluidPage(    
        
        # Give the page a title
        titlePanel("Most harmfull events - NOAA Database"),
        
               # Generate a row with a sidebar
        sidebarLayout(

                # Define the sidebar with one input
                sidebarPanel(

                       selectInput("type", "Type of economic losses",
                                   c("Property", "Crops")
                                   ),
                       sliderInput("max",
                                   "Max #  of weather events:",
                                   min = 1,  max = 10,  value = 10)
                ),

                # Create a spot for the barplot
                mainPanel(
                        div(class='wrapper',
                            tags$style(".Nvd3{ height: 600px;"),
                            showOutput("worst","nvd3")
                        )
                )

        ),
        
        
        # fluidRow(
        #         column(width=3,
        #                selectInput("type", "Type of economic losses",
        #                         c("Property", "Crops")
        #                         ),
        #                sliderInput("max","Max #  of weather events:",
        #                            min = 1,  max = 10,  value = 10)
        #         ),
        #         column(width=9,
        #                showOutput("worst","nvd3")
        #         )
        # ),                       
                
        fluidRow(
                column(width=12,

p("Instructions:"),
p("Please choose between property os crops losses, then choose the max number 
of weather events to plot."),                       
p("Data from NOAA Storm Database. contains data from January 1950 to 
January 2017, as entered by NOAA’s National Weather Service (NWS)."),



p(a("Complete study", href="https://erickfis.github.io/NOAA-Storm-Database/"))
                                )
                        )
                
                
        )





