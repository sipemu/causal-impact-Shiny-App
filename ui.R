library(shiny)
library(dygraphs)

shinyUI(
dashboardPage(skin = "black",
  dashboardHeader(title = "Causal Impact"),
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
              uiOutput("ui_setup")
              ),
      tabItem("tab_results", 
              uiOutput("ui_results")
              )
    )
  )
)
)
