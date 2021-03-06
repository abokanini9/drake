% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cache.R
\name{get_cache}
\alias{get_cache}
\title{Get the default cache of a \code{drake} project.}
\usage{
get_cache(path = getwd(), search = TRUE, verbose = 1L,
  force = FALSE, fetch_cache = NULL, console_log_file = NULL)
}
\arguments{
\item{path}{If \code{search = FALSE}, \code{path} must be the root
directory of a \code{drake} project (a folder containing a \code{.drake} cache).
For example, if your cache is a folder called
\code{/home/you/my_project/.drake}, then
\code{get_cache(path = "/home/you/my_project", search = FALSE)}
will return the cache.
Otherwise, if \code{search = TRUE}, you can specify any
subdirectory of the project. The following are equivalent and correct:
\itemize{
\item \code{get_cache(path = "/home/you/my_project", search = FALSE)}
\item \code{get_cache(path = "/home/you/my_project", search = TRUE)}
\item \code{get_cache(path = "/home/you/my_project/subdir/x", search = TRUE)}
\item \code{get_cache(path = "/home/you/my_project/.drake", search = TRUE)}
\item \code{get_cache(path = "/home/you/my_project/.drake/keys", search = TRUE)}
}}

\item{search}{logical. If \code{TRUE}, search parent directories
to find the nearest drake cache. Otherwise, look in the
current working directory only.
Ignored if a \code{cache} is supplied.}

\item{verbose}{logical or numeric, control printing to the console.
\itemize{
\item \code{0} or \code{FALSE}: print nothing.
\item \code{1} or \code{TRUE}: print only targets to build.
\item \code{2}: also print checks and cache info.
\item \code{3}: also print any potentially missing items.
\item \code{4}: also print imports and writes to the cache.
}}

\item{force}{deprecated}

\item{fetch_cache}{character vector containing lines of code.
The purpose of this code is to fetch the \code{storr} cache
with a command like \code{storr_rds()} or \code{storr_dbi()},
but customized. This feature is experimental.}

\item{console_log_file}{character scalar,
connection object (such as \code{stdout()}) or \code{NULL}.
If \code{NULL}, console output will be printed
to the R console using \code{message()}.
If a character scalar, \code{console_log_file}
should be the name of a flat file, and
console output will be appended to that file.
If a connection object (e.g. \code{stdout()})
warnings and messages will be sent to the connection.
For example, if \code{console_log_file} is \code{stdout()},
warnings and messages are printed to the console in real time
(in addition to the usual in-bulk printing
after each target finishes).}
}
\value{
A drake/storr cache in a folder called \code{.drake/},
if available. \code{NULL} otherwise.
}
\description{
Only works if the cache
is in a folder called \code{.drake/}. See the description of the
\code{path} argument for details.
}
\examples{
\dontrun{
test_with_dir("Quarantine side effects.", {
clean(destroy = TRUE)
# No cache is available.
get_cache() # NULL
load_mtcars_example() # Get the code with drake_example("mtcars").
make(my_plan) # Run the project, build the targets.
x <- get_cache() # Now, there is a cache.
# List the objects readable from the cache with readd().
x$list() # Or x$list(namespace = x$default_namespace)
})
}
}
\seealso{
\code{\link[=this_cache]{this_cache()}}, \code{\link[=new_cache]{new_cache()}},
\code{\link[=recover_cache]{recover_cache()}}, \code{\link[=drake_config]{drake_config()}}
}
