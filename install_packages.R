options(repos = "http://cran.rstudio.com/")

inst.pkgs <- installed.packages()

# install devtools
if (!"devtools" %in% inst.pkgs)
  install.packages("devtools")
library(devtools)

# packages from github
devtools::install_github(c("ramnathv/htmlwidgets", 
                           "rstudio/dygraphs", 
                           "rstudio/shinydashboard", 
                           "ebailey78/shinyBS",
                           "google/CausalImpact",
                           "pingles/redshift-r"))

pkg <- c("shiny", "dygraphs", "dplyr", "reshape", "stringr")
available <- suppressWarnings(
  suppressPackageStartupMessages(sapply(pkgs, 
                                        require, 
                                        character.only=TRUE)))

inst.pkgs <- pkgs[available == FALSE]
if (length(inst.pkgs) != 0) {
  install.packages(inst.pkgs, dependencies = TRUE)
  suppressWarnings(suppressPackageStartupMessages(sapply(inst.pkgs, library, 
                                                         character.only=TRUE)))
}
