# Transactions exercise

My answers for part 1 of the exercise are in `part1.html`, and the report for part 2 is in `part2.html`.

## Dev environment

The code is written in R and rendered via Quarto.

In the interests of reproducibility I've made a devcontainer, which turns VS Code into a fully operational R IDE via Docker. Instead of building and running the image via the terminal you can install the VS Code devcontainer extension and launch the following via the command palette: `Dev Containers: Open Folder in Container`

VS Code will then re-open with the container operating as the backend. You can now use `radian`, have syntax-highlighting, linting, formatting, can preview Quarto renders, and so on.

The Dockerfile and devcontainer configuration are both in the `.devcontainer/` directory. It is possible to run the Dockerfile via the cli with `docker build . . .` but your mileage may vary - for example, I don't know if `radian` will work fully as expected without the settings from `.devcontainer/devcontainer.json`.

## Running the report

Put `accounts.csv` into `data/raw/`

Put `current-acc-trans.csv` into both `data/raw/` and `data/clean/`

If you have the devcontainer running you can render the outputs by running the following line in a (bash) terminal

```shell
quarto render
```

This will render all of the `.qmd` documents into HMTL outputs. You should see them appear at the root of the project folder.

If you have your own local setup for R and Quarto you can see the packages needed by looking at the `library()` calls in `part1.qmd` and `part2.qmd`. This project was rendered using Quarto v1.4.551.

## Initial datasets headers

For my reference.

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

A more structured approach to documenting the EDA.

Schemas for each of the tables throughout this workflow. I think it's particularly important that account numbers are not allowed to be guessed by e.g. the DuckDB csv parser as numeric - they should always be treated as strings.

Unit tests via `testthat` for the functions in `R/functions.R` would have been nice.

It's great to have a devcontainer available, but it would be better to also have the equivalent non-devcontainer Dockerfile for `rocker/r-ver:4.4` alongside the devcontainer one. It's probably a slimmer image, and not everyone uses VS Code as their IDE.

Code for the account open/close dates analysis could potentially be re-worked. I think it would be interesting to see the two plots faceted by account type.

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