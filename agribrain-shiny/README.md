# AgriBrain Shiny Dashboard

This repository contains the data and code required to create the [Shiny Dashboard](https://rstudio.github.io/shinydashboard/) that displays the three AgriBrain sensors located in Uganda. Each sensor captures soil moisture levels for there given crop (both past and predicted values) and further allows the user to download the data in a csv format. 

### Get It Running
1. Make sure you have [R](https://cran.r-project.org/doc/manuals/r-release/R-admin.html) installed *(Pretty important step in this process)*

2. Through your favorite R interface, be sure you `install.packages` for both shiny and shinydashboard along with all the packages found in the `global.R` script.

3. Clone this repo

4. You should be good to go!! Make sure your cwd is set to the base level of this repo. run `shinyApp()` in your console, or click the `Run App` button in RStudio.

