#'---
#' title: "TSCI 5050: Introduction to Data Science"
#' author: 'Author One JC MYERS ^1^, Author Two ^1^'
#' abstract: |
#'  | Provide a summary of objectives, study design, setting, participants,
#'  | sample size, predictors, outcome, statistical analysis, results,
#'  | and conclusions.
#' documentclass: article
#' description: 'Manuscript'
#' clean: false
#' self_contained: true
#' number_sections: false
#' keep_md: true
#' fig_caption: true
#' output:
#'  html_document:
#'    toc: true
#'    toc_float: true
#'    code_folding: show
#' ---
#'
#+ init, echo=FALSE, message=FALSE, warning=FALSE
# init ----
# This part does not show up in your rendered report, only in the script,
# because we are using regular comments instead of #' comments
debug <- 0;
knitr::opts_chunk$set(echo=debug>-1, warning=debug>0, message=debug>0);

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
library(correlationfunnel)

options(max.print=42);
panderOptions('table.split.table',Inf); panderOptions('table.split.cells',Inf);
whatisthis <- function(xx){
  list(class=class(xx),info=c(mode=mode(xx),storage.mode=storage.mode(xx)
                              ,typeof=typeof(xx)))};
# R basic syntax ----
#'
#' # R basic syntax
#'
#' ## Assignment
#'
#' To store a value as variable `foo` in R the convention is to use the
#' `<-` operator, not `=`. This makes it easier to distinguish stand-alone
#' expressions from function arguments.

#+ assignment_operator
foo <- 500;
bar <- foo <- 500;
bar <- foo;
hello <- 100;
#' It's not a formal rule, it's rarely even written down, but `foo`, `baz`,
#' `bat`, etc. are throw-away variables people use for testing. If you need more
#' test variables, just make up three letter ones that start with `b`.
#' If you see one of those in a script you're reviewing it means it is left over
#' from when that code was being debugged. Example code shared with this class
#' will usually use `foo` and friends to represent the parts of an expression
#' that should be replaced with whatever values you are using instead of being
#' used literally. Shorter than having to write `YOURFUNCTIONHERE` or
#' `YOURARGUMENTHERE` each time.
#'
#' This is not specific to R-- it's just a little quirk of programming culture
#' in general. A quirk with a practical consequence: _never use `foo`, `bar`,
#' `baz`, `bat`, etc. in your production (i.e. finalized) code_ because
#' otherwise you or somebody else debugging your code will attempt to use those
#' names as test variables and in some situations this could overwrite the
#' existing variables!
#'
#' ## Comments
#'
#' `#'` This indicates that this line should be formatted as text. It must be
#' the first two characters in that line in order to work.
#'
#' `#+` This indicates that the following lines (until the next #' or #+) should
#' be treated as a "code chunk". I.e. the next lines (but not this one) will be
#' run, the code will be displayed according to your settings and the results
#' will be displayed according to your settings.
#'
#' `#` This is an ordinary comment. Everything after it on the same line is not
#' executed.
#'
#' # Functions and Data Types
#'
#' ## Functions and Simple Data Types
#'
#' Numeric. You can do arithmetic on them: `+`, `-`, `/`, `*`, `^`, `log()`,
#' `exp()`, `sqrt()`

#+ assignment_numeric
foo <- 2+2; foo
foo <- 5*2; foo
foo <- log(2); foo
foo <- exp(100); foo
log(foo)
bar <- 5*5; bar
whatisthis(bar);
print(foo <- 42)
print (shoo <-67)
log(((foo*3)+(shoo+2)*sqrt(144)+exp(10)))
#' Character strings. Create these by wrapping single (`'`) or double (`"`)
#' quotes around the value.

#+ assignment_string
a <- "Donot panic"
print(a)
coo <- "Donot panic"; coo
a <- "Donot panic"; a
b <- 'Donot panic'; b
c <- "Don't panic"; c
d <- 'The "Heart of Gold" comes equipped with heated leather seats and an infinite improbability drive'; d
print (d)
e <- 42; e
e <- "42"; e
#' Logical values are `TRUE` or `FALSE`. Can also be created using `>`, `<`,
#' `==`, `!=`, `>=`, `<=`

