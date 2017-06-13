#' rank_dmg() 
#' This function sorts genes by different parameters and plots bar graph for demonstration 
#'
#' @param dmsg.txt a tab delimited file generated by explore_dmsg() 
#' 
#' @return A list of data frames summarizing genes sorted by different parameter 
#' 
#' @importFrom utils write.table 
#' @importFrom ggplot2 ggplot
#'
#' @examples
#'   mydatf <- system.file("extdata","Am.dat",package="BWASPR")
#'   myparf <- system.file("extdata","Am.par",package="BWASPR")
#'   myfiles <- setup_BWASPR(datafile=mydatf,parfile=myparf)
#'   AmHE <- mcalls2mkobj(myfiles$datafiles,species="Am",study="HE",
#'                        type="CpGhsm",mincov=1,assembly="Amel-4.5")
#'   genome_ann <- get_genome_annotation(myfiles$parameters)
#'   dmsgList <- det_dmsg(AmHE,genome_ann,
#'                        threshold=25.0,qvalue=0.01,mc.cores=4,
#'                        destrand=TRUE,
#'                        outfile1="AmHE-dmsites.txt", 
#'                        outfile2="AmHE-dmgenes.txt")
#'   dmgprp <- show_dmsg(AmHE,dmsgList,min.nsites=10,destrand=TRUE,
#'                       outflabel="Am_HE")
#'   summaries <- explore_dmsg(AmHE,genome_ann,dmgprp,withglink="NCBIgene",
#'                             outflabel="Am_HE")
#'
#' @export
 
rank_dmg <- function(dmsg.txt){
    message('... rank_dmsg ...')
    # read table
    #
    data <- read.table(dmsg.txt)
    # for each parameter, return a list of genes sorted by the parameter
    # and plot the distribution
    #
    sorted_gene_table <- list()
    for (i in names(data)[2:length(names(data))]){
        temp_label <- paste('sorted_by',i,sep='_')
        message(paste('   ... sorted by',temp_label,'...'))
        pdf(paste(temp_label,'.pdf',sep=''))
        data$gene_ID <- factor(data$gene_ID,levels=data$gene_ID[order(data[i],decreasing=TRUE)])
        print(ggplot(data, aes(x=gene_ID,y=data[[i]])) + geom_col())
        dev.off()
        # save the sorted genes
        #
        temp <- data[with(data, order(data[,i],decreasing=TRUE)),]
        sorted_gene_table[temp_label] <- temp['gene_ID']
    }
    sorted_gene_table <- as.data.frame(sorted_gene_table)
    return(sorted_gene_table)
}