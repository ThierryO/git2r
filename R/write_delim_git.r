#' Write a dataframe as a tab delimited file to a git repository and stage it
#'
#' The existing file will be overwritten.
#' @param x the data.frame
#' @param file the name of the file
#' @param connection The path of a git repository or a \code{git_connection}
#'    object
#' @param ... parameters passed to \code{git_connection()} when
#'    \code{connection} is a path
#' @return the SHA1 of the file
#' @name write_delim_git
#' @rdname write_delim_git
#' @exportMethod write_delim_git
#' @docType methods
#' @importFrom methods setGeneric
#' @importFrom utils write.table
#' @include git_connection.r
#' @template thierry
setGeneric(
  name = "write_delim_git",
  def = function(x, file, connection, ...){
    standard.generic("write_delim_git")
  }
)

#' @rdname write_delim_git
#' @aliases write_delim_git,git_connection-methods
#' @importFrom methods setMethod
setMethod(
  f = "write_delim_git",
  signature = signature(connection = "ANY"),
  definition = function(x, file, connection, ...){
    this.connection <- git_connection(repo.path = connection, ...)
    write_delim_git(x = x, file = file, connection = this.connection)
  }
)

#' @rdname write_delim_git
#' @aliases write_delim_git,git_connection-methods
#' @importFrom methods setMethod
#' @importFrom assertthat assert_that is.string
setMethod(
  f = "write_delim_git",
  signature = signature(connection = "git_connection"),
  definition = function(x, file, connection, ...){
    assert_that(inherits(x, "data.frame"))
    assert_that(is.string(file))

    # write the file
    filename.full <- paste(
      connection@Repository@path,
      connection@LocalPath,
      file,
      sep = "/"
    )
    filename.full <- normalizePath(
      path = filename.full,
      winslash = "/",
      mustWork = FALSE
    )
    write.table(
      x = x, file = filename.full, append = FALSE,
      quote = FALSE, sep = "\t", row.names = FALSE, fileEncoding = "UTF-8"
    )

    # stage the file
    filename.local <- paste(connection@LocalPath, file, sep = "/")
    add(connection@Repository, filename.local)

    return(hashfile(filename.full))
  }
)
