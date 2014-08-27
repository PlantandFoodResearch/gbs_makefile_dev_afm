#!/bin/sh
# This program runs the SeqToTBTHDF5Plugin plugin in TASSEL 3 according to user modfied parameters
# and generates a log file RJE 20120829

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
# This program depends on TASSEL 3, md5sum

########
# User Modified Parameters
########

## For the Ryegrass build, divide up the sequence files into 5 folders and 
# assign each to a different node will speed up the TBT generation. Merge in next step

######## Meta Information

PROJECT=$USER # PI  or Project NAME

####### File Locations

TASSELFOLDER="/home/elshirer/tassel3.0_standalone" # Where the TASSEL3 run_pipeline.pl resides
NODE="1" # Use this for identifying multiple runs of the script for large projects.
INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/elshirer/01_RawSequence" # Where the input sequence files reside
OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/elshirer/05_TBT/01_IndividualTBT" # Where output of script should go
OUTPUTFILE="All_Ryegrass_PSTI_Testing" # Base name of Output HDF5 file.
KEYFILE="/dataset/semihybrid_ryegrass_GBS/active/elshirer/50_KeyFiles/all_ryegrass_NZ_key_20140507.txt" # Location of Keyfile including filename
TAGCOUNTFILE="/dataset/semihybrid_ryegrass_GBS/active/elshirer/02_TagCounts/02_MergedTagCounts/All_Ryegrass_PSTI_Testing_20140509.cnt" # Location of the master tag count file including filename with ???????? for date.

#Load modules for the AgResearch CentOS install and run from that
module avail
module load tassel/4

######## TASSEL Options

MINRAM="-Xms512m" # Minimum RAM for Java Machine
MAXRRAM="-Xmx50g" # Maximum RAM for Java Machine
ENZYME="PstI" # See docs for current enzyme list
UPPERBOUND="300000000"

########
# Variables used by script
#######

DATE=$(date +%Y%m%d) #Date from system in the format YYYYMMDD
CHRM="1" # This is used in looping in the body of the program
CHRME="1"  # This is used in looping in the body of the program

########
# Generate the XML Files for the Node to run this process
########


  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE".xml
  echo ' <TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE".xml
  echo '    <fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE".xml
  echo '        <SeqToTBTHDF5Plugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE".xml
  echo '            <i>'$INPUTFOLDER'/</i>' >> "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE".xml 
  echo '            <k>'$KEYFILE'</k>' >> "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE".xml
  echo '            <e>'$ENZYME'</e>' >> "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE".xml
  echo '            <o>'$OUTPUTFOLDER'/'$OUTPUTFILE'_Node'$NODE'_'$DATE'.h5</o>' >> "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE".xml
  echo '            <s>'$UPPERBOUND'</s>' >> "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE".xml
  echo '            <L>FAKELOG_DELETEME.txt</L>' >> "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE".xml
  echo '            <t>' $TAGCOUNTFILE '</t>' >> "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE".xml
  echo '        </SeqToTBTHDF5Plugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE".xml
  echo '    </fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE".xml
  echo '    <runfork1/>' >> "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE".xml
  echo '</TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE".xml

###########
# Record files used in run_pipeline
###########

date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "Name of Machine Script is running on:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
hostname | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "Files available for this run:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log

ls -1 "$INPUTFOLDER" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
ls "$TAGCOUNTFILE" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
ls "$KEYFILE" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log

echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "MD5SUM of files used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
md5sum "$INPUTFOLDER"/* | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "We will not do MD5SUMs of the sequence files to save time for the workshop." | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
md5sum "$TAGCOUNTFILE" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
md5sum "$KEYFILE" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "md5sum of tassel jar file:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
md5sum "$TASSELFOLDER"/sTASSEL.jar | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log

######## For Each Node put the contents of the XML files into the log


  echo "Contents of the XML file for Node $NODE used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
  cat $OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE".xml" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log


echo "Contents of the the shell script used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
cat "$0" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log 
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "Starting Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log

#######
# Run TASSEL for each Node
#######

date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log

  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
  #Run tassel pipeline, redirect stderr to stdout, copy stdout to log file.
  
run_pipeline.pl  "$MINRRAM" "$MAXRRAM" -configFile "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE".xml 2>&1 | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
  date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log

echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "End of Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log

########
# Record md5sums of output files in log
########



echo "md5sum of TBTHDF5 File" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log

md5sum $OUTPUTFOLDER"/"$OUTPUTFILE"_Node"$NODE"_"$DATE".h5" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log

echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_Node_"$NODE"_"$DATE".log
