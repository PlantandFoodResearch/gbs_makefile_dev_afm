#!/bin/sh
# This program runs the QseqToTagCountPlugin plugin in TASSEL 4 to merge taxa by library prep id in TBTHDF5 according to user modfied parameters
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
# This program depends on TASSEL 4, md5sum and zip
########

########
# User Modified Parameters
########

######## Meta Information

PROJECT=$USER # PI  or Project NAME

####### File Locations

TASSELFOLDER="/home/elshirer/tassel3.0_standalone" # Where the TASSEL3 run_pipeline.pl resides
INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/scratch/raw" # Where the input sequence files reside
OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/02_TagCounts/01_IndividualTagCounts" # Where output of script should go
NODE="1" # Use this for identifying multiple runs of the script for large projects.
KEYFILE="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/50_KeyFiles/all_ryegrass_NZ_key_20140507.txt" # Location of Keyfile including filename

######## TASSEL Options

ENZYME="PstI"
MINCOUNT="1" # Minimum number tag count for tag to be included in the cnt file
MAXGOODREADS="300000000"
MINRAM="-Xms512m" # Minimum RAM for Java Machine
MAXRRAM="-Xmx12g" # Maximum RAM for Java Machine

########
# Variables used by script
#######

DATE=$(date +%Y%m%d) #Date from system in the format YYYYMMDD

########
# Generate the XML Files to run this process
########


  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > "$OUTPUTFOLDER"/"$PROJECT"_FastqToTagCounts_node_"$NODE".xml
  echo ' <TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_FastqToTagCounts_node_"$NODE".xml
  echo '    <fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_FastqToTagCounts_node_"$NODE".xml
  echo '        <FastqToTagCountPlugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_FastqToTagCounts_node_"$NODE".xml
  echo '            <i>'$INPUTFOLDER'</i>' >> "$OUTPUTFOLDER"/"$PROJECT"_FastqToTagCounts_node_"$NODE".xml
  echo '            <o>'$OUTPUTFOLDER'</o>' >> "$OUTPUTFOLDER"/"$PROJECT"_FastqToTagCounts_node_"$NODE".xml
  echo '            <k>'$KEYFILE'</k>' >> "$OUTPUTFOLDER"/"$PROJECT"_FastqToTagCounts_node_"$NODE".xml
  echo '            <e>'$ENZYME'</e>' >> "$OUTPUTFOLDER"/"$PROJECT"_FastqToTagCounts_node_"$NODE".xml
  echo '            <s>'$MAXGOODREADS'</s>' >> "$OUTPUTFOLDER"/"$PROJECT"_FastqToTagCounts_node_"$NODE".xml
  echo '            <c>'$MINCOUNT'</c>' >> "$OUTPUTFOLDER"/"$PROJECT"_FastqToTagCounts_node_"$NODE".xml
  echo '        </FastqToTagCountPlugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_FastqToTagCounts_node_"$NODE".xml
  echo '    </fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_FastqToTagCounts_node_"$NODE".xml
  echo '    <runfork1/>' >> "$OUTPUTFOLDER"/"$PROJECT"_FastqToTagCounts_node_"$NODE".xml
  echo '</TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_FastqToTagCounts_node_"$NODE".xml


###########
# Record files used in run_pipeline
###########

date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "Name of Machine Script is running on:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
hostname | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "Files available for this run:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
ls -1 "$INPUTFOLDER"* | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "MD5SUM of files used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
#echo "MD5SUMS will not be run on these files for the Workshop to save time." | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
md5sum "$INPUTFOLDER"* | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "md5sum of tassel jar file:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
#md5sum "$TASSELFOLDER"/sTASSEL.jar | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
ls -l "$KEYFILE" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
md5sum "$KEYFILE"| tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
######## Put the contents of the XML files into the log

echo "Contents of the XML file used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
cat $OUTPUTFOLDER"/"$PROJECT"_FastqToTagCounts_node_"$NODE".xml" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log

echo "Contents of the the shell script used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
cat "$0" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log 
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "Starting Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log


#######
# Run TASSEL 
#######
date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log

  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
  #Run tassel pipeline, redirect stderr to stdout, copy stdout to log file.
  #Load modules for the AgResearch CentOS install and run from that
module avail
module load tassel/4

  run_pipeline.pl  "$MINRRAM" "$MAXRRAM" -configFile "$OUTPUTFOLDER"/"$PROJECT"_FastqToTagCounts_node_"$NODE".xml 2>&1 | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log


echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "End of Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log

########
# Record md5sums of output files in log
########



echo "md5sum of Count File(s)" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log

md5sum   $OUTPUTFOLDER"/*.cnt"| tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log

echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log
date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_TagCounts_"$NODE"_"$DATE".log

