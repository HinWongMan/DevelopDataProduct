
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(TTR)
library(tseries)
library(zoo)
library(ggplot2)


shinyServer(function(input, output) {
  
  
  stockReturn <- reactive({
    stockname <- input$Symbols
    
    startTime <- input$daterange[1]
    endTime <- input$daterange[2]
    
    stocklist <- get.hist.quote(stockname[1], quote="Close", provider="yahoo",start=startTime, end = endTime, retclass="zoo")
    first <- as.numeric(stocklist[1])
    for(company in stockname[-1])
    {
      stock <- get.hist.quote(company, quote="Close", provider="yahoo",start=startTime, end = endTime, retclass="zoo")
      first <- c(first,as.numeric(stock[1]))
      stocklist <- merge(stocklist,stock)
    }
    names(stocklist) <- input$Symbols
    if(input$Chart == "Return")
    {
      for(company in 1:length(input$Symbols))
      {
        stocklist[,company]<- replace(stocklist[,company],is.na(stocklist[,company]),first[company])
      }
      stockPerformance <- cumsum(diff(log(stocklist),lag = 1))*100
      stockPerformance
    }
    else
    {
      stocklist
    }
  })
  
  output$returnPlot <- renderPlot({
    title <- "Price of Stock "
    xlabel <- "Date"
    ylabel <- "Price(USD)"
    if(input$Chart == "Return")
    {
      title <- "Return of Stock"
      ylabel <- "Return(%)"
    }
    ret <- fortify.zoo(stockReturn(),melt = TRUE)
    qplot(Index,Value,data = ret, color = Series,geom = "line", main = title, xlab = xlabel, ylab = ylabel)
  })
  
  

})
