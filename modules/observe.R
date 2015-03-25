observe({
  tsData <- getData()
  
  isolate({
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
  })
  # session$sendCustomMessage(type = 'testmessage', message ="La suma de los valores de cada nivel debe  ser igual al N hipotetico")
})

observe({
  start <-startDateCache
  end <- endDateCache
  target <- start + (end - start) / 2
  article <- global.tsCache$articles$x
  names(article) <- as.numeric(global.tsCache$articles$x)
  
  
  updateDateRangeInput(session,
                       inputId = "dateRange",
                       label   = "Date Range",
                       start   = start,
                       end     = end)
  
  updateDateInput(session,
                  inputId = "eventDate",
                  label   = "Event Date",
                  value   = target)
  
  updateSelectizeInput(session,
                       inputId  = "storeID",
                       label    = "Store", 
                       choices  = global.tsCache$sites$site, 
                       selected = global.tsCache$sites$site[1])
  updateSelectizeInput(session,
                 inputId  = "articleID",
                 label    = "Article", 
                 choices  = article, 
                 selected = article[1])
})
