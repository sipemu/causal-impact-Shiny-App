# workhorse of causal impact function
casualImpact <- reactive({
  tsData <- getData()
  
  if (is.null(tsData))
    return()
  
  # from user input in ui.r
  start  <- input$dateRange[1]
  end    <- input$dateRange[2]
  event  <- input$eventDate
  
  # no impact yet
  season <- as.numeric(input$season)
  
  # setting up the necessary data for CausalImpact
  pre.period  <- which(tsData$date %in% c(start, event))
  post.period  <- which(tsData$date %in% c(event + 1, end))
  
  # doing the CausalImpact call and creating the model data
  CausalImpact(tsData[ , -3], pre.period, post.period)
})

output$ciSummary <- renderPrint({
  ci <- casualImpact()
  summary(ci, "report")
})
