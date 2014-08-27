#!/bin/sh
# This program runs the ModifyTBTHDF5Plugin plugin in TASSEL 3 to merge individual TBTHDF5 Files according to user modfied parameters
# and generates a log file RJE 20120830

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
# This program depends on TASSEL 3, md5sum and zip
########

########
# User Modified Parameters
########

######## Meta Information

PROJECT=$USER # PI  or Project NAME

####### File Locations

TASSELFOLDER="/home/elshirer/tassel3.0_standalone" # Where the TASSEL4 run_pipeline.pl resides
INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/05_TBT/01_IndividualTBT" # Where the input sequence files reside
OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/05_TBT/02_MergedTBT" # Where output of script should go
INPUTFILE="All_Ryegrass_PSTI_Testing" # Base name of Input HDF5 files. (outputfile from run_seqtotbthdf5.sh)
OUTPUTFILE="mergeTBTHDF5" # Base name of Output HDF5 file.
STARTNODE="1" # Use this to identify the first node of the run_seqtotbthdf5.sh script.
ENDNODE="2" # Use this to identify the last node of the run_seqtotbthdf5.sh script.
#Load modules for the AgResearch CentOS install and run from that
module avail
module load tassel/4

######## TASSEL Options

MINRAM="-Xms512m" # Minimum RAM for Java Machine
MAXRRAM="-Xmx24g" # Maximum RAM for Java Machine

########
# Variables used by script
#######

DATE=$(date +%Y%m%d) #Date from system in the format YYYYMMDD
NODE="1" # This is used in looping in the body of the program
NODEE="1"  # This is used in looping in the body of the program

########
# Generate the XML Files for each node to run this process
########

NODE=$STARTNODE
NODE=$((NODE+1)) # increment immediately because we will use node one as the initial hdf5 file
NODEE=$((ENDNODE+1))
while [ $NODE -lt $NODEE ]; do
INPUTNAME=$INPUTFOLDER'/'$INPUTFILE'_Node'$NODE'_????????.h5' # This assigns the input name TBT_Node#_YYYYMMDD.h5 this is the output from run_seqtotbthdf5 It assumes unique node #
  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_node_"$NODE".xml
  echo ' <TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_node_"$NODE".xml
  echo '    <fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_node_"$NODE".xml
  echo '        <ModifyTBTHDF5Plugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_node_"$NODE".xml
  echo '            <i>' $INPUTNAME '</i>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_node_"$NODE".xml
  echo '            <o>'$OUTPUTFOLDER'/'$OUTPUTFILE'_'$DATE'.h5</o>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_node_"$NODE".xml
  echo '        </ModifyTBTHDF5Plugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_node_"$NODE".xml
  echo '    </fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_node_"$NODE".xml
  echo '    <runfork1/>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_node_"$NODE".xml
  echo '</TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_node_"$NODE".xml
  NODE=$((NODE+1))
done

###########
# Record files used in run_pipeline
###########

date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "Name of Machine Script is running on:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
hostname | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "Files available for this run:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
ls -1 "$INPUTFOLDER"/*.h5 | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "MD5SUM of files used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
md5sum "$INPUTFOLDER"/*.h5 | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "md5sum of tassel jar file:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
md5sum "$TASSELFOLDER"/sTASSEL.jar | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log

######## For Each node put the contents of the XML files into the log

NODE=$STARTNODE
NODE=$((NODE+1)) # increment immediately because we will use node one as the initial hdf5 file
NODEE=$((ENDNODE+1))
while [ $NODE -lt $NODEE ]; do

  echo "Contents of the XML file for node $NODE used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
  cat $OUTPUTFOLDER"/"$PROJECT"_SEQTOTBTHDF5_node_"$NODE".xml" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
  NODE=$((NODE+1))
done

echo "Contents of the the shell script used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
cat "$0" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log 
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "Starting Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log

########
# This step requires something to merge into. To meet that We copy the first node into what will be the output file for tassel and 
# move directly onto the 2nd node. If there is only one node only the copy step takes place.
########

NODE=$STARTNODE
INPUTNAME=$INPUTFOLDER'/'$INPUTFILE'_Node'$NODE'_????????.h5' # This assigns the input name TBT_Node#_YYYYMMDD.h5 this is the output from run_seqtotbthdf5 It assumes unique node #
cp $INPUTNAME $OUTPUTFOLDER"/"$OUTPUTFILE"_"$DATE".h5"

#######
# Run TASSEL for each node
#######

date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
NODE=$STARTNODE
NODE=$((NODE+1)) # increment immediately because we will use node one as the initial hdf5 file
NODEE=$((ENDNODE+1))
while [ $NODE -lt $NODEE ]; do
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
  #Run tassel pipeline, redirect stderr to stdout, copy stdout to log file.
  run_pipeline.pl  "$MINRRAM" "$MAXRRAM" -configFile "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_node_"$NODE".xml 2>&1 | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
  date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
  NODE=$((NODE+1))
done

echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "End of Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log

########
# Record md5sums of output files in log
########



echo "md5sum of TBTHDF5 File" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log

md5sum   $OUTPUTFOLDER"/"$OUTPUTFILE"_"$DATE".h5"| tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log

echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log
date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_MERGETBTHDF5_"$DATE".log

