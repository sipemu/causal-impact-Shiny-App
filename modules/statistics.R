# workhorse of causal impact function
casualImpact <- reactive({
  tsData <- getData()
  
  if (is.null(tsData))
    return()
  
  if (is.null(input$dateRange))
    return()
  
  # from user input in ui.r
  start  <- input$dateRange[1]
  end    <- input$dateRange[2]
  event  <- input$eventDate

    # no impact yet
  season <- as.numeric(input$season)
  idData <- which(tsData$date %in% seq(as.Date(start), as.Date(end), by=1))
  
  # setting up the necessary data for CausalImpact
  pre.period  <- which(tsData$date %in% c(start, event))
  post.period  <- which(tsData$date %in% c(event + 1, end))
  period <- pre.period[1]:post.period[2]
  
  # doing the CausalImpact call and creating the model data
  CausalImpact(tsData[period, -3], pre.period, post.period)
})

output$ciSummary <- renderPrint({
  ci <- casualImpact()
  summary(ci, "report")
})
