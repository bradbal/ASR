#'Alignment plotting function
#'
#'Creates a plot of the alignment produced by ASR.jar which can be represented as 
#'tiles, plain text, coloured text or a combination. Colours are specified in \code{colours.R} 
#'and currently include Clustal and Zappo colour schemes
#'
#'@param asrStructure the named list returned by \code{\link{runASR}}, \code{\link{loadASR}} or \code{\link{reduce_alphabet}}. Set this to NULL
#'to specify other variables
#'@param seqDF a data frame generated by \code{\link{get_seq_df}}
#'@param type how the alignment should be displayed, default colouredText,
#'options: "colour", "text", "both", "colouredText", "logo"
#'#'NOTE: "logo" uses \code{\link{plot_logo_aln}}
#'@param colour the colour scheme selected, default clustal, options: "clustal", "zappo", "taylor", "mixed"
#'@param columns a vector containing the column numbers of interest. By default = NULL and all columns are displayed
#'@param sequences a vector containing the sequences (by Label) of interest. By default = NULL and all sequences are displayed
#'
#'@return plots a matrix of amino acid sequence given columns and sequences of interest
#'
#'@examples
#'data(asrStructure)
#'
#'plot_aln(asrStructure) # plot using all defaults
#'#plot alignment displaying plain text
#'plot_aln(asrStructure, type = "text")
#'#plot alignment displaying coloured text
#'plot_aln(asrStructure, type = "colouredText")
#'#plot alignment displaying coloured boxes
#'plot_aln(asrStructure, type = "colour")
#'#plot alignment displaying coloured boxes with overlayed text
#'plot_aln(asrStructure, type = "both")
#'#'#plot alignment displaying a boxplot logo
#'plot_aln(asrStructure, type = "logo")
#'# plot alignment using zappo colouring (assuming the type argument uses colour) 
#'plot_aln(asrStructure, colour = "zappo")
#'# plot alignment using taylor colouring and coloured boxes
#'#(assuming the type argument uses colour)
#'plot_aln(asrStructure, colour = "taylor", type = "colour")
#'
#'#Loading and using raw data files from runASR
#'
#'#retrieve example file stored in the package
#'fasta_file <- system.file("extdata", "runASR_aln_full.fa", package="ASR")
#' #alternatively, specify the filename as a string
#' #fasta_file <- "id_aln_full.fa"
#'
#'# read in the fasta file of choice
#'fasta <- read_fasta(NULL, aln_file = fasta_file) 
#'# convert this to a dataframe that can be read by plot_aln
#'seqDF <- get_seq_df(NULL, fastaDF = fasta) 
#'plot_aln(NULL, seqDF = seqDF) # plot using all defaults
#'
#'#Plotting specific columns and/or sequences
#'columns = c(3,4,5,6)
#'sequences = c("N1", "N3", "N2", "extant_1")
#'plot_aln(asrStructure, columns = columns)
#'plot_aln(asrStructure, sequence = sequences)
#'plot_aln(asrStructure, columns = columns, sequence = sequences)
#'
#'
#'@export

