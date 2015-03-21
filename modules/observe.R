# observe data range
observe({
  updateDateRangeInput(session = session,
                       inputId = "dateRange",
                       label   = "Date Range",
                       start   = NULL,
                       end     = NULL)
})

# 
observe({
  tsData <- getData()
  
  if (is.null(tsData))
    return()
  
  start <- tsData$date[1]
  end <- tsData$date[nrow(tsData)]
  
  target <- tsData$date[floor(length(start:end) / 2)]
  
  updateDateRangeInput(session = session,
                       inputId = "dateRange",
                       label   = "Date Range",
                       start   = start,
                       end     = end)
  
  updateDateInput(session = session,
                  inputId = "eventDate",
                  label   = "Event Date",
                  value   = target)
  
  # session$sendCustomMessage(type = 'testmessage', message ="La suma de los valores de cada nivel debe  ser igual al N hipotetico")
})
