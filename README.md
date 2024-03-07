
<!-- README.md is generated from README.Rmd. Please edit that file -->

# duckdb-mem

<!-- badges: start -->
<!-- badges: end -->

The goal of duckdb-mem is to analyze the memory usage of DuckDB.

## `dbWriteTable()`

Running variants of the code in `setup.R`, by `run_setup.R`:

- duckdb: Baseline
- r: Without `dbWriteTable()`, measures size of dataframe in memory (about 2.2 for the largest df)
- limited: With a duckdb memory limit of 1.5 GB
- limited_20: With a duckdb memory limit of 3 GB
- register: With `duckdb_register()` instead of `dbWriteTable()` : no memory limit
- manual: With `duckdb_register()` and `CREATE TABLE` instead of
  `dbWriteTable()` : no memory limit
- manual_limited: With `duckdb_register()`, `CREATE TABLE`, and a duckdb
  memory limit of 1.5 GB

![](Rplots.pdf)<!-- -->

These numbers are most likely no longer accurate, as the memory measurement method may have changed 
i.e `time -l` vs. `time -v` with pipes to grep maximum resident set size.
```
Call:
lm(formula = mem ~ n + workload, data = resident_size)

Coefficients:
           (Intercept)                       n         workloadlimited
             9.333e+02               1.394e-05              -6.589e+02
    workloadlimited_20          workloadmanual  workloadmanual_limited
            -3.422e+02              -5.521e+00              -6.615e+02
             workloadr        workloadregister
            -1.959e+03              -1.287e+03

# A tibble: 7 × 5
  workload       mem_min mem_max mem_delta overhead
  <chr>            <dbl>   <dbl>     <dbl>    <dbl>
1 r                 214.   4182.     3968      1
2 register          278.   6230.     5952.     1.50
3 manual_limited    402.   7222.     6821.     1.72
4 limited           403.   7226.     6823.     1.72
5 limited_20        403.   8182.     7778.     1.96
6 manual            400.  10134.     9734.     2.45
7 duckdb            405.  10146.     9741.     2.45
```
### Conclusion

- Registering the data frame consumes a bit of memory, but not that
  much.
- The `setup-manual.R` script is equivalent to `setup.R` in terms of
  memory usage, but uses functions at a lower level compared to
  `dbWriteTable()`.
- The `CREATE TABLE` statement in `setup-manual.R` seems to be
  responsible for the memory overhead.
- Despite the limit of 1.5GB DuckDB memory in `setup-manual-limited.R`,
  the memory overhead is over 2GB.



