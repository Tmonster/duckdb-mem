library(tidyverse)

n <- 2^(16:22)

out_duckdb <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-l", "Rscript", "read.R", .x), stdout = TRUE, stderr = TRUE))
duckdb <- tibble(n, out = out_duckdb)

out_limited <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-l", "Rscript", "read-limited.R", .x), stdout = TRUE, stderr = TRUE))
limited <- tibble(n, out = out_limited)

out_limited_20 <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-l", "Rscript", "read-limited-20.R", .x), stdout = TRUE, stderr = TRUE))
limited_20 <- tibble(n, out = out_limited_20)

out_limited_collect <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-l", "Rscript", "read-limited-collect.R", .x), stdout = TRUE, stderr = TRUE))
limited_collect <- tibble(n, out = out_limited_collect)

out_limited_collect_from <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-l", "Rscript", "read-limited-collect-from.R", .x), stdout = TRUE, stderr = TRUE))
limited_collect_from <- tibble(n, out = out_limited_collect_from)

out_limited_n <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-l", "Rscript", "read-limited-n.R", .x), stdout = TRUE, stderr = TRUE))
limited_n <- tibble(n, out = out_limited_n)

out <- bind_rows(
  duckdb = duckdb,
  limited = limited,
  limited_20 = limited_20,
  limited_collect = limited_collect,
  limited_collect_from = limited_collect_from,
  limited_n = limited_n,
  .id = "workload"
)

saveRDS(out, "read.rds")
