
<!-- README.md is generated from README.Rmd. Please edit that file -->

# duckdb-mem

<!-- badges: start -->
<!-- badges: end -->

The goal of duckdb-mem is to analyze the memory usage of DuckDB.

## `dbWriteTable()`

Running variants of the code in `setup.R`, by `run_setup.R`:

- duckdb: Baseline
- r: Without `dbWriteTable()`
- limited: With a duckdb memory limit of 10 MB
- limited_20: With a duckdb memory limit of 20 MB
- register: With `duckdb_register()` instead of `dbWriteTable()`
- manual: With `duckdb_register()` and `CREATE TABLE` instead of
  `dbWriteTable()`
- manual_limited: With `duckdb_register()`, `CREATE TABLE`, and a duckdb
  memory limit of 10 MB

![](README_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

### Linear model

    #> 
    #> Call:
    #> lm(formula = mem ~ workload, data = resident_size)
    #> 
    #> Coefficients:
    #>            (Intercept)         workloadlimited      workloadlimited_20  
    #>                140.243                  -2.672                  -1.467  
    #>         workloadmanual  workloadmanual_limited               workloadr  
    #>                 -1.402                  -6.752                 -17.676  
    #>       workloadregister  
    #>                -16.152

### Overhead

    #> # A tibble: 7 × 5
    #>   workload       mem_min mem_max mem_delta overhead
    #>   <chr>            <dbl>   <dbl>     <dbl>    <dbl>
    #> 1 r                 113.    151.      37.9     1   
    #> 2 register          113     156.      42.5     1.12
    #> 3 manual_limited    115.    173.      58.5     1.54
    #> 4 limited           117.    179.      61.6     1.63
    #> 5 limited_20        117.    186.      68.2     1.80
    #> 6 duckdb            117.    200.      82.5     2.18
    #> 7 manual            115.    200.      84.9     2.24

### Conclusion

- Registering the data frame consumes a bit of memory, but not that
  much.
- The `setup-manual.R` script is equovalent to `setup.R` in terms of
  memory usage, but uses functions at a lower level compared to
  `dbWriteTable()`.
- The `CREATE TABLE` statement in `setup-manual.R` seems to be
  responsible for the memory overhead.
- Despite the limit of 10MB DuckDB memory in `setup-manual-limited.R`,
  the memory overhead is 25MB.
