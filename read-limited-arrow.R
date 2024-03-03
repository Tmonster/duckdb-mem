library(duckdb)
library(arrow)
library(dbplyr)
library(tidyverse)

con <- dbConnect(duckdb(dbdir = "data.duckdb"))
dbExecute(con, paste0("PRAGMA temp_directory='", tempdir(), "'"))

dbExecute(con, "PRAGMA memory_limit='10MB'")

args <- commandArgs(TRUE)
if (length(args) > 0) {
  n <- as.integer(args[[1]])
} else {
  n <- 2^22
}

data <- tbl(con, sql(paste0("FROM data LIMIT ", n))) |> to_arrow() |> collect()
saveRDS(data, "data.rds")

dbDisconnect(con)
