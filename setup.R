library(duckdb)

unlink("data.duckdb")
con <- dbConnect(duckdb(dbdir = "data.duckdb"))

args <- commandArgs(TRUE)
if (length(args) > 0) {
  n <- as.integer(args[[1]])
} else {
  n <- 1000000
}

data <- data.frame(id = seq_len(n), x = rnorm(n))

dbWriteTable(con, "data", data, overwrite = TRUE)

dbDisconnect(con)
