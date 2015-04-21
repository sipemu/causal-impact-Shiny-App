library(shiny)
library(dygraphs)

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
    ), 
    hr(),
    column(offset = 1, width=11,
      actionButton("stopApp", "Quit Application")
      )
  ),
  # body
  dashboardBody(
    tabItems(
      tabItem("tab_setup", 
              uiOutput("login_page")
              ),
      tabItem("tab_results", 
              uiOutput("ui_results")
              )
    )
  )
)
)
