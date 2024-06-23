# Transactions exercise

## Initial datasets headers

```shell
head -n 1 data/current-acc-trans.csv

acc_number
trans_id
trans_date
post_date
type
description
amount
```

```shell
head -n 1 data/accounts.csv

account_number
open_date
close_date
title
forename
middle_name
surname
address1
city
postcode
home_tel
mobile_tel
email
account_type
overdraft_limit
cash_card_number
```

## If I had more time

A more structured approach to documenting the EDA would have been nice.

Schemas for each of the tables throughout this workflow. I think it's particularly important that account numbers are not allowed to be guessed by e.g. the DuckDB csv parser as numeric - they should always be treated as strings.

Unit tests via `testthat` for the functions in `R/functions.R` would have been nice, too.

And of course, better-looking visualisations.

## Choice of DuckDB

I chose to use DuckDB for most of the data wrangling for two reasons

1. The transactions dataset is approx 1.5M rows. This might not be larger-than-memory for my laptop. But why risk it? It is also quite fast computationally, especially for aggregating
2. For fun, and to learn! I recently [took a workshop](https://grantmcdermott.com/duckdb-polars/) on DuckDB and polars. This is the first opportunity I've had to put it into practice. I also wanted to try out DuckDB's dialect of "friendly SQL", which seemed like a good challenge without being super intimidating: I use PostgreSQL, which is compatible with DuckDB's dialect.

## DBI/DuckDB wrapper functions

Because I was mostly writing the SQL myself, it seemed right to make wrappers around DBI and DuckDB, resulting in `ddbExecute()` and `ddbGetQuery()`.

The advantages are

- Connections are explicitly opened and closed for each query/execution, making for a cleaner and more stable environment
- Hides repetitive code away
- Ability to parameterise the queries. No hard-coded values being given to the SQL strings, rather I could pass in references to global variables