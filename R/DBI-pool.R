#' @include DBI.R
NULL

#' Release a connection back to the pool
#'
#' A wrapper around \code{release(conn)}. Unlike its namesake in DBI,
#' in the context of the \code{pool} package, \code{dbDisconnect} does
#' not close the connection and free the associated resources. Rather,
#' it simply releases the connection back to pool, which then decides
#' whether to keep it around or actually destroy it.
#'
#' @export
setMethod("dbDisconnect", "DBIConnection", function(conn, ...) {
  release(conn)
})

## Include only methods that deviate from the defaults set in object.R
## (no documentation because these are not meant to be used directly
## by the end user)

setMethod("onPassivate", "DBIConnection", function(object) {
  rs <- dbListResults(object)
  lapply(rs, dbRollback)
  lapply(rs, dbClearResult)
})

setMethod("onDestroy", "DBIConnection", function(object, envir) {
  invisible()
})

setMethod("onValidate", "DBIConnection", function(object) {
  invisible()
})