plot_aln <- function(asrStructure, seqDF=NULL, type="colouredText", colour="clustal", columns = NULL, sequences = NULL) {
  
  Label <- NULL; rm(Label);
  Column <- NULL; rm(Column);
  AA <- NULL; rm(AA);
  
  if (type == "logo") {
    if (is.null(asrStructure)) {
      stop(paste("Cannot access heights for logo without asrStructure. Providing seqDF alone is not adequate."))
    } else {
      pl <- plot_logo_aln(asrStructure, colour = colour, columns = columns, sequences = sequences)
    }
    return(pl)
  }
  
  seqDF <- dfError(asrStructure, "seqDF", seqDF, c("Column", "Label", "AA"), "Joint")
  
  if (!is.null(columns)) {
    seqDF <- seqDF[seqDF$Column %in% columns, ]
  }
  if (!is.null(sequences)) {
    seqDF <- seqDF[seqDF$Label %in% sequences, ]
  }
  
  seqDF$Column <- factor(seqDF$Column, levels = as.character(sort(as.numeric(levels(seqDF$Column)))))
  seqDF$Label <- factor(seqDF$Label)
  seqDF$AA <- factor(seqDF$AA)
  
  if (colour == "clustal") {
    colourPalette = colours_clustal(levels(seqDF$AA))
  } else if (colour == "zappo") {
    colourPalette = colours_zappo(levels(seqDF$AA))
  } else if (colour == "taylor") {
    colourPalette = colours_taylor(levels(seqDF$AA))
  } else if (colour == "mixed") {
    colourPalette = colours_yos(levels(seqDF$AA))
  } else {
    stop("Invalid colour choice for plot_aln()")
  }
  
  if (type == "colour") {
    ggplot2::ggplot(seqDF, ggplot2::aes(x=Column, y=Label, label=AA)) + 
      ggplot2::geom_tile(ggplot2::aes(fill = AA), colour = "white") + 
      ggplot2::scale_fill_manual(values = colourPalette) + 
      ggplot2::theme_bw() +
      ggplot2::theme(text = ggplot2::element_text(size=30),axis.text.x=ggplot2::element_text(angle = 45, hjust=1))
  } else if (type == "text") {
    ggplot2::ggplot(seqDF, ggplot2::aes(x=Column, y=Label, label=AA)) + 
      ggplot2::geom_text(size = 12) + 
      ggplot2::theme_bw() + ggplot2::theme(panel.grid.major = ggplot2::element_blank(), panel.grid.minor = ggplot2::element_blank())+
      ggplot2::theme(text = ggplot2::element_text(size=30),axis.text.x=ggplot2::element_text(angle = 45, hjust=1))
  } else if (type == "both") {
    ggplot2::ggplot(seqDF, ggplot2::aes(x=Column, y=Label, label=AA)) + 
      ggplot2::geom_tile(ggplot2::aes(fill = AA), colour = "white") + 
      ggplot2::scale_fill_manual(values = colourPalette) + 
      ggplot2::geom_text(size = 12) + 
      ggplot2::theme_bw() +
      ggplot2::theme(text = ggplot2::element_text(size=30),axis.text.x=ggplot2::element_text(angle = 45, hjust=1))
  } else if (type =="colouredText") {
    ggplot2::ggplot(seqDF, ggplot2::aes(x=Column, y=Label, label=AA)) + 
      ggplot2::geom_text(ggplot2::aes(colour = AA), size = 12) + 
      ggplot2::scale_colour_manual(values = colourPalette) +
      ggplot2::theme_bw() + ggplot2::theme(panel.grid.major = ggplot2::element_blank(), panel.grid.minor = ggplot2::element_blank()) +
      ggplot2::theme(text = ggplot2::element_text(size=30),axis.text.x=ggplot2::element_text(angle = 45, hjust=1))
  } else {
    stop("Invalid type for plot_aln")
  }
}

#'Alignment plotting and saving function
#'
#'Creates a plot of the alignment produced by ASR.jar which can be represented as 
#'tiles, plain text, coloured text or a combination. Colours are specified in \code{colours.R} 
#'and currently include Clustal and Zappo colour schemes. This plot is then saved.
#'
#'@param asrStructure the named list returned by \code{\link{runASR}} or \code{\link{loadASR}}. Set this to NULL
#'to specify other variables
#'@param seqDF a data frame generated by \code{\link{get_seq_df}}
#'@param type how the alignment should be displayed, default colouredText,
#'options: "colour", "text", "both", "colouredText", "logo"
#'@param colour the colour scheme selected, default clustal, options: "clustal", "zappo", "taylor", "mixed"
#'@param columns a vector containing the column numbers of interest. By default = NULL and all columns are displayed
#'@param sequences a vector containing the sequences (by Label) of interest. By default = NULL and all sequences are displayed
#'@param format specifies what format the figure should be saved in. Options: "pdf" or "png"
#'@param name what name would you like the figure saved under?
#'
#'@examples
#'data(asrStructure)
#'
#'save_aln(asrStructure) # plot using all defaults
#'#plot alignment displaying plain text
#'save_aln(asrStructure, type = "colour") 
#'#'#'#plot alignment displaying a boxplot logo
#'save_aln(asrStructure, type = "logo")
#'# plot alignment using zappo colouring (assuming the type argument uses colour)
#'save_aln(asrStructure, colour = "zappo")
#'
#'#Loading and using raw data files from runASR
#'
#'#retrieve example file stored in the package
#'fasta_file <- system.file("extdata", "runASR_aln_full.fa", package="ASR")
#' #alternatively, specify the filename as a string
#' #fasta_file <- "id_aln_full.fa"
#'
#'# read in the fasta file returned by ASR.jar
#'fasta <- read_fasta(NULL, aln_file = fasta_file) 
#' # convert this to a dataframe that can be read by plot_aln
#'seqDF <- get_seq_df(NULL, fastaDF = fasta)
#'save_aln(NULL, seqDF = seqDF) # plot using all defaults
#'#plot alignment displaying plain text
#'save_aln(NULL, seqDF = seqDF, type = "colour")
#'# plot alignment using zappo colouring (assuming the type argument uses colour) 
#'save_aln(NULL, seqDF = seqDF, colour = "zappo") 
#'
#'#Plotting specific columns and/or sequences
#'columns = c(3,4,5,6)
#'sequences = c("N1", "N3", "N2", "extant_1")
#'save_aln(asrStructure, columns = columns)
#'save_aln(asrStructure, sequence = sequences)
#'save_aln(asrStructure, columns = columns, sequence = sequences)
#'
#'save_aln(asrStructure, format = "png", name = "new_name")
#'
#'@export

