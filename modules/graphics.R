# raw data plot ----
output$tsPlot <- renderDygraph({
  updateVal$updateDate
  
  isolate({
    tsData <- reaVal$tsData
  })
  
  if(is.null(tsData))
    return()
  
  if(ncol(tsData) == 0)
    return()
  
  # get the start and end from the user input in ui.r
  start <- input$dateRange[1]
  end   <- input$dateRange[2]
  
  # we need to convert the dataframe into a timeseries for dygraph
  # orderme <- seq(as.Date(start), as.Date(end), by=1)
  ci <- xts(tsData$sales, tsData$date)
  
  dateWindow <- c(max(as.Date(input$eventDate) - 70, start), as.Date(end))
  # the dygraph output
  dygraph(data = ci) %>%
    dyRangeSelector(dateWindow = dateWindow) %>%
    dyEvent(date = input$eventDate, "Event") %>%
    dySeries('V1', label='Expected')
})

# raw & estimated ----
output$gaPlot <- renderDygraph({
  # the data for the plot is in here
  ci <- casualImpact()$series
  
  # get the start and end from the user input in ui.r
  start <- input$dateRange[1]
  end   <- input$dateRange[2]
  
  # we need to convert the dataframe into a timeseries for dygraph
  orderme <- seq(start, end, by=1)
  ci <- xts(ci, orderme)
  
  # the dygraph output
  dygraph(data=ci[ , c('response', 'point.pred', 'point.pred.lower', 'point.pred.upper')], 
          main="Expected (95% confidence level) vs Observed", group="ci") %>%
    dyRangeSelector(dateWindow = c(max(as.Date(input$eventDate) - 70, start), end)) %>%
    dyEvent(date = input$eventDate, "Event") %>%
    dySeries(c('point.pred.lower', 'point.pred','point.pred.upper'), label='Expected') %>%
    dySeries('response', label="Observed")
})

# cumulative plot ----
output$cumulativePlot <- renderDygraph({
  # the data for the plot is in here
  ci <- casualImpact()$series
  
  # get the start and end from the user input in ui.r
  start <- input$dateRange[1]
  end   <- input$dateRange[2]
  
  # we need to convert the dataframe into a timeseries for dygraph
  orderme <- seq(start, end, by=1)
  ci <- xts(ci, orderme)
  
  # the dygraph output
  dygraph(data=ci[ , c('cum.effect.lower', 'cum.effect','cum.effect.upper')], 
          main="Cumulative Effect (95% confidence level)") %>%
    dyRangeSelector(dateWindow = c(input$eventDate - 7, end)) %>%
    dyEvent(date = input$eventDate, "Event") %>%
    dySeries(c('cum.effect.lower', 'cum.effect','cum.effect.upper'), label='Cumulative')
})

# raw ci plot ----
output$rawCIPlot <- renderPlot({
  plot(casualImpact())
})
