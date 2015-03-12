# basic data input; 
getData <- reactive({
  inFile <- input$inputFile
  
  if (is.null(inFile))
    return()
  tsData <- read.csv(inFile$datapath, header=TRUE, sep=";", as.is = TRUE)
  tsData$date <- as.Date(tsData$date)
  tsData
})
