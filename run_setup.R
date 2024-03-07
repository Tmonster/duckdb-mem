library(tidyverse)

n <- 2^(24:29)
# 2^28 peaks at 2.3-2.5 GB in memory

out_duckdb <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-v", "Rscript", "setup.R", .x, "2>&1", ">/dev/null", "|", "grep", "Maximum"), stdout = TRUE, stderr = FALSE))
duckdb <- tibble(n, out = out_duckdb)

out_r <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-v", "Rscript", "setup-r.R", .x, "2>&1", ">/dev/null", "|", "grep", "Maximum"), stdout = TRUE, stderr = FALSE))
r <- tibble(n, out = out_r)

out_limited <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-v", "Rscript", "setup-limited.R", .x, "2>&1", ">/dev/null", "|", "grep", "Maximum"), stdout = TRUE, stderr = FALSE))
limited <- tibble(n, out = out_limited)

out_limited_20 <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-v", "Rscript", "setup-limited-20.R", .x, "2>&1", ">/dev/null", "|", "grep", "Maximum"), stdout = TRUE, stderr = FALSE))
limited_20 <- tibble(n, out = out_limited_20)

out_register <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-v", "Rscript", "setup-register.R", .x, "2>&1", ">/dev/null", "|", "grep", "Maximum"), stdout = TRUE, stderr = FALSE))
register <- tibble(n, out = out_register)

out_manual <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-v", "Rscript", "setup-manual.R", .x, "2>&1", ">/dev/null", "|", "grep", "Maximum"), stdout = TRUE, stderr = FALSE))
manual <- tibble(n, out = out_manual)

out_manual_limited <- map(n, .progress = TRUE, ~ system2("/usr/bin/time", c("-v", "Rscript", "setup-manual-limited.R", .x, "2>&1", ">/dev/null", "|", "grep", "Maximum"), stdout = TRUE, stderr = FALSE))
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
