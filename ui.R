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
              uiOutput("login_page")
              ),
      tabItem("tab_results", 
              uiOutput("ui_results")
              )
    )
  )
)
)
