#!/bin/bash

#SBATCH -D ./ 
#SBATCH --job-name="chromonomer"
#SBATCH -o log-chromonomer.out
#SBATCH -c 1
#SBATCH -p ibismini
#SBATCH --mail-type=ALL
#SBATCH --mail-user=type_your_mail@ulaval.ca
#SBATCH --time=0-20:00
#SBATCH --mem=50000

cd $SLURM_SUBMIT_DIR


TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)

# Copy script as it was run
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

#global variables

LGFILE="./02_data/lg_file.tsv"
SAMFILE="./02_data/seq_map_to_align.sam"
AGPFILE="./02_data/allcontig.agp"
OUTPUT="03_results"
FASTAFILE="./02_data/markers_file.fasta"

mkdir $OUTPUT

#options
lg_file="-p $LGFILE"				# path to file containing the linkage group definitions.
sam="-s $SAMFILE" 				#path to SAM formatted alignments linking map markers to genome contigs.
agp_file="-a $AGPFILE"				#path to the AGP formatted file defining assembly gaps.
output="-o $OUTPUT/"				# path to write chromonomer output.
#debug="-d" 					#turn on debug output.
fastafile="--fasta $FASTAFILE"			# supply a scaffold-based FASTA that will be translated according to the integrated assembly.
verb="--verbose" 						#turn on detailed console output for each scaffold.
scaffpref="--scaffold_prefix newsscaff" 			#text string to use as a common naming prefix when creating new scaffolds.
minmark="--min_markers 5" 				#minimum number of markers required to anchor a scaffold on a particular
                       				#map node. Will not remove scaffolds only present on one node (default 2).
#path_agp="--allpaths_agp" 			#The AllPaths-LG assembler produces a non-standard AGP file. This flag will change
                  				#the AGP parser to accommodate it.

#Filtering Options:
#scaffold="--scaffold_wl <path>"				#only process scaffolds in this file.
  							#HTML/PHP Options:
#datavers="--data_version <string>"			# used to create versioned PHP files so multiple runs can be
                             			#executed and compared in the web interface.
#htmlpref="--html_prefix <string>"		# any text that should be prepended onto links in the PHP output
                            			#to accommodate where they are located in the web server document root.


chromonomer $lg_file $sam $agp_file $output \
		$debug $fastafile $verb $scaffpref \
		$minmark $path_agp $scaffold $datavers $htmlpref 2>&1 | tee 98_log_files/"$TIMESTAMP"_chromonomer.log