save_aln <- function(asrStructure, seqDF=NULL, type="colouredText", colour="clustal", columns = NULL, sequences = NULL, format = "pdf", name = NULL) {
  
  seqDF <- dfError(asrStructure, "seqDF", seqDF, c("Column", "Label", "AA"), "Joint")

  if (type =="logo") {
    if (is.null(asrStructure)) {
      stop(paste("Cannot access heights for logo without asrStructure. Providing seqDF alone is not adequate."))
    } else {
      gg <- plot_logo_aln(asrStructure, colour = colour, columns = columns, sequences = sequences)
    }
  } else if (type =="colour" || type == "colouredText" || type =="both" || type == "text") {
    gg <- plot_aln(NULL,seqDF=seqDF,type = type, colour = colour, columns = columns, sequences = sequences)
  } else {
    stop("Invalid type for plot_aln")
  }
  
  if (is.null(name)) {
    if (is.null(asrStructure)) {
      name = "alignment"
    } else {
      name = asrStructure$fileNames$FastaFile
    }
  }
  
  y = length(unique(levels(seqDF$Label)))
  x = length(unique(levels(seqDF$Column)))
  if (format == "pdf") {
    w = (x * 0.360) + (1/(x/100))
    h = (y * 0.500) + 6.473
    pdf(paste(name, "_plot.", format, sep=""), width=w, height=h)
    print(gg)
    dev.off()
    return(paste("Plot saved as:", name, "_plot.", format, sep=""))
  } else if (format == "png") {
    w = (x * 40) + 200
    h = (y * 28) + 200
    png(paste(name, "_plot.", format, sep=""), width=w, height=h)
    print(gg)
    dev.off()
    return(paste("Plot saved as:", name, "_plot.", format, sep=""))
  } else {
    stop("Invalid format for save_aln")
  }
}

#' Format sequence from fasta
#' 
#' Takes the dataframe generated by \code{\link{read_fasta}} and formats it 
#' so it can be passed to \code{\link{plot_aln}} to be plotted using ggplot2
#' 
#' @param asrStructure the named list returned by \code{\link{runASR}} or \code{\link{loadASR}}. Set this to NULL
#'to specify other variables
#' @param fastaDF a dataframe generated by \code{\link{read_fasta}}
#' 
#' @return a dataframe with three columns representing the amino acid sequences. \cr
#' Formatted to be passed to \code{\link{plot_aln}}.\cr
#' seqDF$Label - label/id stored in fasta file\cr
#' seqDF$Column - number representing the column in the alignment this result belongs to \cr
#' seqDF$AA - amino acid located in this column belonging to labelled sequence\cr
#' #example\cr
#' seqDF[1,] = "N1", "5", "A"  - sequence N1_ contains an A at position 5 in its alignment sequence\cr
#' 
#'@examples
#'data(asrStructure)
#'
#'get_seq_df(asrStructure)
#'
#'#OR
#'
#'#retrieve example file stored in the package
#'fasta_file <- system.file("extdata", "runASR_aln_full.fa", package="ASR")
#' #alternatively, specify the filename as a string
#' #fasta_file <- "id_aln_full.fa"
#'
#'fastaDF <- read_fasta(NULL, aln_file = fasta_file) # read in the fasta file returned by ASR.jar
#'get_seq_df(NULL, fastaDF=fastaDF) #fastaDF generated by read_fasta
#' 
#' @export
#' 
get_seq_df <- function(asrStructure, fastaDF=NULL) {
  
  fastaDF <- dfError(asrStructure, "fastaDF", fastaDF, c("Newick", "Label", "Sequence"), "Joint")
  
  names <- fastaDF$Label
  seqs <- fastaDF$Sequence
  
  for (i in seq(1, length(names), 1)) {
    seqName = as.character(names[i])
    seq = as.character(seqs[i])
    seqSplit <- strsplit(seq, "")
    seqLength = length(seqSplit[[1]])
    if (i == 1) {
      mat <- matrix(c(rep(seqName, seqLength), seq(1, seqLength, 1), seqSplit[[1]]), ncol = 3, nrow = seqLength)
    } else {
      nmat <- matrix(c(rep(seqName, seqLength), seq(1, seqLength, 1), seqSplit[[1]]), ncol = 3, nrow = seqLength)
      mat <- rbind(mat, nmat)
    }
  }
  df <- as.data.frame(mat)
  colnames(df) <- c("Label", "Column", "AA")
  df
  }
