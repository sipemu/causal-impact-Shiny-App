output$ui_setup <- renderUI({
  isolate({
    tsData <- getData()
    if (is.null(tsData)) 
      return()
    # Output depending on data structure
    start <- tsData$date[1]
    end <- tsData$date[nrow(tsData)]
    target <- tsData$date[floor(length(start:end) / 2)]
    tagList(
      fluidRow(
        shinydashboard::box(title       = "Select Dates", 
                            width       = 4,
                            solidHeader = FALSE,
                            status      = "info", 
                            height      = 200, 
                            dateRangeInput(inputId = "dateRange",
                                           label   = "Date Range",
                                           start   = start,
                                           end     = end),
                            helpText("Choose date range of data. Include lead time before and after event date for sensible results.")
                            ),
        shinydashboard::box(title       = "Menu 1", 
                            width       = 4,
                            solidHeader = FALSE,
                            status      = "info", 
                            height      = 200, 
                            "other possible menu."
                            ),
        shinydashboard::box(title       = "Menu 2", 
                            width       = 4,
                            solidHeader = FALSE,
                            status      = "info", 
                            height      = 200, 
                            "other possible menu."
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
                          height      = 250, 
                          dateInput(inputId = "eventDate",
                                    label   = "Event Date",
                                    value   = target),
                          helpText("This value/date is what will be tested to see if it had a statistically significant impact.")
                          ),
      shinydashboard::box(title       = "Does the Data Have Seasonality?", 
                          width       = 4,
                          solidHeader = FALSE,
                          status      = "info", 
                          height      = 250, 
                          radioButtons(inputId = "season",
                                       label    = "Seasonality",
                                       choices  = c("None" = 0, "Weekly" = 7, "monthly" = 31),
                                       selected = 0),
                          helpText("This value/date is what will be tested to see if it had a statistically significant impact.")
                          )
      )
    )
  })
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
