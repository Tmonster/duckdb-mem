
<!-- README.md is generated from README.Rmd. Please edit that file -->

# duckdb-mem

<!-- badges: start -->
<!-- badges: end -->

The goal of duckdb-mem is to analyze the memory usage of DuckDB.

The following tests are run on a c6id.4xlarge (16 cores, 32 GB of memory.)

## `dbWriteTable()`

Running variants of the code in `setup.R`, by `run_setup.R`:

- duckdb: Baseline
- r: Without `dbWriteTable()`, measures size of dataframe in memory (about 2.2 for the largest df)
- limited: With a duckdb memory limit of 1.5 GB
- limited_20: With a duckdb memory limit of 3 GB
- register: With `duckdb_register()` instead of `dbWriteTable()` : no memory limit
- manual: With `duckdb_register()` and `CREATE TABLE` instead of
  `dbWriteTable()` : no memory limit
- manual_limited: With `duckdb_register()`, `CREATE TABLE`, and a duckdb memory limit of 1.5 GB

- 16 duckdb threads active

![](Rplots-no-thread-limit.pdf)<!-- -->

Modification 
- limited: With a duckdb memory limit of 1 GB
- limited_20: With a duckdb memory limit of 2 GB
- 8 duckdb threads active


![](Rplots-thread-limiting.pdf)

Modification 
- limited: With a duckdb memory limit of 500 MB
- limited_20: With a duckdb memory limit of 1 GB
- Only 1 duckdb thread active

![](Rplots-1-thread-low-mem.pdf)


### Conclusion

- Registering the data frame consumes a bit of memory, **more than the memory limit**.
- Registering the dataframe has the highest overhead when duckdb has a constrained memory limit. 
- When copying the dataframe, the memory limit is respected compared to the memory in use when registering.
- manual and duckdb are equivalent (hard to see unless you zoom in)




