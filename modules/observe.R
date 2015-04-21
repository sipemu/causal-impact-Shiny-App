observe({
  tsData <- reaVal$tsData
  
  isolate({
    if (is.null(tsData))
      return()
    
    start <- tsData$date[1]
    end <- tsData$date[nrow(tsData)]
    target <- tsData$date[floor(length(start:end) / 2)]
    
    updateDateRangeInput(session = session,
                         inputId = "dateRange",
                         label   = "Date",
                         start   = start,
                         end     = end)
    
    updateDateInput(session = session,
                    inputId = "eventDate",
                    label   = "Event Date",
                    value   = target)
    updateVal$updateDate <- updateVal$updateDate + 1
  })
})


output$downloadData <- downloadHandler(
  filename = function() { 
    paste('Export-Data-', Sys.Date(), '.xlsx', sep='')
  },
  content = function(file) {
    fname <- paste(file, "xlsx", sep=".")
    writeWorksheetToFile(file  = fname, 
                         data  = isolate({reaVal$tsData}),
                         sheet = "Data")
    file.rename(fname, file)
  })
