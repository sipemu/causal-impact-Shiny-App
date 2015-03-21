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
    singleton(
      tags$head(tags$script(src = "message-handler.js"))
    ),
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
              uiOutput("ui_setup")
              ),
      tabItem("tab_results", 
              uiOutput("ui_results")
              )
    )
  )
)
)
