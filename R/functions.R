#' DuckDB Get Query
#'
#' Use SQL to retrieve data from a DuckDB connection
#'
#' @param sql A DuckDB compliant SQL query as a string that uses `?`
#' placeholders as required by `DBI::sqlInterpolate()`
#' @param ... Additional arguments to populate the SQL query
#'
#' @return A data.frame of the results
#'
#' @examples
#' \dontrun{
#' # Provide a valid SQL query as a string
#'
#' ddbGetQuery(
#'   "
#'   SELECT title as Title, COUNT(*) as Count
#'   FROM `data/clean/accounts.csv`
#'   GROUP BY title
#'   ORDER By Count DESC;
#'   "
#' )
#'
#' # As above but use a placeholder for interpolation
#'
#' ACCOUNTS_PATH_CLEAN <- "data/clean/accounts.csv"
#'
#' ddbGetQuery(
#'   "
#'   SELECT title as Title, COUNT(*) as Count
#'   FROM ?
#'   GROUP BY title
#'   ORDER By Count DESC;
#'   ",
#'   from = ACCOUNTS_PATH_CLEAN
#' )
#' }
#'
#' @importFrom DBI dbConnect dbDisconnect sqlInterpolate dbGetQuery
#' @importFrom duckdb duckdb
#'
#' @export
ddbGetQuery <- function(sql, ...) {
  dots <- list(...)
  con <- DBI::dbConnect(duckdb::duckdb())
  on.exit(DBI::dbDisconnect(con))

  query <- DBI::sqlInterpolate(con, sql, .dots = unname(dots))

  DBI::dbGetQuery(con, query)
}


#' DuckDB Execute Query
#'
#' Use SQL to manipulate a DuckDB object, e.g. create a table or write results
#' to a file
#'
#' @param sql A DuckDB compliant SQL query as a string that uses `?`
#' placeholders as required by `DBI::sqlInterpolate()`
#' @param ... Additional arguments to populate the SQL query
#'
#' @return Numeric. The number of rows affected by the action.
#'
#' @examples
#' \dontrun{
#' # Provide a valid SQL query as a string.
#' # Reads from a csv and then writes out a new one.
#'
#' ddbExecute(
#'   "
#'   COPY (
#'     SELECT *
#'       REPLACE (
#'         title.regexp_replace('\\s|\\W', '', 'g').lower() AS title,
#'         account_type.trim().lower() AS account_type
#'       )
#'       FROM read_csv('data/raw/accounts.csv', nullstr = [' ', ''])
#'   ) TO 'data/clean/accounts.csv';
#'   "
#' )
#'
#' # As above but use placeholders for interpolation
#'
#' ACCOUNTS_PATH_RAW <- "data/raw/accounts.csv"
#' ACCOUNTS_PATH_CLEAN <- "data/clean/accounts.csv"
#'
#' ddbExecute(
#'   "
#'   COPY (
#'     SELECT *
#'       REPLACE (
#'         title.regexp_replace('\\s|\\W', '', 'g').lower() AS title,
#'         account_type.trim().lower() AS account_type
#'       )
#'       FROM read_csv(?, nullstr = [' ', ''])
#'   ) TO ?;
#'   ",
#'   from_path = ACCOUNTS_PATH_RAW,
#'   to_path = ACCOUNTS_PATH_CLEAN
#' )
#' }
#'
#' @importFrom DBI dbConnect dbDisconnect sqlInterpolate dbExecute
#' @importFrom duckdb duckdb
#'
#' @export
ddbExecute <- function(sql, ...) {
  dots <- list(...)
  con <- DBI::dbConnect(duckdb::duckdb())
  on.exit(DBI::dbDisconnect(con))

  query <- DBI::sqlInterpolate(con, sql, .dots = unname(dots))

  DBI::dbExecute(
    con,
    query
  )
}
