% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/alphabet.R
\name{reduce_alphabet}
\alias{reduce_alphabet}
\title{Reduce the alphabet across all relevant features of ASR structure}
\usage{
reduce_alphabet(asrStructure, alphabet, alphabetType = "AA")
}
\arguments{
\item{asrStructure}{the named list returned by \code{\link{runASR}} or \code{\link{loadASR}}. Set this to NULL
to specify other variables}

\item{alphabet}{a list of letters representing the 1:1 mapping of the new alphabet to the original AA alphabet}

\item{alphabetType}{the original alphabet type of the reconstruction}
}
\value{
a new asrStructure with the relevant data structures updated to the reduced alphabet
}
\description{
Reduce the alphabet across all relevant features of ASR structure
}
\examples{
data(asrStructure)

#             "A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y"
#              |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
alphabet <- c("H", "H", "H", "C", "C", "C", "R", "R", "R", "R", "P", "P", "P", "P", "N", "N", "N", "N", "H", "H")
newASR <- reduce_alphabet(asrStructure, alphabet)

}

