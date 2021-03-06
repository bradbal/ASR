% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/subtree.R
\name{plot_subtree}
\alias{plot_subtree}
\title{Plot a subtree given a node to use as root}
\usage{
plot_subtree(asrStructure, node, fastaDF = NULL)
}
\arguments{
\item{asrStructure}{the named list returned by \code{\link{runASR}}, \code{\link{loadASR}} or \code{\link{reduce_alphabet}}. Set this to NULL
to specify other variables}

\item{node}{label of node to form root of subtree}

\item{fastaDF}{a dataframe generated by \code{\link{read_fasta}} - only specify this if you want to use a specific dataframe}
}
\value{
a plot of the subtree of interest
}
\description{
Takes a node and extracts all descendants of node to create and plot a subtree
}
\examples{
data(asrStructure)

plot_subtree(asrStructure, "N1")

#if you want to use a specific set of data
#retrieve example file stored in the package
fasta_file <- system.file("extdata", "runASR_aln_full.fa", package="ASR")
#alternatively, specify the filename as a string
#fasta_file <- "id_aln_full.fa"

fastaDF <- read_fasta(NULL, aln_file = fasta_file)
plot_subtree(NULL, "N1", fastaDF = fastaDF) # if you want to use a specific dataframe


}

