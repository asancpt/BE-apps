#!/SYSTEM/R/3.5.1/bin/Rscript
# `simrc` should contain `module load gcc/5.3.0` and `module load R/3.5.1`

if (length(intersect(dir(), "result")) == 0) { system("mkdir result") }
system('cp assets/* ./result')

options(bitmapType='cairo')

# Library ----

if (Sys.info()['sysname'] == 'Linux') { .libPaths('./lib') }
library(BE)
library(dplyr)
library(tidyr)
library(tibble)
library(readr)
library(purrr)

# Arguments ----

input_deck <- 'Data NCAResult4BE
Design 2x2'

arguments <- commandArgs(trailingOnly = TRUE) 
if (length(arguments) == 0) { arguments <- c("-inp", input_deck, "-file", "NCAResult4BE.csv") }

table_args <- matrix(arguments, ncol = 2, byrow = TRUE) %>% 
  as_tibble() %>% 
  mutate(V1 = sub('-', '', V1)) %>% 
  spread(V1, V2) %>% 
  print()

# main ----

data_raw <- read_delim(table_args$inp, delim = ' ', col_names = c('parameter', 'value')) %>%
  spread(parameter, value) %>%
  print()

if (data_raw$Data == 'NCAResult4BE') test_data <- BE::NCAResult4BE
if (length(table_args$file) == 1) test_data <- read_csv(table_args$file)

pk_parameters <- c(AUClast = 'AUClast', Cmax = 'Cmax', Tmax = 'Tmax')

setwd('./result')
capture.output(BE::be2x2(as.data.frame(test_data), 
                         pk_parameters), 
               file = 'report.txt')
dev.off(); dev.off(); dev.off(); dev.off(); dev.off(); dev.off() # suppression 6 times

magick <- ifelse(Sys.info()['sysname'] == 'Linux', yes = 'convert', no = 'magick')  
system(sprintf('%s -density 300 Rplots.pdf  Rplots.png', magick))
system(sprintf('%s -density 300 Rplots1.pdf Rplots1.png', magick))
system(sprintf('%s -density 300 Rplots2.pdf Rplots2.png', magick))
system(sprintf('%s -density 300 Rplots3.pdf Rplots3.png', magick))
system(sprintf('%s -density 300 Rplots4.pdf Rplots4.png', magick))
system(sprintf('%s -density 300 Rplots5.pdf Rplots5.png', magick))
system('cp Rplots*.png ../Rplots/')
setwd('..')

# Rmarkdown ----

knitr::knit2html("README.Rmd", "result/report.html", options = c("toc", "mathjax"))
knitr::knit2html("raw_data.Rmd", "result/raw_data.html", options = c("toc", "mathjax"))

