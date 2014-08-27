#!/bin/sh
# This program runs the DiscoverySNPCallerPlugin plugin in TASSEL 3 according to user modfied parameters
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

########
# User Modified Parameters
########

######## Meta Information

PROJECT=$USER # PI  or Project NAME
STAGE="UNFILTERED" #UNFILTERED / MERGEDUPSNPS / HAPMAPFILTERED / BPEC / IMPUTED
BUILD="All_Ryegrass_PSTI_Testing_0.9" #Build Designation
BUILDSTAGE="RC-1" #this is RC-# or FINAL

####### File Locations

TASSELFOLDER="/home/elshirer/tassel3.0_standalone" # Where the TASSEL3 run_pipeline.pl resides
INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/05_TBT/04_PivotMergedTaxaTBT" # Where the input pivotTBT files reside
OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/06_HapMap/01_UnfilteredSNPs" # Where output of script should go
INPUTFILE="mergeTBTHDF5_mergedtaxa_pivot"  # Base name of Input HDF5 files.
TOPMBASE="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/04_TOPM/All_Ryegrass_PSTI_Testing" # location of TOPM file including the base name of the file
#PEDIGREE_FILE="/home/local/MAIZE/rje22/build20120701/50_KeyFiles/AllZeaPedigree20120730.txt" #location of the pedigree file
REFERENCEGENOME="/dataset/ryegrass_genome_072012/active/danish_reference/LP_GBS_reference.fa" 
#Load modules for the AgResearch CentOS install and run from that

module load tassel/4
######## TASSEL Options

MINRAM="-Xms512m" # Minimum RAM for Java Machine
MAXRRAM="-Xmx24g" # Maximum RAM for Java Machine
STARTCHRM="1" # Chromosome to start with
ENDCHRM="14" # Chromosome to end with
MNF="0.9" # Minimum value of F (inbreeding coeffficient) not tested by default
MNMAF="0.01" # Minimum minor allele frequency. Defaults to 0.01 SNPS that pass either the specified mnMAF or mnMAC (see next) will be output.
MNMAC="2000" # Minimum minor allele count. Defaults to 10. SNPS that pass either the specified mnMAF or mnMAC (see previous) will be output.
MNLCOV="0.1" # Minimum locus coverage, the proportion of taxa with at least 1 tag at a locus. Default 0.1
INCLRARE="" # not implemented in this script -- placeholder
INCLGAPS="" # not implemented in this script -- placeholder

########
# Variables used by script
#######

DATE=$(date +%Y%m%d) #Date from system in the format YYYYMMDD
CHRM="1" # This is used in looping in the body of the program
CHRME="1"  # This is used in looping in the body of the program
INPUTNAME=$INPUTFOLDER"/"$INPUTFILE"_????????.h5" # This assigns the input name _YYYYMMDD.h5 this is the output.
TOPM=$TOPMBASE"_????????.topm"

########
# Make a copy of the TOPM to add variants into
########

cp $TOPM $OUTPUTFOLDER'/variantTOPM'$DATE'.topm'

########
# Generate the XML Files for each chromosome to run this process
########

CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
  echo ' <TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
  echo '    <fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
  echo '        <DiscoverySNPCallerPlugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
  echo '            <i>' $INPUTNAME '</i>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml 
  echo '            <o>'$OUTPUTFOLDER'/'$PROJECT'_'$STAGE'_'$BUILD'_'$BUILDSTAGE'_chr+.hmp.txt.gz</o>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
  echo '            <m>' $TOPM '</m>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
  echo '            <mUpd>'$OUTPUTFOLDER'/variantTOPM'$DATE'.topm </mUpd>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
  echo '            <ref>' $REFERENCEGENOME '</ref>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
 # echo '            <mnF>'$MNF'</mnF>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
  echo '            <mnMAF>'$MNMAF'</mnMAF>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
  echo '            <mnMAC>'$MNMAC'</mnMAC>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
  echo '            <mnLCov>'$MNLCOV'</mnLCov>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
  echo '            <sC>'$STARTCHRM'</sC>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
  echo '            <eC>'$ENDCHRM'</eC>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
 # echo '            <p>'$PEDIGREE_FILE'</p>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
  echo '        </DiscoverySNPCallerPlugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
  echo '    </fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
  echo '    <runfork1/>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
  echo '</TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml
  CHRM=$((CHRM+1))

###########
# Record files used in run_pipeline
###########

date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "Name of Machine Script is running on:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
hostname | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "Files available for this run:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
ls $INPUTNAME | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
ls $TOPM | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
# ls $PEDIGREE_FILE | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "MD5SUM of files used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
md5sum $INPUTNAME | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
md5sum $TOPM | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
# md5sum $PEDIGREE_FILE | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "md5sum of tassel jar file:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
md5sum "$TASSELFOLDER"/sTASSEL.jar | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log

######## For Each chromosome put the contents of the XML files into the log

CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
  echo "Contents of the XML file used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
  cat $OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
  CHRM=$((CHRM+1))

echo "Contents of the the shell script used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
cat "$0" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log 
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "Starting Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log

#######
# Run TASSEL for each chromosome
#######

date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
  #Run tassel pipeline, redirect stderr to stdout, copy stdout to log file.
  
 run_pipeline.pl  "$MINRRAM" "$MAXRRAM" -configFile "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS.xml 2>&1 | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
  date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
  CHRM=$((CHRM+1))
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "End of Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log

########
# Record md5sums of output files in log
########

######################################  This section will need some help. Specifically with renaming the files to something reasonable and then md5summing them.

echo "md5sum of hapmap File" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
md5sum "$OUTPUTFOLDER"/*chr"$CHRM".hmp.txt.gz | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
  CHRM=$((CHRM+1))
done
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log

########
# Create zip archive of hapmap files, log, name list and release notes
########

#zip -D "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$BUILD"_"$BUILDSTAGE"_"$DATE".zip "$OUTPUTFOLDER"/*.hmp.txt.gz "$PEDIGREE_FILE" "$RELEASENOTES" "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log | tee -a "$OUTPUTFOLDER"/"$PROJECT"_CALLSNPS_"$DATE".log
