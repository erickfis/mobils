#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(lubridate)
library(ggplot2)
library(rmarkdown)
library(knitr)
library(scales)
library(plotly)
library(rCharts)
library(RColorBrewer)

# library(ggvis)


# prepare data

load("data/harm.rda")



Property <- harm.df %>% filter(!is.na(prop.ev)) %>% select(1:6,9) %>% 
                filter(prop.ev > 0) %>%
                group_by(event) %>%
                summarise(total.raw = sum(prop.ev)) %>%
                arrange(desc(total.raw)) %>%
                mutate(
                        media.raw = mean(total.raw),
                        rank = seq_len(length(event))
                       )
                # filter(total.raw > mean(total.raw))

Property$event <- factor(Property$event,
                           levels = Property$event[order(Property$rank)])



Crops <- harm.df %>% filter(!is.na(crop.ev)) %>% select(1:6,10) %>%
                filter(crop.ev > 0) %>%
                group_by(event) %>%
                # summarise(total.raw = sum(crop.ev)) %>%
                summarise(total.raw = sum(crop.ev)) %>%
                arrange(desc(total.raw)) %>%
                mutate(
                        media.raw = mean(total.raw),
                        rank = seq_len(length(event))
                        )
                # filter(total.raw > mean(total.raw))

Crops$event <- factor(Crops$event,
                           levels = Crops$event[order(Crops$rank)])


shinyServer(function(input, output) {
        
        
   
        tipo <- reactive({
                x <- get(input$type)
        })

      
        
        output$worst <- renderChart({

                df <- tipo()
                df <- filter(df, rank <= input$max)
                
  
                colourCount <- length(unique(df$event))
                paleta <- colorRampPalette(brewer.pal(colourCount, "Set1"))
                colors <- paleta(colourCount)
                df$colors <- colors
                
                
                df$total.raw <- df$total.raw/1000000000
                
                p2 <-  nPlot(total.raw ~ event, data = df, type = 'discreteBarChart')
                p2$chart(color = df$colors)
                # p2$set(title = "Losses in billion $")
                # p2$yAxis( axisLabel = "Losses in billion $" )
                p2$yAxis(axisLabel = "Losses in billions $", width=60)
                p2$set(dom = "worst")
               
                return(p2)
        })
        
   
})
        
    