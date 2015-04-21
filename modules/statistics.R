# workhorse of causal impact function
casualImpact <- reactive({
  updateVal$updateDate
  
  isolate({
    tsData <- reaVal$tsData
  })
  
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
  
  # check date 
  
  
  # setting up the necessary data for CausalImpact
  pre.period  <- which(tsData$date %in% c(start, event))
  shiny::validate(need(length(pre.period) > 0, "No data in period prior event date."))
  post.period  <- which(tsData$date %in% c(event + 1, end))
  shiny::validate(need(length(post.period) > 1, "No data in period after event date."))
  period <- pre.period[1]:post.period[2]
  
  # doing the CausalImpact call and creating the model data
  CausalImpact(tsData[period, -2], pre.period, post.period, model.args = list(nseasons = as.numeric(input$season), season.duration = 1))
})

output$ciSummary <- renderPrint({
  ci <- casualImpact()
  summary(ci, "report")
})
