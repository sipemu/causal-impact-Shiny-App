getCache <- function() {
  articles <- read.csv("cache/articles.csv", colClasses = "character")
  sites <- read.csv("cache/sites.csv")
  startDate <- read.csv("cache/startDate.csv")
  
  return(list(articles=articles, sites=sites, startDate=startDate))
}

# load cahced data
global.tsCache <- getCache()

function(input, output, session) {
  reaVal <- reactiveValues()
  reaVal$loggedIn <- FALSE
  # cache variables:
  # if user just made date window smaller, data will not fetched again
  measVarCache <- "SUM"
  startDateCache <- as.Date(global.tsCache$startDate$min)
  endDateCache <- Sys.Date()
  siteCache <- global.tsCache$sites$site[1]
  articleCache <- global.tsCache$articles$x[1]
  tsDataCache <- c()
  
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

