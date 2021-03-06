output$ui_setup <- renderUI({
    start <- startDateCache
    end <- endDateCache
    target <- start + (end - start) / 2
    article <- c("all", global.tsCache$articles$x)
    site <- c("all", global.tsCache$sites$site)
    names(article) <- c("All Articles", paste0(as.numeric(global.tsCache$articles$x), "-article_name"))
    names(site) <- c("All Sites", paste0(global.tsCache$sites$site, "-site_name"))
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
                            actionButton("getDataButton", "Get Data"),
                            downloadButton("downloadData", "Export Data")
        ),
        shinydashboard::box(title       = "Select Store & Article", 
                            width       = 4,
                            solidHeader = FALSE,
                            status      = "info", 
                            height      = 220, 
                            selectizeInput(inputId  = "storeID",
                                           label    = "Store", 
                                           choices  = site[1], # server side search
                                           selected = site[1], # server side search
                                           multiple = T),
                            selectizeInput(inputId  = "articleID",
                                           label    = "Article", 
                                           choices  = article[1], # server side search
                                           selected = article[1], # server side search
                                           multiple = T)
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
      ),
      fluidRow(
        shinydashboard::box(title       = "Click-Drag to Zoom. Double-Click to Reset. Shift-Drag to Pan.", 
                            width       = 12,
                            dygraphOutput("tsPlot")
        )
      ),
      fluidRow(
        shinydashboard::box(title       = "When did the event happend?", 
                            width       = 4,
                            solidHeader = FALSE,
                            status      = "warning", 
                            height      = 220, 
                            dateInput(inputId = "eventDate",
                                      label   = "Event Date",
                                      value   = Sys.Date() - 5),
                            helpText("This value/date is what will be tested to see if it had a statistically significant impact.")
        ),
        shinydashboard::box(title       = "Does the Data Have Seasonality?", 
                            width       = 4,
                            solidHeader = FALSE,
                            status      = "info", 
                            height      = 220, 
                            radioButtons(inputId  = "season",
                                         label    = "Seasonality",
                                         choices  = c("None" = 1, "Weekly" = 7, "Monthly" = 31),
                                         selected = 1),
                            helpText("This value/date is what will be tested to see if it had a statistically significant impact.")
        )
      )
    )
})


output$ui_results <- renderUI({
  tsData <- reaVal$tsData
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