#+ assignment_logical
foo > 25     ;#' assign variable foo
shoo >100    ;#' assign variable shoo
foo >= 40    ; #' using operator
foo != 42    ; #' using NOT operator
foo == 42    ; #' using EQUAL operator
shoo == 42   ; #' using operator
foo <50 & shoo<100 ; #' using 'AND' operator
foo<50 | shoo>100; #' using OR operator
foo<50 | shoo<50
foo>50 | shoo<50
! foo>50
!(shoo>50);  #' using NOT operator
! foo>50 & shoo>50


#' Missing values are represented by `NA` (no quotes for any of these). Null
#' values are _not_ the same as missing and they are represented by `NULL`. In
#' some circumstances you might also run into `Inf`, `-Inf`, and `NaN`. These
#' often indicate errors somewhere else in your code.

#' Dates and times. Can be created with the `Sys.Date()` or `Sys.time()`
#' functions or converted from a character string using `as.Date()`.

#+ assignment_datetime
Sys.Date()
Sys.time()
#?as.Date
my_date <- "2022-01-31"; #' create example date
print (my_date)       ; #' print my_date variable
class (my_date)       ; #' check class of the variable
new_date <- as.Date(my_date) ; #' convert character string
new_date                      ; #' print new_date
class(new_date)               ;#' check class of new_date
as.Date(new_date, tryFormats = c("%y-%m-%d"))
#' Factors are basically integers that have labels. They are a human-readable
#' alternative to using integer codes for discrete data. These will make more
#' sense after we talk about vectors in the next section.

#+ factor_example

#+ assignment_wierd

#' ## Data Structures
#'
#' Of course we usually need to work with variables bundled together, not single
#' values.
#'
#' ### Vectors
#'
#' The default data structure in R is a `vector`. You create one with the `c()`
#' command with any number of arguments. All items in a vector have to be the
#' same type.

#+ vectors_c
print(foo <- c(56,78,34,97,2,86))
print(baz <- c(34,23,94,3,12,53))
#' Since the default data structure in R is a `vector`, if you
#' create some sort of simple value you are creating a `vector` even if you are
#' not using `c()`... it just happens to be a `vector` of length 1. These
#' are identical, and both return `1` when used with the `length()` function.

#+ vectors_length1
length(foo)
#' If you want to create a sequence of consecutive integers, you can use the `:`
#' operator.

#+ vectors_sequence
25:76
65:38
-32:12
seq_len(12)
#' In most other languages, you need to use a `for` loop in order to perform
#' some sort of change to a series of values. In R, you often don't have to
#' when you are working with vectors because a lot of functions (including all
#' the arithmetic and logical ones above) and be applied to a vector and they
#' work. If the function involves multiple vectors (e.g. `+`), usually you'll
#' want all of them to be either the same length or length 1.

#+ vectors_operators
foo+6
foo+baz
foo>=34
baz<=23
bob <- baz<=23
c(baz,foo)
c(baz,foo,"76")
# These work with all arithmetic operators
#' You can assign names to some or all members of a vector when you create it.
#' You can also assign or re-assign names later using the `names()` function.

#+ vectors_names1, error=TRUE
jar <- c(a="cat", best="dog", c= "fish", slow="turtle")
print(jar)
# jar[best]
jar["best"]
jar[c("best","c")]
#' You can also use it to see the currently assigned names.

#+ vectors_names2
names(jar) <- c("libby", "beau", "bob", "bob2") # renaming
print(jar)
names(jar)
names(jar)[3]
names(jar)[3] <- "milo" # renames only one element
jar
#' You can subset a vector by using `[...]` with the `...` replaced by _another_
#' vector, of integers indicating which positions you want to extract. Or you
#' could use a vector of names.

#+ vectors_subset1
foo[3]
#' If you just need a single value, use a single name or number.

#+ vectors_subset2

#' If you need a series of adjacent values, use `:`. If you need several
#' adjacent series with interruptions between them, use `c()` with `:`
#' expressions separated by commas `,`.

