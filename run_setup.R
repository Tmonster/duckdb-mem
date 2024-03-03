library(tidyverse)

n <- 2^(16:22)

out_duckdb <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-l", "Rscript", "setup.R", .x), stdout = TRUE, stderr = TRUE))
duckdb <- tibble(n, out = out_duckdb)

out_r <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-l", "Rscript", "setup-r.R", .x), stdout = TRUE, stderr = TRUE))
r <- tibble(n, out = out_r)

out_limited <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-l", "Rscript", "setup-limited.R", .x), stdout = TRUE, stderr = TRUE))
limited <- tibble(n, out = out_limited)

out_limited_20 <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-l", "Rscript", "setup-limited-20.R", .x), stdout = TRUE, stderr = TRUE))
limited_20 <- tibble(n, out = out_limited_20)

out_register <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-l", "Rscript", "setup-register.R", .x), stdout = TRUE, stderr = TRUE))
register <- tibble(n, out = out_register)

out_manual <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-l", "Rscript", "setup-manual.R", .x), stdout = TRUE, stderr = TRUE))
manual <- tibble(n, out = out_manual)

out_manual_limited <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-l", "Rscript", "setup-manual-limited.R", .x), stdout = TRUE, stderr = TRUE))
manual_limited <- tibble(n, out = out_manual_limited)

out <- bind_rows(
  duckdb = duckdb,
  r = r,
  limited = limited,
  limited_20 = limited_20,
  register = register,
  manual = manual,
  manual_limited = manual_limited,
  .id = "workload"
)

saveRDS(out, "setup.rds")
