library(duckdb)

unlink("data.duckdb")
con <- dbConnect(duckdb(dbdir = "data.duckdb"))
dbExecute(con, paste0("PRAGMA temp_directory='", tempdir(), "'"))

dbExecute(con, "PRAGMA memory_limit='500MB'")
dbExecute(con, "PRAGMA threads=1")

args <- commandArgs(TRUE)
if (length(args) > 0) {
  n <- as.integer(args[[1]])
} else {
  n <- 2^22
}

data <- data.frame(id = seq_len(n), x = rnorm(n))

duckdb_register(con, "temp", data)

dbExecute(con, "CREATE TABLE data AS SELECT * FROM temp")

dbDisconnect(con)
