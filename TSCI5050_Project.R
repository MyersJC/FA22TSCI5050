#'---
#'#' title: "TSCI 5050: Project"
#' author: 'JC MYERS ^1^'
#'---

#+ init, echo=FALSE, message=FALSE, warning=FALSE
# init ----
# This part does not show up in your rendered report, only in the script,
# because we are using regular comments instead of #' comments

debug <- 0;
knitr::opts_chunk$set(echo=debug>-1, warning=debug>0, message=debug>0);

# Libraries ----

library(ggplot2); # visualisation
library(GGally);
library(rio);# simple command for importing and exporting
library(pander); # format tables
library(printr); # set limit on number of lines printed
library(broom); # allows to give clean dataset
library(dplyr); #add dplyr library
library(survival);
library(DataExplorer);
library(explore);
library(correlationfunnel);


# Load Data ---- 
datafile <- "veteran.xlsx"
#' Data exploration report for the raw data: [report.html](./report.html)
rawdatafile <- "C:/Users/JC Myers/OneDrive/Residency/PGY2 Research 1 2022-2023/MSCI/(1) 2022 Fall/5050 Intro Data Science/RStudio Files/FA22TSCI5050/veteran.xlsx";
rawdata <- if(file.exists(datafile)){
  import(datafile)
} else {
  #  source(datascript)
  system(paste("R -f",datascript), wait = TRUE)
  import(datafile)
}

create_report(rawdata, quiet=TRUE);


# Any additional summaries or visualizations you want!

# This is also a good place to put validation checks-- do any patients have 
# encounters after they are deceased? Any women supposedly getting prostate 
# exams? Any men flagged as pregnant? Any negative or extremely 
# large ages/weights/heights?

# Process Data ----
#' Data exploration report for the processed data: [processed.html](./processed.html)
# Based on what you see in the exploration section above, prepare your data. 
# This can (but doesn't always have to) include...
#   - Getting rid of columns you won't need.
#   - Converting columns that were supposed to be dates or amounts but ended up
#     as character strings. Or vice versa.
#   - Creating new columns that are derived from existing ones.
#   - Creating columns for random group assignment either by observation or by
#     test-subject/patient.
#   - Filling in missing values (with e.g. median, mean, max, or min)
#   - Re-coding numeric columns to categorical bins age -> young/middle/old.
#     Or, in some cases data comes as numeric codes and you want to recode it 
#     to something easier to understand, 
#     e.g. 0,1,2 -> Unknown, Hispanic, Non-Hispanic
#   - Consolidating categoric columns with many small categories into a few 
#     main categories and 'Other' for all the rest.
#   - For many analyses it's good to scale your numeric variables so they are 
#     all on the range -1 to 1.
# 
# Basically, remove the below code and replace with however many steps your time 
# and interest permit so that at the end you end up with a new object called 
# processeddata on which you run a new set of reports to see what effect your 
# changes had.
processeddata <- rawdata;

# Note that we change the name of the output_file from its default value so it
# doesn't conflict with the raw report.
create_report(processeddata,output_file = 'processed.html', quiet=TRUE);
# comment out the next line if you don't want to keep seeing the interactive 
# web-app when you source this script from RStudio
#if(interactive()) explore(processeddata);  

# Again, any additional summaries or visualizations you want.
# If applicable, see if any validation checks are still failing.
#create_report(datafile)
plot_correlation(na.omit(datafile))
plot_correlation(datafile,cor_args = list(use = "pairwise.complete.obs"))

# Save Processed Data ----
# Here, put code for saving the processed data so you can open it from a 
# separate script that you will be using to analyze data. Usually a good idea
# to do analysis and preparation in separate scripts, so you don't have to wait
# for all the preparation steps to complete everytime you change something just
# in the analysis.

export(processeddata,"projectdata_processed.xlsx")


{}