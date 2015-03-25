# caching ----
buildCache <- function() {
  conn <- connectToRedshift()
  
  # articles
  articles <- redshift.query(conn = conn, "SELECT DISTINCT article FROM transactions2;")
  articles <- na.omit(articles)
  articles$article <- sort(articles$article)
  articles$article <- str_trim(articles$article)
  idDel <- which(articles$article == "")
  articles <- articles[-idDel, ]
  write.csv(articles, file="cache/articles.csv", row.names=F)
  
  # sites
  sites <- redshift.query(conn = conn, "SELECT DISTINCT site FROM transactions2;")
  sites <- na.omit(sites)
  sites$site <- sort(sites$site)
  write.csv(sites, file="cache/sites.csv", row.names=F)
  
  # min date 
  startDate <- redshift.query(conn = conn, "SELECT MIN(businessdate) FROM transactions2;")
  write.csv(startDate, file="cache/startDate.csv", row.names=F)
  disconnectRedshift(conn)
}

getCache <- function() {
  articles <- read.csv("cache/articles.csv", colClasses = "character")
  sites <- read.csv("cache/sites.csv")
  startDate <- read.csv("cache/startDate.csv")
  
  return(list(articles=articles, sites=sites, startDate=startDate))
}

# connection to amazon redshift database ----
connectToRedshift <- function() {
  # catch warnings and errors
  tryDisconnect <- tryCatch({
    conn <- redshift.connect("jdbc:postgresql://s-eleven-data-store.c9xyp6cclnk6.ap-southeast-2.redshift.amazonaws.com:5439/seleven?tcpKeepAlive=true", 
                             "seuser", 
                             "N33ds3cur1tyt0b3r43llyg00d!!")
  })
  shiny::validate(need(tryDisconnect, "Connection to database failed."))
  
  return(conn)
}

disconnectRedshift <- function(conn) {
  redshift.disconnect(conn)
}

# get csv ----
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


# get data from amazon redshift db ----
getRedshiftData <- function(start, end, site, article, aggFunc="SUM") {
  # build   query
  query <- getQuery(article, site, start, end, aggFunc = aggFunc)
  shiny::withProgress(message = "Get Data", 
                      value   = 0, {
    # get data
    incProgress(0.25, message = "Connect to DB...")
    conn <- connectToRedshift()
    incProgress(0.5, message = "Get Data...Please be patient")
    initData <- redshift.query(conn, query$query)
    disconnectRedshift(conn)
  })
  initData$date <- as.Date(initData$date)
  return(initData)
}

# build query string ----
# aggFunc:  SUM for value
#           COUNT for Volume
getQuery <- function(article, site, start, end, aggFunc="SUM") {
  query <- paste0("SELECT ", 
                  aggFunc, "(salesatretail) as sales
                  , businessdate as date 
                  FROM 
                    transactions2
                  WHERE 
                    article = '", article, "'
                  AND 
                    site = ", site, "
                  GROUP BY
                    date
                  ORDER BY date;")
  cRow <- paste0("SELECT 
                    COUNT(article)
                  FROM 
                    transactions2
                  WHERE 
                    article = '", article, "'
                  AND 
                    site = ", site, ";")
  return(list(query=query, count=cRow))
}

# data fetch----
getData <- reactive({
  
  if (is.null(input$getDataButton))
    return()
  
  if (input$getDataButton == 0)
    return()
  
  measVar <- input$measVariable
  if (is.null(measVar))
    measVar <- "SUM"
  # get data
  if (!is.null(input$dateRange)) {
    start <- input$dateRange[1]
    end <- input$dateRange[2]
    site <- input$storeID
    article <- input$articleID
    # get cached data or not 
    if (is.null(tsDataCache)) {
      fnD <- TRUE
    } else {
      fnD <- checkFetchNewData(start, end, site, article, input$measVariable)
    }
    if (fnD) {
      tsData <- getRedshiftData(start, end, site, article, input$measVariable)
      print(nrow(tsData))
      shiny::validate(need(nrow(tsData) > 10, "Too less measurements for calculation."))
      articleCache <<- article
      siteCache <<- site
      startDateCache <<- start
      endDateCache <<- end
      measVarCache <<- measVar
    } else {
      tsDataCache %>% 
        filter(date >= start ) -> tsData
    }
  } else {
    start <- startDateCache
    end <- endDateCache
    site <- global.tsCache$sites$site[1]
    article <- global.tsCache$articles$x[1]
    tsData <- getRedshiftData(start, end, site, article)
    shiny::validate(need(nrow(tsData) > 10, "Too less measurements for calculation."))
    articleCache <<- article
    siteCache <<- site
    startDateCache <<- start
    endDateCache <<- end
    measVarCache <<- measVar
    fnD <- TRUE
  }
  # chace data globally if new
  if (fnD)
    tsDataCache <<- tsData
  
  return(tsData)
})

# check date window ----
checkFetchNewData <- function(startDate, endDate, site, article, measVar) {
  n <- nrow(tsDataCache)
  if (startDate >= tsDataCache$date[1] & 
      endDate <= tsDataCache$date[n] & 
      site == siteCache & 
      article == articleCache & 
      measVar == measVarCache) {
    return(FALSE)
  } else {
    return(TRUE)
  }
}