#+ vectors_subset3
foo[c(1,2,3)]
foo[1:3]
foo[c(1:3,5:6)]
baz
bob
baz[bob] # pulled the vector less than equal to 23
print(foo)
summary(foo)
table(foo)
table(jar) # frequency table
bat <- sample(1:10, 30, replace = TRUE)
table(bat)
bat <- sample(1:10, 30, replace = TRUE)*1000
table(bat)
bat
head(bat) # top 6 elements
tail(bat) # last 6 elements
diff(bat) # difference between two values
sum(bat) # sums all values
seq_along(bat) # sequence all values
sum(bat, na.rm= TRUE) # for missing values
#' Other useful functions for exploring vectors: `length()`, `summary()`,
#' `table()`, `head()`, `tail()`, `sum()`, `diff()`, `seq_along()`.

#+ vectors_explore


#' Here are some aggregation functions. For these, make sure to use `na.rm=T` if
#' your vector has `NA`s in it... `max()`, `min()`, `mean()`, `median()`,
#' `quantile()`.
quantile(bat) # tells quantiles
quantile(bat, na.rm=TRUE)
#+ vectors_aggregate

#' ### Data Frames
#'
#' You can bundle several vectors of the same length together into a
#' `data.frame` using the `data.frame()` command. A `data.frame` is a tabular
#' data structure where the columns can be different types from each other
#' (though within each column the type will be uniform because each column is
#' still a vector). Most data in R is in the form of a `data.frame` or a class
#' that inherits from `data.frame`. The `dplyr` package makes working with
#' `data.frames` easier and a lot of attention will be devoted to `dplyr`
#' [below](#data-frames-indepth). For now, here are some basic commands for
#' exploring `data.frames`: `dim()`, `nrow()`, `ncol()`, `names()` and (for
#' small datasets) `plot()`.

#+ df_explore
dim(iris)
nrow(iris)
ncol(iris)
names(iris)
head(iris)
tail(iris)
head(iris,10)
#' how to select rows
#+ df_subset
iris[3:20,]
iris[c(2:10,34,40:50,34,34,34),]
iris[-c(3:20),]
seq_len(nrow(iris))

sample(seq_len(nrow(iris)), 10)  # sample without replacement
sample(seq_len(nrow(iris)), 10, replace= TRUE) # sample with replacement
iris0 <- iris[sample(seq_len(nrow(iris)), 10),]

#' How to select coulmns in dataset
#+ df_columns, error=TRUE, results="hide"
iris[,1:3] # columns miss 4 and 5
iris[,c("Petal.Length","Petal.Width","Species")]
prevar <- c("Petal.Length","Petal.Width","Species")  # define columns together
iris[,prevar]



iris$Species # picks the column from dataset by adding $sign
outcome <- "Species"
iris$outcome
iris[[outcome]]
iris [["Species"]]

#' how to select columns and rows at same time
#+ df_columnsrows
iris[4:10,prevar]

#' load the veteran cancer dataset
data(veteran)
#sequence of rows from a specific row to another
1:nrow(veteran)
#entire sequence of rows
seq_len(nrow(veteran))
#to randomly select any 5 rows from the table
sample(seq_len(nrow(veteran)), 5)
mycolumn <- "time"
veteran[[mycolumn]]
#extract time value for the 5 first rows
veteran[[mycolumn]][1:5]
#extract time value for random 5 rows
veteran[[mycolumn]][sample(seq_len(nrow(veteran)), 5)]
veteran$time[sample(seq_len(nrow(veteran)), 5)]
veteran[ ,mycolumn][sample(seq_len(nrow(veteran)), 5)]
veteran[sample(seq_len(nrow(veteran)), 5),mycolumn]
veteran
veteran[sample(seq_len(nrow(veteran)), 5),mycolumn] <- NA
veteran
#'recreating veteran dataset
rm(veteran)
data("veteran")
names(veteran)
mycolumns <- names(veteran)
#' randomly removing values from each column
for (xx in mycolumns) {print(xx)
  
}
for (xx in mycolumns) {
  message("processing ", xx)
  veteran[sample(seq_len(nrow(veteran)), 5),xx] <- NA
  
}
veteran
veteran$time
is.na(veteran$time)
#' replace missing time with max survival time
ifelse(is.na(veteran$time), max(veteran$time,na.rm = TRUE), veteran$time)

