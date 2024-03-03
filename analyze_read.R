library(tidyverse)

read <- readRDS("read.rds")

resident_size <-
  read |>
  mutate(res = map_chr(out, ~ grep("resident", .x, value = TRUE))) |>
  mutate(mem = map_dbl(res, ~ as.numeric(str_extract(.x, "\\d+")) / 2^20))

ggplot(resident_size, aes(x = n, y = mem, color = workload)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "Resident memory usage",
       x = "Number of rows",
       y = "Resident memory (MB)") +
  theme_minimal()

lm(mem ~ n + workload, data = resident_size)

max <-
  resident_size |>
  filter(.by = workload, n == max(n)) |>
  select(workload, mem_max = mem)

min <-
  resident_size |>
  filter(.by = workload, n == min(n)) |>
  select(workload, mem_min = mem)

left_join(min, max, join_by(workload)) |>
  mutate(mem_delta = mem_max - mem_min) |>
  arrange(mem_delta) |>
  mutate(overhead = mem_delta / mem_delta[[1]])
