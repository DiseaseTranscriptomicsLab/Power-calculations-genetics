################################################################################
#
#   File name: power_calc_genetics.R
#
#   Authors: Jacek Marzec ( jacek.marzec@accelbio.pt )
#
#   Biocant Park,
#   Parque Tecnológico de Cantanhede,
#   3060-197 Cantanhede
#
################################################################################

################################################################################
#
#	  Description: Script collecting user-defined parameters for the corresponding power_calc_genetics.Rmd markdown script performing power calculation to assist users with experimental design.
#
#	  Command line use example: Rscript power_calc_genetics.R  --samples_n 100 --features_n 1 --power 0.9 --sig_level 0.05 --deg_freedom 1 --features_n 0.5 --report_name gastric_cancer --report_dir /mnt/scratch/home/datasets/power_calculations
#
#   samples_n:         Total number of samples
#   features_n:        Total number of features (used for multihypothesis testing adjustment)
#   power:             Power of test (1 - type II error probability)
#   sig_level:         Significance level (type I error probability)
#   deg_freedom:       Degree of freedom
#   report_name:       Desired name for the report
#   report_dir:        Desired location for the report
#   seed:              Seed for random number generation
#   hide_code_btn:     Hide the "Code" button allowing to show/hide code chunks in the final HTML report. Available options are: "FALSE" (default) and "TRUE"
#
################################################################################

##### Clear workspace
rm(list=ls())
##### Close any open graphics devices
graphics.off()

#===============================================================================
#    Load libraries
#===============================================================================

suppressMessages(library(optparse))

#===============================================================================
#    Catching the arguments
#===============================================================================

option_list = list(
  make_option("--samples_n", action="store", default=100, type='integer',
              help="Total number of samples"),
  make_option("--features_n", action="store", default=1, type='integer',
              help="Total number of features"),
  make_option("--power", action="store", default=0.9, type='numeric',
              help="Power of test"),
  make_option("--sig_level", action="store", default=0.05, type='numeric',
              help="Significance level"),
  make_option("--deg_freedom", action="store", default=1, type='integer',
              help="Degree of freedom"),
  make_option("--report_name", action="store", default="power_calc_genetics", type='character',
              help="Desired name for the report"),
  make_option("--report_dir", action="store", default=NA, type='character',
              help="Desired location for the report"),
  make_option("--seed", action="store", default=99999999, type='numeric',
              help="Set up a seed for random number generation"),
  make_option("--hide_code_btn", action="store", default=FALSE, type='logical',
              help="Hide the \"Code\" button allowing to show/hide code chunks in the final HTML report")
)

opt = parse_args(OptionParser(option_list=option_list))

##### Read in argument from command line and check if all required arguments were provide by the user
if ( is.na(opt$report_name) || is.na(opt$report_dir) ) {
  
  cat("\nPlease type in required arguments!\n\n")
  cat("\ncommand example:\n\nRscript power_calc_genetics.R --samples_n 100 --power 0.9 --sig_level 0.05 --deg_freedom 1 --features_n 0.5 --report_name gastric_cancer --report_dir /mnt/scratch/home/datasets/power_calculations\n\n")
  q()
  
}

##### Create user-defined directory for the report
if ( !file.exists(opt$report_dir) ) {
  dir.create(opt$report_dir, recursive=TRUE)
}

##### Collect parameters
param_list <- list(samples_n = opt$samples_n,
                   features_n = opt$features_n,
                   power = opt$power,
                   sig_level = opt$sig_level,
                   deg_freedom = opt$deg_freedom,
                   report_name = opt$report_name,
                   report_dir = opt$report_dir,
                   seed = opt$seed,
                   hide_code_btn = opt$hide_code_btn)

##### Pass the user-defined arguments to the "power_calc_genetics" R markdown script and generate the report
rmarkdown::render(input = "power_calc_genetics.Rmd",
                  output_file = paste0(opt$report_name, ".html"),
                  output_dir = opt$report_dir,
                  params = param_list )

##### Remove the assocaited MD file and the redundant folder with plots that are embedded in the HTML report
unlink(paste0(opt$report_dir, "/", opt$report_name, "_report.md"), recursive = TRUE)
unlink(paste0(opt$report_dir, "/", opt$report_name, "_report_files"), recursive = TRUE)

##### Clear workspace
rm(list=ls())
##### Close any open graphics devices
graphics.off()
