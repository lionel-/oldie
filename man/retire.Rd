% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/retire.R, R/signal-retired.R
\name{retire}
\alias{retire}
\alias{signal_retired}
\title{Deprecate a function or argument}
\usage{
retire(.fn, .cycle, ..., .msg = NULL)

signal_retired(.fn, .cycle, ..., .msg = NULL)
}
\arguments{
\item{.fn}{The function to deprecate or whose arguments are to be
deprecated. This should be supplied as a bare name.}

\item{.cycle}{A character vector defining the deprecation cycle.
See the relevant section.}

\item{...}{Replacements, supplied as bare names.
\itemize{
\item If no replacement is supplied, the function is deprecated with no
replacement.
\item If a single unnamed replacement is supplied, the function is
deprecated with the replacement. If the replacement function
lives in another package, indicate it with a namespace:
\code{"pkg::replacement"}.
\item If one or several named replacements are supplied, the function
is not deprecated. Instead, the supplied arguments are. \code{old = new} means that the argument \code{old} is deprecated with replacement
\code{new}. \code{old =} means that the argument \code{old} is deprecated
without replacement.
}}

\item{.msg}{An alternative deprecation message.}
}
\description{
\code{retire()} marks a function or some of its arguments as
obsolete. This enables automatic documentation by roxygen, signals
a condition when a deprecated function is run or when a deprecated
argument is supplied, and checks that the deprecation cycle
conforms to tidyverse rules.

The conditions are signalled with with \code{signal_retired()} which
has the same interface as \code{retire()}. It should always be called
directly within the deprecated function. Since it is added
automatically by \code{retire()}, you should rarely have to call it
yourself.
}
\section{Deprecation levels}{


There are three deprecation levels:
\itemize{
\item \strong{Soft-deprecated}: This is the first stage of deprecation. The
function or argument continues to work normally without any
warning. Soft-deprecated functions will generally not be documented, and
should not be used in examples or package code. They are left
around so that existing code continues to work, but new code
should not use them.

To make soft-deprecated functions signal an error, see below.
\item \strong{Deprecated}: The function or argument now issues a warning
when used or supplied. Users should upgrade their code to use the
suggested replacement, if any.
\item \strong{Defunct}: The function or argument now issues an error when
used or supplied.
}

These levels are defined by a deprecation cycle, see section
below. You can promote the current deprecation level by setting the
global option \code{oldie_verbose_retirement} to \code{TRUE}.
Soft-deprecated functions then become deprecated, deprecated
functions become defunct, and so on. This is useful to check
whether you're relying on any soft-deprecated functions or
arguments.
}

\section{Deprecation cycle}{


\code{.cycle} associates each deprecation stage to a release version of
your package. It should be a character vectors of three versions.
\itemize{
\item \code{c("0.1.0", "0.3.0", "1.0.0")}: Soft-deprecation at after the
0.1.0 release, deprecation after 0.3.0, and defunct after 1.0.0.
\item \code{"0.1.0"}: This is equivalent to \code{c("0.1.0", "0.2.0", "0.3.0")}.
When a single version is supplied, it is assumed that it marks
the start of a deprecation cycle that is bumped at each minor
version (middle number).
\item \code{c("0.1.0", "", "")}: The function is soft-deprecated but is not
planned to ever be deprecated or defunct. This is useful for
discouraging users from using a function without forcing them to
change their code.
}
}

\examples{
# Let's create an obsolete function:
old_fn <- function() "old"

# You can deprecate it without any replacement:
retire(old_fn, "0.1.0")

# The cycle above specifies only one version. The cycle is
# automatically filled and the above expression is thus equivalent to:
retire(old_fn, c("0.1.0", "0.2.0", "0.3.0"))

# If there is a new function replacing the old one, just supply its
# bare name:
retire(old_fn, "0.1.0", replacement_fn)


# Deprecating an argument is very similar. They are supplied as
# key-value pairs where the key is the deprecated argument and the
# value, if supplied, is the replacement. This deprecates an
# argument without replacement:
fn <- function(..., old) NULL
retire(fn, "0.1.0", old = )

# This deprecates with replacement. The deprecated argument is
# automatically reassigned to the replacement:
fn <- function(..., new, old) NULL
retire(fn, "0.1.0", old = new)

# The deprecated argument will be added to the formals if
# needed. This way you can omit the deprecated arguments from the
# function declaration:
fn <- function(..., new) NULL
retire(fn, "0.1.0", old = new)
}
