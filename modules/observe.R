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
  if (is.null(input$doLogin))
    return()
  
  if (input$doLogin == 0)
    return()
  
  user <- input$user
  passwd <- input$passwd
  if (user == "shiny" & passwd == "shiny2015") {
    reaVal$loggedIn <<- TRUE
  }
})

observe({
  start <-startDateCache
  end <- endDateCache
  target <- start + (end - start) / 2
  article <- global.tsCache$articles$x
  article <- c("all", global.tsCache$articles$x)
  names(article) <- c("all", as.numeric(global.tsCache$articles$x))
  sites <- c("all", global.tsCache$sites$site)
  
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
                       choices  = sites, 
                       selected = sites[2])
  updateSelectizeInput(session,
                 inputId  = "articleID",
                 label    = "Article", 
                 choices  = article, 
                 selected = article[2])
})