#' # Datasets and `dplyr`
#+ Working with datasets and DPLYR
veteran[[mycolumn]][sample(seq_len(nrow(veteran)), 5)]
nrow(veteran) %>% seq_len() %>% sample(5) %>% slice(veteran, .) %>% select(mycolumn) %>% unlist %>% unname
#in the pipeline, what's on the left of the pipe operator %>% becomes the first argument for the expression to the right of the pipe. if I want the expression to become second argument or else, i put "." in the place that I want it.
# slice if for choosing rows from the dataset
nrow(veteran) %>% seq_len() %>% sample(5) %>% slice(veteran, .) %>% pull(mycolumn)
export(veteran,"veteran.xlsx",overwrite = TRUE)
export(veteran,"veteran.csv")
export(veteran,"veteran.tsv")

#' #' ## Introduction to `dplyr`
veteran2 <- import("veteran.xlsx",which=1)
veteran3 <- mutate(veteran2, trt=factor(trt, levels=1:2, labels=c("standard","test"))
                   , prior=factor(prior, levels=c(0,10), labels=c("no","yes"))
                   , sim_derivative=replicate(n(),sample(10,1) %>% runif() %>% paste(collapse=";"))
                   ,diagtimedays=diagtime*30)

summarise(veteran3, Sample_size=n(), median_survival=median(time, na.rm=TRUE)
          , mean_survival=mean(status, na.rm=TRUE))

group_by(veteran3, trt) %>%
  summarise(Sample_size=n(), median_survival=median(time, na.rm=TRUE), mean_survival=mean(status, na.rm=TRUE))

#' # Linear Models
#+ linear_models

Nulltime <- time~1
Karnotime <- update(Nulltime,.~.+karno)
update(Karnotime,.~.-karno)
predictors <- update(Karnotime,.~.+diagtime)
formulas <- list(Nulltime = Nulltime, Karnotime = Karnotime, predictors=predictors)
update(Karnotime,.~.+diagtime+prior)
VetLM <- lm(time~1,veteran3)
VetLM
summary(VetLM)
tidy(VetLM)
mean(veteran3$time,na.rm=TRUE)
update(VetLM,.~.+karno)



## Automatically fitting multiple linear models
vetlmmodels <- lapply(formulas,function(xx) lm(xx,data=veteran3) %>% update(.~.))

summary(VetLM) # gives detail summary
summary(VetLM)$coeff # gives coefficient column
glance(VetLM) #gives brief
tidy(VetLM) # gives tidy cleaner version inside
lm(mpg~hp+wt+vs,mtcars) %>% tidy() %>% select(c("estimate","p.value"))
#+ Debugging
VetLM %>% tidy() %>% select(c("estimate","p.value"))
VetLM %>% tidy() %>% select(c("estimate","p.value")) %>% slice(-1) # removes top row
VetLM %>% tidy() %>% select(c("estimate","p.value")) %>% slice((1:3)) # gives 1 to 3 rows
VetLM %>% tidy() %>% select(c("estimate","p.value")) %>% slice(-(1:3)) # removes 1 to 3 rwos
whatisthis(VetLM) # gives class of the variable

#' View(VetLM) # view inside of object

#+ ## multiple comparison
VetLM %>% tidy() %>% select(c("p.value")) %>% slice(-1)
#'VetLM %>% tidy() %>% select(c("p.value")) %>% slice(-1) %>% p.adjust()
VetLM %>% tidy() %>% select(c("p.value")) %>% slice(-1) %>% unlist() %>% p.adjust()

plot(vetlmmodels$predictors)
vetlmmodels
#create_report(veteran3)
plot_correlation(na.omit(veteran3))
plot_correlation(veteran3,cor_args = list(use = "pairwise.complete.obs"))
dummify(veteran3[,-9]) %>% cor(use='pairw')
dummify(select(veteran3,-"sim_derivative")) %>% cor(use='pairw')

#explore(veteran3)
predictorstotime <- na.omit(veteran3) %>% select(-"sim_derivative") %>% binarize()
predictorscorr <- correlate(predictorstotime, use='pairw', target=grep(pattern="^time.*Inf$", names(predictorstotime) , value = TRUE))
plot_correlation_funnel(predictorscorr)

export(veteran3,"projectdata.xlsx")
