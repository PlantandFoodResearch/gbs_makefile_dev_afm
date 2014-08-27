#!/bin/sh
# This program runs bowtie2 aligner and generates a sam file  according to user modfied parameters
# and generates a log file RJE 20120831

#    		Copyright 2012 Robert J. Elshire
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

########
# This program depends on bowtie2, md5sum and zip
########

########
# User Modified Parameters
########

######## Meta Information

PROJECT=$USER # PI  or Project NAME

####### File Locations

INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/02_TagCounts/03_TagCountToFastq" # Where the input sequence files reside
OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/03_SAM" # Where output of script should go
INPUTFILE="All_Ryegrass_PSTI_Testing" # Base name of Input fq file. 
OUTPUTFILE="All_Ryegrass_PSTI_Testing" # Base name of Output SAM file.
REFERENCEGENOME="/dataset/ryegrass_genome_072012/active/danish_reference/LP_GBS_reference" 

######## Bowtie2 Options
M="4"
PROCESSORS="24"
PRESETOPTIONS="--very-sensitive-local"

########
# Variables used by script
#######

DATE=$(date +%Y%m%d) #Date from system in the format YYYYMMDD

INPUTNAME=$INPUTFOLDER"/"$INPUTFILE"_????????.fq" # This assigns the input name _YYYYMMDD.fq 

###########
# Record files used in run_pipeline
###########

date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
echo "Name of Machine Script is running on:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
hostname | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
echo "Files available for this run:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
ls -1 $INPUTNAME | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
echo "MD5SUM of files used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
md5sum $INPUTNAME | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log

echo "Contents of the the shell script used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
cat "$0" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log 
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
echo "Starting Alignment With Bowtie2" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log


#######
# Run Bowtie2
#######

echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
  #Run bowtie2, redirect stderr to stdout, copy stdout to log file.
bowtie2 -M "$M" -p "$PROCESSORS" "$PRESETOPTIONS" -x "$REFERENCEGENOME" -U $INPUTNAME -S "$OUTPUTFOLDER"/"$OUTPUTFILE"_"$DATE".sam 2>&1 | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
# FIXME Echo the above command to the log.


date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log


echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
echo "End of Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log

########
# Record md5sums of output files in log
########



echo "md5sum of TBTHDF5 File" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log

md5sum   $OUTPUTFOLDER"/"$OUTPUTFILE"_"$DATE".sam"| tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log

echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log
date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_AlignWithBowtie2_"$DATE".log

