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
    conn <- redshift.connect("xxx", 
                             "xxx", 
                             "xxx")
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
  site_q <- paste(paste0("'", site, "'"), collapse=", ")
  article_q <- paste(paste0("'", article, "'"), collapse=", ")
  if ("all" %in% site & "all" %in% article) {
    query <- paste0("SELECT ", 
                    aggFunc, "(salesatretail) as sales
                  , businessdate as date 
                  FROM 
                    transactions2
                  GROUP BY
                    date
                  ORDER BY date;")
  } else if ("all" %in% site & !("all" %in% article)) {
    query <- paste0("SELECT ", 
                    aggFunc, "(salesatretail) as sales
                  , businessdate as date 
                  FROM 
                    transactions2
                  WHERE 
                    article IN (", article_q, ")
                  GROUP BY
                    date
                  ORDER BY date;")
  } else if (!("all" %in% site) & "all" %in% article) {
    query <- paste0("SELECT ", 
                    aggFunc, "(salesatretail) as sales
                  , businessdate as date 
                  FROM 
                    transactions2
                  WHERE 
                    site IN (", site_q, ")
                  GROUP BY
                    date
                  ORDER BY date;")
  } else {
    query <- paste0("SELECT ", 
                    aggFunc, "(salesatretail) as sales
                  , businessdate as date 
                  FROM 
                    transactions2
                  WHERE 
                    article IN (", article_q, ")
                  AND 
                    site IN (", site_q, ")
                  GROUP BY
                    date
                  ORDER BY date;")
  }

  cRow <- paste0("SELECT 
                    COUNT(article)
                  FROM 
                    transactions2
                  WHERE 
                    article IN (", article, ")
                  AND 
                    site IN (", site, ");")
  return(list(query=query, count=cRow))
}

# data fetch----
observeEvent(input$getDataButton, {
  isolate({
    measVar <- input$measVariable
    if (is.null(measVar))
      measVar <- "SUM"
    # get data
    if (!is.null(input$dateRange)) {
      start <- input$dateRange[1]
      end <- input$dateRange[2]
      site <- input$storeID
      article <- input$articleID
      
      if (is.null(site) | is.null(article))
        return()
      
      # get cached data or not 
      if (is.null(reaVal$tsData)) {
        fnD <- TRUE
      } else {
        fnD <- checkFetchNewData(reaVal$tsData, start, end, site, article, input$measVariable)
      }
      if (fnD) {
        tsData <- getRedshiftData(start, end, site, article, input$measVariable)
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
      site <- reaVal$tsData$sites$site[1]
      article <- reaVal$tsData$articles$x[1]
      tsData <- getRedshiftData(start, end, site, article)
      shiny::validate(need(nrow(tsData) > 10, "Too less measurements for calculation."))
      articleCache <<- article
      siteCache <<- site
      startDateCache <<- start
      endDateCache <<- end
      measVarCache <<- measVar
      fnD <- TRUE
    }
    # cache data globally if new
    if (fnD)
      reaVal$tsData <<- tsData
    
    reaVal$tsData <<- tsData
  })
})

# check date window ----
checkFetchNewData <- function(tsData, startDate, endDate, site, article, measVar) {
  n <- nrow(tsData)
  if (startDate >= tsData$date[1] & 
      endDate <= tsData$date[n] & 
      sum(siteCache %in% site) == length(site) & 
      length(siteCache) == length(site) &
      sum(articleCache %in% article) == length(article) & 
      length(articleCache) == length(article) &
      measVar == measVarCache) {
    return(FALSE)
  } else {
    return(TRUE)
  }
}

