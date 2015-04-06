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
  if (is.null(input$stopApp))
    return()
  
  if (input$stopApp == 0)
    return()
  
  stopApp()
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
  article <- c("all", global.tsCache$articles$x)
  site <- c("all", global.tsCache$sites$site)
  names(article) <- c("All Articles", paste0(as.numeric(global.tsCache$articles$x), "-article_name"))
  names(site) <- c("All Sites", paste0(global.tsCache$sites$site, "-site_name"))
  
  updateDateRangeInput(session,
                       inputId = "dateRange",
                       label   = "Date Range",
                       start   = start,
                       end     = end)
  
  updateDateInput(session,
                  inputId = "eventDate",
                  label   = "Event Date",
                  value   = target)
  
  isolate({selArt <- input$storeID})
  updateSelectizeInput(session,
                       inputId  = "storeID",
                       label    = "Store", 
                       choices  = site, 
                       selected = selArt,
                       server   = TRUE)
  
  isolate({selArt <- input$articleID})
  updateSelectizeInput(session,
                 inputId  = "articleID",
                 label    = "Article", 
                 choices  = article, 
                 selected = selArt,
                 server   = TRUE)
})

output$downloadData <- downloadHandler(
  filename = function() { 
    paste('Export-Data-', Sys.Date(), '.xlsx', sep='')
  },
  content = function(file) {
    fname <- paste(file, "xlsx", sep=".")
    writeWorksheetToFile(file  = fname, 
                         data  = getData(),
                         sheet = "Data")
    file.rename(fname, file)
  })
