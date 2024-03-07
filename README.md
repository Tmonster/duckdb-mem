
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
#> 
#> Call:
#> lm(formula = mem ~ workload, data = resident_size)
#> 
#> Coefficients:
#>            (Intercept)         workloadlimited      workloadlimited_20  
#>                141.308                  -3.578                  -2.989  
#>         workloadmanual  workloadmanual_limited               workloadr  
#>                 -2.750                  -7.194                 -20.835  
#>       workloadregister  
#>                -15.502


# A tibble: 7 × 5
  workload       mem_min mem_max mem_delta overhead
  <chr>            <dbl>   <dbl>     <dbl>    <dbl>
1 r                 214.   2134.     1920.     1
2 register          278.   3158.     2880.     1.50
3 limited           405.   4595.     4190.     2.18
4 manual            402.   5103.     4702.     2.45
5 manual_limited    402.   5109.     4707.     2.45
6 duckdb            404.   5114.     4710.     2.45
7 limited_20        407.   5118.     4710.     2.45

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



