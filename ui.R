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
uiOutput("ui_setup"),
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
              ),
      tabItem("tab_results", 
              uiOutput("ui_results")
              )
    )
  )
)
)
