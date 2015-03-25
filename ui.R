shinyUI(
dashboardPage(skin = "black",
  dashboardHeader(title = "GA Effects"),
  # sidebar
  dashboardSidebar(
    sidebarMenu(
      menuItem(text    = "Setup", 
               icon    = icon("gears"), 
               tabName = "tab_setup"),
      menuItem(text    = "Results", 
               icon    = icon("dashboard"), 
               tabName = "tab_results")
    )
  ),
  # body
  dashboardBody(
    tabItems(
      tabItem("tab_setup", 
#                 fluidRow(
#                   shinydashboard::box(title       = "Upload File", 
#                                       width       = 4,
#                                       solidHeader = TRUE,
#                                       status      = "success", 
#                                       height      = 200, 
#                                       fileInput(inputId = 'inputFile', 
#                                                 label   = 'Choose CSV File'
#                                                ),
#                                       actionButton(inputId = "upload", 
#                                                    label   = "upload data")
#                                       )
#                 ),
fluidRow(
  shinydashboard::box(title       = "Select Dates", 
                      width       = 4,
                      solidHeader = FALSE,
                      status      = "info", 
                      height      = 250, 
                      dateRangeInput(inputId = "dateRange",
                                     label   = "Date Range",
                                     start   = Sys.Date() - 10,
                                     end     = Sys.Date()),
                      helpText("Choose date range of data. Include lead time before and after event date for sensible results."),
                      actionButton("getDataButton", "Get Data")
  ),
  shinydashboard::box(title       = "Select Store & Article", 
                      width       = 4,
                      solidHeader = FALSE,
                      status      = "info", 
                      height      = 250, 
                      selectizeInput(inputId  = "storeID",
                                     label    = "Store", 
                                     choices  = "empty", 
                                     selected = NA, 
                                     multiple = F),
                      selectizeInput(inputId  = "articleID",
                                     label    = "Article", 
                                     choices  = "empty", 
                                     selected = NA, 
                                     multiple = F)
  ),
  shinydashboard::box(title       = "Measurement", 
                      width       = 4,
                      solidHeader = FALSE,
                      status      = "info", 
                      height      = 250, 
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
                      height      = 250, 
                      dateInput(inputId = "eventDate",
                                label   = "Event Date",
                                value   = Sys.Date() - 5),
                      helpText("This value/date is what will be tested to see if it had a statistically significant impact.")
  ),
  shinydashboard::box(title       = "Does the Data Have Seasonality?", 
                      width       = 4,
                      solidHeader = FALSE,
                      status      = "info", 
                      height      = 250, 
                      radioButtons(inputId  = "season",
                                   label    = "Seasonality",
                                   choices  = c("None" = 1, "Weekly" = 7, "Monthly" = 31),
                                   selected = 1),
                      helpText("This value/date is what will be tested to see if it had a statistically significant impact.")
  )
)
              ),
      tabItem("tab_results", 
              uiOutput("ui_results")
              )
    )
  )
)
)
