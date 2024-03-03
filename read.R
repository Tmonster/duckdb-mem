library(duckdb)
library(arrow)
library(dbplyr)
library(tidyverse)

con <- dbConnect(duckdb(dbdir = "data.duckdb"))
dbExecute(con, paste0("PRAGMA temp_directory='", tempdir(), "'"))

args <- commandArgs(TRUE)
if (length(args) > 0) {
  n <- as.integer(args[[1]])
} else {
  n <- 2^22
}

data <- dbGetQuery(con, paste0("SELECT * FROM data LIMIT ", n))
saveRDS(data, "data.rds")

dbDisconnect(con)
