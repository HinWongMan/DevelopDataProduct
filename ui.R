
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(TTR)

shinyUI(fluidPage(

  # Application title
  titlePanel("Stock Price and Return Tracker"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    
    sidebarPanel(
      dateRangeInput("daterange",
                     "Range of date of holding:",
                     start = "2001-01-01"
                     
      ),
      
      selectizeInput("Symbols",
                  "List of stock symbols:",
                  selected = "IBM",
                  multiple = TRUE,
                  choices = list(AMEX =stockSymbols(exchange = "AMEX")[1],
                                 NASDAQ = stockSymbols(exchange = "NASDAQ")[1],
                                 NYSE = stockSymbols(exchange = "NYSE")[1])
        
      ),
      
      radioButtons("Chart",
                   "Chart Type:",
                   choices = c("Price","Return"),
                   selected = "Price"
                   
        
      ),
      
      submitButton(text = "Recalculate"
        
      )
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("returnPlot"),
      p("Select the date range, stocks and chart type, hit 'Recalculate' and chart is plotted"),
      p("Currently, only US Stock is available"),
      p("Price: chart of stock price"),
      p("Return: chart of stock return"),
      p("Note: price of stocks varies? Try using stock return plot to compare")
    )
  )
))
