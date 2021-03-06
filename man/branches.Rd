% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/branch.R
\name{branches}
\alias{branches}
\title{Branches}
\usage{
branches(repo = ".", flags = c("all", "local", "remote"))
}
\arguments{
\item{repo}{a path to a repository or a \code{git_repository}
object. Default is '.'}

\item{flags}{Filtering flags for the branch listing. Valid values
are 'all', 'local' or 'remote'}
}
\value{
list of branches in repository
}
\description{
List branches in repository
}
\examples{
\dontrun{
## Initialize repositories
path_bare <- tempfile(pattern="git2r-")
path_repo <- tempfile(pattern="git2r-")
dir.create(path_bare)
dir.create(path_repo)
repo_bare <- init(path_bare, bare = TRUE)
repo <- clone(path_bare, path_repo)

## Config first user and commit a file
config(repo, user.name="Alice", user.email="alice@example.org")

## Write to a file and commit
writeLines("Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do",
           file.path(path_repo, "example.txt"))
add(repo, "example.txt")
commit(repo, "First commit message")

## Push commits from repository to bare repository
## Adds an upstream tracking branch to branch 'master'
push(repo, "origin", "refs/heads/master")

## List branches
branches(repo)
}
}
