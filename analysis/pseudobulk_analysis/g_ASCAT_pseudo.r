###!/usr/bin/env Rscript

library(ASCAT)
packageVersion("ASCAT")

#args = commandArgs(trailingOnly = TRUE)
PTCLid <- "$1"

#variables 
allelecounter <- "alleleCounter"
G1000_loci_hg38_chr <- "/G1000_loci_chr/G1000_loci_hg38_chr"
G1000_alleles_hg38_chr <- "/G1000_alleles_chr/G1000_alleles_hg38_chr"
GCcontentfile <- "/GC_G1000_hg38_chr/GC_G1000_hg38.txt"
RTfile <- "/RT_G1000_hg38_chr/RT_G1000_hg38.txt"
ncores <- 8

samplepath <- paste0("/phased_bams/",PTCLid,"/long_reads.bam")
gender <- "XX"

tumour_BAM <- samplepath
normal_BAM <- "all_timepoints_normals.bam"

print(tumour_BAM)
print(G1000_loci_hg38_chr)
#choosing output directory
OUTBASE <- "/ASCAT_replot"
outdir <- file.path(paste(OUTBASE,"/",PTCLid, sep = ''))
dir.create(outdir, showWarnings = T, recursive = T)
setwd(outdir)
print(outdir)
getwd()

###Specifications for the scDNA pseudo-bulk long read
loci_binsize <- 1200  
penalty <- 120       

#HTS tumour only long-read
ascat.prepareHTS(
  tumourseqfile = tumour_BAM,
  tumourname = paste0(PTCLid),
  normalseqfile = normal_BAM,
  normalname = "normal_cells",
  allelecounter_exe = allelecounter ,
  skip_allele_counting_tumour = FALSE,
  skip_allele_counting_normal = FALSE,
  alleles.prefix = G1000_alleles_hg38_chr,
  loci.prefix = G1000_loci_hg38_chr,
  gender = gender,
  genomeVersion = "hg38",
  nthreads = 12,
  tumourLogR_file = "Tumor_LogR.txt",
  tumourBAF_file = "Tumor_BAF.txt",
  normalLogR_file =  "Normal_LogR.txt",
  normalBAF_file = "Normal_BAF.txt",
  loci_binsize = loci_binsize,
  min_base_qual= 10,
  minCounts = 10,
  additional_allelecounter_flags="-f 0")

# Niet meer gebruiken
getwd()


ascat.bc = ascat.loadData(Tumor_LogR_file = "Tumor_LogR.txt", Tumor_BAF_file ="Tumor_BAF.txt" , Germline_LogR_file = "Normal_LogR.txt", Germline_BAF_file = "Normal_BAF.txt",gender = gender , genomeVersion = "hg38")
#ascat.bc = ascat.loadData(Tumor_LogR_file = tumour_logRnoice, Tumor_BAF_file = Bam_file , gender = gender , genomeVersion = "hg38")

ascat.plotRawData(ascat.bc, img.prefix = "Before_correction_")
ascat.bc = ascat.correctLogR(ascat.bc, GCcontentfile = GCcontentfile, replictimingfile = RTfile)
ascat.plotRawData(ascat.bc, img.prefix = "After_correction_")

ascat.bc = ascat.aspcf(ascat.bc, penalty = penalty)
ascat.plotSegmentedData(ascat.bc)

ascat.output = ascat.runAscat(ascat.bc, gamma=1, write_segments = T,pdfPlot = TRUE )
QC = ascat.metrics(ascat.bc,ascat.output)
save(ascat.bc, ascat.output, QC, file = 'ASCAT_objects.Rdata')
#Get the text version
write.table(x = ascat.output$segments, file = paste0(PTCLid, "ASCATprofile.txt"), sep = "/t", quote = F, row.names = F)
ascat.output$segments
