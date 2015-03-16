getCSV <- reactive({
  inFile <- input$inputFile
  
  if (is.null(inFile)) 
    return()
  
  if(is.null(input$upload)) 
    return()
  
  if (input$upload == 0)
    return()
  
  isolate({
    tsData <- read.csv(inFile$datapath, header=TRUE, sep=";", as.is = TRUE)
    tsData$date <- as.Date(tsData$date)
    tsData
  })
})

# basic data input; 
getData <- reactive({
  # input csv or database
  tsData <- getCSV()
  
  if (is.null(tsData))
    tsData <- tsDataGlobal
  
  if (!is.null(input$dateRange)) {
    start <- input$dateRange[1]
    end   <- input$dateRange[2]
  } else {
    start <- tsData$date[1]
    end <- tsData$date[nrow(tsData)]
  }
  
  idDates <- which(tsData$date %in% seq(as.Date(start), as.Date(end), by=1))
  tsData[idDates, ]
})
