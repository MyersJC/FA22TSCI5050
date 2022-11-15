
# Libraries ----
library(DataExplorer)
library(rio)

# Data Import ----
datafile <- "projectdata.xlsx"
datascript <- "R_step_by_step.R"
dat <- if(file.exists(datafile)){
  import(datafile)
} else {
#  source(datascript)
  system(paste("R -f",datascript), wait = TRUE)
  import(datafile)
  }
create_report(dat)

