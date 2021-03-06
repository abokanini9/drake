% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/deprecate.R
\name{short_hash}
\alias{short_hash}
\title{Deprecated. \code{drake} now only uses one hash algorithm per cache.}
\usage{
short_hash(cache = drake::get_cache(verbose = verbose), verbose = 1L)
}
\arguments{
\item{cache}{drake cache. See \code{\link[=new_cache]{new_cache()}}.
If supplied, \code{path} and \code{search} are ignored.}

\item{verbose}{logical or numeric, control printing to the console.
\itemize{
\item \code{0} or \code{FALSE}: print nothing.
\item \code{1} or \code{TRUE}: print only targets to build.
\item \code{2}: also print checks and cache info.
\item \code{3}: also print any potentially missing items.
\item \code{4}: also print imports and writes to the cache.
}}
}
\value{
A character vector naming a hash algorithm.
}
\description{
Deprecated on 2018-12-12.
}
\examples{
# deprecated
}
\keyword{internal}
