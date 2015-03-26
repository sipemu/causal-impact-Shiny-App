output$ui_setup <- renderUI({
    #if (is.null(tsData)) 
    #  return()
    # Output depending on data structure
    start <-startDateCache
    end <- endDateCache
    target <- start + (end - start) / 2
    article <- global.tsCache$articles$x
    names(article) <- as.numeric(global.tsCache$articles$x)
    tagList(
      fluidRow(
        shinydashboard::box(title       = "Select Dates", 
                            width       = 4,
                            solidHeader = FALSE,
                            status      = "info", 
                            height      = 220, 
                            dateRangeInput(inputId = "dateRange",
                                           label   = "Date Range",
                                           start   = start,
                                           end     = end),
                            helpText("Choose date range of data. Include lead time before and after event date for sensible results."),
                            actionButton("getDataButton", "Get Data")
        ),
        shinydashboard::box(title       = "Select Store & Article", 
                            width       = 4,
                            solidHeader = FALSE,
                            status      = "info", 
                            height      = 220, 
                            selectizeInput(inputId  = "storeID",
                                           label    = "Store", 
                                           choices  = global.tsCache$sites$site, 
                                           selected = global.tsCache$sites$site[1], 
                                           multiple = F),
                            selectizeInput(inputId  = "articleID",
                                           label    = "Article", 
                                           choices  = article, 
                                           selected = article[1], 
                                           multiple = F)
        ),
        shinydashboard::box(title       = "Measurement", 
                            width       = 4,
                            solidHeader = FALSE,
                            status      = "info", 
                            height      = 220, 
                            radioButtons(inputId  = "measVariable",
                                         label    = NA, 
                                         choices  = c("Sales" = "SUM", "Volume" = "COUNT"),
                                         selected = "SUM"),
                            helpText("Choose measurement: Sales: sum of sales; Volume: count of sales")
        )
      )
    )
})


output$ui_results <- renderUI({
  tsData <- getData()
  if (is.null(tsData)) 
    return()
  
  tagList(
    fluidRow(
      shinydashboard::box(title       = "How did the expected trend with no effect present compare to the observed?", 
                          width       = 12,
                          solidHeader = TRUE,
                          status      = "success", 
                          dygraphOutput("gaPlot")
                          )
    ),
    fluidRow(
      shinydashboard::box(title       = "How did the observed trend with the event perform verses the expected trend without it?", 
                          width       = 12,
                          solidHeader = TRUE,
                          status      = "warning", 
                          dygraphOutput("cumulativePlot")
      )
    ),
    fluidRow(
      shinydashboard::tabBox(title = "Raw Results",
                             width = 12,
                             id    = "raw_results",
                             tabPanel(title = "Summary", 
                                      verbatimTextOutput("ciSummary")),
                             tabPanel(title = "Plot",
                                      plotOutput("rawCIPlot"))
                             )
    )
  )
})
