#!/bin/sh
# This program runs the MergeMultipleTagCountPlugin plugin in TASSEL 3 to merge tag count files
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
# This program depends on TASSEL 3, md5sum.
########

########
# User Modified Parameters
########

######## Meta Information

PROJECT=$USER # PI  or Project NAME

####### File Locations

TASSELFOLDER="/home/elshirer/tassel3.0_standalone" # Where the TASSEL3 run_pipeline.pl resides
INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/02_TagCounts/01_IndividualTagCounts" # Where the input sequence files reside
OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/02_TagCounts/02_MergedTagCounts" # Where output of script should go
OUTPUTFILE="All_Ryegrass_PSTI_Testing" # Base name of Output tag counts file.
#Load modules for the AgResearch CentOS install and run from that
module avail
module load tassel/4
######## TASSEL Options

MINCOUNT="5" # Minimum number tag count for tag to be included in the fastq file
MINRAM="-Xms512m" # Minimum RAM for Java Machine
MAXRRAM="-Xmx15g" # Maximum RAM for Java Machine

########
# Variables used by script
#######

DATE=$(date +%Y%m%d) #Date from system in the format YYYYMMDD

########
# Generate the XML Files to run this process
########


  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts.xml
  echo ' <TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts.xml
  echo '    <fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts.xml
  echo '        <MergeMultipleTagCountPlugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts.xml
  echo '            <i>'$INPUTFOLDER'</i>' >> "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts.xml
  echo '            <o>'$OUTPUTFOLDER'/'$OUTPUTFILE'_'$DATE'.cnt</o>' >> "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts.xml
  echo '            <c>'$MINCOUNT'</c>' >> "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts.xml
  echo '        </MergeMultipleTagCountPlugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts.xml
  echo '    </fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts.xml
  echo '    <runfork1/>' >> "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts.xml
  echo '</TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts.xml


###########
# Record files used in run_pipeline
###########

date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "Name of Machine Script is running on:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
hostname | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "Files available for this run:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
ls -1 "$INPUTFOLDER"/*.cnt | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "MD5SUM of files used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
md5sum "$INPUTFOLDER"/*.cnt | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "md5sum of tassel jar file:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
md5sum "$TASSELFOLDER"/sTASSEL.jar | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log

######## Put the contents of the XML files into the log

echo "Contents of the XML file used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
cat $OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts.xml" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log

echo "Contents of the the shell script used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
cat "$0" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log 
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "Starting Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log


#######
# Run TASSEL 
#######

date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
  #Run tassel pipeline, redirect stderr to stdout, copy stdout to log file.

run_pipeline.pl  "$MINRRAM" "$MAXRRAM" -configFile "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts.xml 2>&1 | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log


echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "End of Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log

########
# Record md5sums of output files in log
########



echo "md5sum of Merged Tag Counts File File" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log

md5sum   $OUTPUTFOLDER"/"$OUTPUTFILE"_"$DATE".cnt"| tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log

echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log
date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MergeTagCounts_"$DATE".log

