function(input, output, session) {
  # preloaded data
  tsDataGlobal <- read.csv("testData.csv", header=TRUE, sep=";", as.is = TRUE)
  tsDataGlobal$date <- as.Date(tsDataGlobal$date)
  
  # trigger for new data
  isNewData <- reactiveValues()
  isNewData$loaded <- 0
  
  # source files from tools directory
  flist <- sourceDirectory(path      = 'modules', 
                           encoding  = "UTF-8",
                           recursive = TRUE)
  for (i in 1:length(flist)) {
    source(flist[i], local=TRUE, encoding="UTF-8")
  }
}

