library(tidyverse)
require(DBI, quietly=TRUE)  
require(odbc, quietly=TRUE)
require(dplyr, quietly=TRUE)
require(pwr,quietly=TRUE)
library(readr)
library(purrr)
library(ggplot2)
library(stringr)
library(cowplot)

setwd("C:/Users/gglbs/OneDrive - Bayer/MyDocs/STAT/PowerAnalysis/Rfiles")

connection <- DBI::dbConnect(odbc::odbc(), driver = "SQL Anywhere 17",
                             host = "by0vpb.bayer.cnb", database = "scout2w2",
                             port = 2638, uid = "tsaapp", pwd = "tsa2019")

#.libPaths()


