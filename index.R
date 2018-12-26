#!/SYSTEM/R/3.5.1/bin/Rscript
# `simrc` should contain `module load gcc/5.3.0` and `module load R/3.5.1`

options(bitmapType='cairo')
if (length(intersect(dir(), "result")) == 0) { system("mkdir result") }
system('cp plotly.json ./result')

input_deck <- 'Data NCAResult4BE
Design 2x2'

arguments <- commandArgs(trailingOnly = TRUE) 
if (length(arguments) == 0) { arguments <- c("-inp", input_deck) }

# Library ----

if (Sys.info()['sysname'] == 'Linux') { .libPaths('./lib') }

library(BE)
library(dplyr)
library(tidyr)
library(tibble)
library(readr)
library(purrr)
# library(ggplot2)
# library(knitr)

# main ----

data_raw <- read_delim(arguments[2], delim = ' ', col_names = c('parameter', 'value')) %>%
  spread(parameter, value) %>%
  print()

if (data_raw$Data == 'NCAResult4BE') test_data <- BE::NCAResult4BE


pk_parameters <- c(AUClast = 'AUClast', Cmax = 'Cmax', Tmax = 'Tmax')

# pk_parameters %>%
#   map( ~ print(test2x2(test_data, .x), na.print="") )
#BE::be2x2(test_data, pk_parameters)

setwd('./result')
capture.output(BE::be2x2(test_data, pk_parameters), file = 'report.txt')
system('convert Rplots.pdf Rplots.jpg')
system('convert Rplots1.pdf Rplots1.jpg')
system('convert Rplots2.pdf Rplots2.jpg')
system('convert Rplots3.pdf Rplots3.jpg')
system('convert Rplots4.pdf Rplots4.jpg')
system('convert Rplots5.pdf Rplots5.jpg')
setwd('..')

print(getwd())

knitr::knit2html("report.Rmd", 
                 "result/report.html", 
                 options = c("toc", "mathjax"))

