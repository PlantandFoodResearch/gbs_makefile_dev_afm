########################################################################################
# Genotyping by Sequencing Workflow version 1. 
# *** this is a work in progress (version 0.01 or so)             ***  
# *** refer to "Development Notes" at the bottom of this file     ***
#***************************************************************************************
# changes 
#***************************************************************************************
# 
#***************************************************************************************
# references:
#***************************************************************************************
# make: 
#     http://www.gnu.org/software/make/manual/make.html
# tassel:
#     http://www.maizegenetics.net/index.php?option=com_content&task=view&id=89&Itemid=119
#
#*****************************************************************************************
# global variable names  - these don't change from run to run (if any of these do, move it),
# - only from installation to installation  
#*****************************************************************************************
# program names as variables
RUN_TASSEL_PIPELINE=run_pipeline.pl
								
# tassel parameters
ENZYME=PstI
MINCOUNT=1
MAXGOODREADS=300000000
MINRAM=-Xms512m 
MAXRRAM=-Xmx12g

#standard patterns used to find files and folders
FASTQ_SUFFIX=fastq.gz

#*****************************************************************************************
# run-specific variable names - some of these are here for development only, they will 
# ultimately be set (probably) by command-line arguments. Others are system or derived variables
# and will stay here .   
#*****************************************************************************************
#KEYFILE is set on command-line 
#INPUTFOLDERS are set on command line 
#NODE=1 not supported yet 

DATE=$(strip $(shell date +%Y%m%d))

#*****************************************************************************************
# various calculated lists that can be useful in targets and rules - e.g. lists
# of all fastq files in the input folders etc
#*****************************************************************************************
#
#
# list of all of the fastq files in the input folders. E.G. this variable is 
# used early on to set up the links to the input files, in the "raw" project 
# folder
files_to_process :=  $(foreach name, $(INPUTFOLDERS), $(wildcard $(name)/*$(FASTQ_SUFFIX))) 

#*****************************************************************************************
# example - this is an example script using this makefile
#*****************************************************************************************
##!/bin/sh
#ROOT=`pwd`
#BUILDROOT=${ROOT}/builds
#TESTDATA=${ROOT}/test_data2
#BIN=${ROOT}/bin
#cd bin
#BUILDNAME=GBSTagCountTest1
#TARGET=${BUILDROOT}/${BUILDNAME}/tagcounts/individual
#
#
#
#module load tassel/3/3.0.165
#echo "building $TARGET , overall verbose logging to ${BUILDNAME}.log (see also *.log under ${BUILDROOT}/${BUILDNAME})"
#make -f GBSwf1.0.mk -d --no-builtin-rules KEYFILE=${TESTDATA}/Pipeline_Testing_key.txt INPUTFOLDERS="${TESTDATA}/dira ${TESTDATA}/dirb" $TARGET  > ${BUILDNAME}.log 2>&1
#echo "finished run, generating tool versions listing (${BUILDNAME}.versions) and a precis of the verbose log (${BUILDNAME}.logprecis)"
#make -f GBSwf1.0.mk ${BUILDNAME}.versions
#make -f GBSwf1.0.mk ${BUILDNAME}.logprecis


###############################################
# top level target "logprecis" . This extracts from the log file the 
# relevant commands that were run, in a readable order 
# - run this after the actual build has been completed
###############################################
%.logprecis: %.log
	echo "creating folders" > $@
	echo "----------------" >> $@
	egrep "^mkdir " $*.log >> $@
	echo "linking to raw data" >> $@
	echo "------" >> $@
	egrep "^ln -s" $*.log >> $@
	echo "running Tassel" >> $@
	echo "--------------" >> $@
	egrep "^$(RUN_TASSEL_PIPELINE)" $*.log >> $@

###############################################
# top level phony target "versions"  - output versions of all tools 
# - note , you need to tell make to ignore errors 
# for this target - for some tools , the only way to get a version
# string is to run them with options that provoke an error
# Where useful, this reports the package name as well 
# as getting the tool to report its version.
# (in some cases e.g. bamtools this is all the version
# info there is as the tool itself doesn't report any
# version info)
# (not all the tools that were used are installed 
# as packages currently )
###############################################
.PHONY : %.versions 
%.versions:
	echo "Tool versions : " > $@
	echo "Tassel"  >> $@
	echo "------"  >> $@
	#echo $(RUN_TASSEL) -version  >> $@
	#$(RUN_TASSEL) -version  >> $@  2>&1
	echo "env | grep LOADEDMODULES" >> $@
	env | grep LOADEDMODULES  >> $@ 2>&1
	echo "Java" >> $@
	echo "----" >> $@
	echo java -version >> $@ 
	java -version >> $@ 2>&1
       


##########################################################################################
# how to make the tagcounts.
# ref : 
#02_01_run_qseqtotagcounts.sh:INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/scratch/raw
#02_01_run_qseqtotagcounts.sh:OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/02_TagCounts/01_IndividualTagCounts
##########################################################################################
#
# define the XML config we will use in this rule (should be able to do this with a define...endef 
# block but for some strange reason that doesn't set the variable). When 
# referenced in the rule, the embedded make variable references expand to the 
# actual values needed

XMLTEMPLATE_FastqToTagCounts ='\
<?xml version="1.0" encoding="UTF-8" standalone="no"?>  \
 <TasselPipeline>                                       \
    <fork1>                                             \
        <FastqToTagCountPlugin>                         \
            <i>$(*D)/$(*F)raw</i>                       \
            <o>$@</o>                                   \
            <k>$(*D)/keyfile.txt</k>      	        \
            <e>$(ENZYME)</e>                            \
            <s>$(MAXGOODREADS)</s>                      \
            <c>$(MINCOUNT)</c>                          \
        </FastqToTagCountPlugin>                        \
    </fork1>                                            \
    <runfork1/>                                         \
</TasselPipeline>'


.SECONDEXPANSION:
%tagcounts/individual: %raw $$(*D)/keyfile.txt
	# set up output sub-folder
	mkdir $@
	# create config-file source (this contains the actual values for the run 
	# but typically needs tweaking to be valid XML - e.g. remove
	# the opening space is inserted when the variable is echoed to a file
	echo $(strip $(XMLTEMPLATE_FastqToTagCounts)) > $@/FastqToTagCounts.xml.source
	# sanitise the XML
	cat $@/FastqToTagCounts.xml.source | sed 's/^ //g' > $@/FastqToTagCounts.xml
	# run Tassel
	$(RUN_TASSEL_PIPELINE) $(MINRRAM) $(MAXRRAM) -configFile $@/FastqToTagCounts.xml > $@/FastqToTagCounts.log  2>&1 


##########################################################################################
# how to "make" the keyfile. Ultimately this may involve some build / metdata retrieval 
# however currently we just create a link in the build folder to the "given" key file. This 
# means that when you look in the build folder you can immediately see the keyfile used
# (rather than have to look at log file)
##########################################################################################
%keyfile.txt:
	ln -s $(KEYFILE) $@



##########################################################################################
# how to make the raw folder. This is to contain shortcuts to the 
# fastq files . The dependency variable expands to a list of link names
# 
# the original script creates a raw sequence folder and (optionally ?) sets up shortcuts to the
# sequence files in the "real" raw folder - e.g.
# intrepid# ls -l /dataset/semihybrid_ryegrass_GBS/active/elshirer/01_RawSequence
#lrwxrwxrwx 1 elshirer plant_users 65 May  6 11:33 C1TTPACXX_3_fastq.gz -> /dataset/semihybrid_ryegrass_GBS/scratch/raw/C1TTPACXX_3_fastq.gz
#lrwxrwxrwx 1 elshirer plant_users 65 May  6 11:33 C1TTPACXX_5_fastq.gz -> /dataset/semihybrid_ryegrass_GBS/scratch/raw/C1TTPACXX_5_fastq.gz
#
# working from a single source directory that has links to the actual data is a good idea
# as handles the situation where the original data is in a number of different folders.
# ref : 
# /active/nzgl00891/bbs_dev/original_scripts/01_create_run_folders.sh
# mkdir -p "$BASEFOLDER"/"$USER"/01_RawSequence
# /active/nzgl00891/bbs_dev/original_scripts/02_01_run_qseqtotagcounts.sh
# 02_01_run_qseqtotagcounts.sh:INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/scratch/raw
##########################################################################################
.SECONDEXPANSION:
%raw: %init $$(addprefix $$@/,$$(notdir $$(files_to_process)))
	echo $@

##########################################################################################
# This rule handles setting up the soft-links from the "raw" folder to the 
# actual fastq files.
# The variable expands to the first actual file that matches the link name.
# !!!! TO DO !!!! - check for name collisions between fastq in different
# input folders
%fastq.gz:  
	ln -s $(firstword $(filter %$(*F)fastq.gz,$(files_to_process))) $@

##########################################################################################
# how to "init" a run. Various things may need to be done here. Not much yet 
# - just creating the build folder , standard sub-folders and initialising the project log file 
# There are potentially a number of actions needed to marshall the raw files
# for the first processing step - for example we may acquire metadata at this
# point etc
#
# ref :
# /active/nzgl00891/bbs_dev/original_scripts/01_create_run_folders.sh
# mkdir -p "$BASEFOLDER"/"$USER"/01_RawSequence
# /active/nzgl00891/bbs_dev/original_scripts/02_01_run_qseqtotagcounts.sh
# 02_01_run_qseqtotagcounts.sh:INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/scratch/raw
##########################################################################################
%init:
	# make build folder
	mkdir $(*D)
	# make init folder
	mkdir $@
	# make raw folder
	mkdir $(*D)/raw
	# make tagcounts folder (later rules create sub-folders)
	mkdir $(*D)/tagcounts
        #.....and make some other folders....
	# initialise project log
	echo Build starting $(DATE) > $(*D)/project.log
 

##############################################
# specify the intermediate files to keep 
##############################################
.PRECIOUS: %init %raw %fastq.gz %keyfile.txt %tagcounts/individual

##############################################
# cleaning - not yet doing this using make  
##############################################
clean:
	echo "no clean for now" 



#*****************************************************************************************
# Development Notes   
#*****************************************************************************************
# Makefile targets are being set up more or less corresponding to the outputs of the original scripts : 
#
#$ grep "OUTPUTFOLDER=" *.sh
#02_01_run_qseqtotagcounts.sh:OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/02_TagCounts/01_IndividualTagCounts" # Where output of script should go
#02_02_run_mergetagcounts.sh:OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/02_TagCounts/02_MergedTagCounts" # Where output of script should go
#02_03_run_tagcounttofastq.sh:OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/02_TagCounts/03_TagCountToFastq" # Where output of script should go
#03_run_alignwithbowtie2.sh:OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/03_SAM" # Where output of script should go
#04_run_createTOPM.sh:OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/04_TOPM" # Where output of script should go
#05_01_run_seqtotbthdf5.sh:OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/elshirer/05_TBT/01_IndividualTBT" # Where output of script should go
#05_02_run_mergetbthdf5.sh:OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/05_TBT/02_MergedTBT" # Where output of script should go
#05_03_run_mergetaxatbthdf5.sh:OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/05_TBT/03_MergedTaxaTBT" # Where output of script should go
#05_04_run_pivotmergetaxatbthdf5.sh:OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/05_TBT/04_PivotMergedTaxaTBT" # Where output of script should go
#06_01_run_callsnps.sh:OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/06_HapMap/01_UnfilteredSNPs" # Where output of script should go
#06_02_run_mergedupsnps.sh:OUTPUTFOLDER="/workdir/"$USER"/06_HapMap/02_MergeDupSNPs" # Where output of script should go
#
#
# The makefile dependency structure between these outputs is (broadly) obtained by matching inputs of the original 
# scripts with their outputs - i.e. by matching the list below with the list above : 
#
#grep "INPUTFOLDER=" #*.sh
#02_01_run_qseqtotagcounts.sh:INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/scratch/raw" # Where the input sequence files reside
#02_02_run_mergetagcounts.sh:INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/02_TagCounts/01_IndividualTagCounts" # Where the input sequence files reside
#02_03_run_tagcounttofastq.sh:INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/02_TagCounts/02_MergedTagCounts" # Where the input sequence files reside
#03_run_alignwithbowtie2.sh:INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/02_TagCounts/03_TagCountToFastq" # Where the input sequence files reside
#04_run_createTOPM.sh:INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/03_SAM" # Where the input sequence files reside
#05_01_run_seqtotbthdf5.sh:INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/elshirer/01_RawSequence" # Where the input sequence files reside
#05_02_run_mergetbthdf5.sh:INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/05_TBT/01_IndividualTBT" # Where the input sequence files reside
#05_03_run_mergetaxatbthdf5.sh:INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/05_TBT/02_MergedTBT" # Where the input sequence files reside
#05_04_run_pivotmergetaxatbthdf5.sh:INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/05_TBT/03_MergedTaxaTBT" # Where the input sequence files reside
#06_01_run_callsnps.sh:INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/"$USER"/05_TBT/04_PivotMergedTaxaTBT" # Where the input pivotTBT files reside
#06_02_run_mergedupsnps.sh:INPUTFOLDER="/workdir/"$USER"/06_HapMap/01_UnfilteredSNPs" # Where the input hapmap files reside
#
#
# Thus the starting point is "RAW", and this is the second to lowest level target
#
# * Folder setup 
#
#    the original scripting has an initial step to create all of the output folders needed. The makefile port
#    differs slightly - the "init" target creates top level output folders, but sub-folders 
#    are created under these by later rules 
#
# * Logging
#    
#    logging is now done in three ways : 
#
#    1. the make itself is run using the "debug" mode of make. This generates a very verbose log. After the 
#       run, a precis of this log is generated (using %.logprecis target above)
#    2. as previously, some individual steps direct output to a specific log file in a sub-folder 
#       (e.g. tassel runs). 
#    3. after the run , a listing of software  versions is generated using the "%.versions"
#       target above. 
#       This ensures that we can capture tool versions even where the tool may not announce its version
#       (for example using rpm , looking at environment variables etc - i.e. the 
#       %.versions rule can be customised to discover and log versioning as required)
#   
#    (not using "tee" as previously)
# 
# * loading the Tassel environment (module load tassel)
#
#   This is not done in the makefile itself, because normally a new shell handles every
#   command - so the module would only be loaded for the shell which loaded the module.
#   There are ways around that such as "one shell" - however that may not play well 
#   with the -j option of make (to turn on some parallelism). Its simplest just 
#   to load the environment you need in a script which calls the makefile
#   (In some cases one finds that different targets need different environments. That
#   can usually handled by making the target in two stages - "make stage1" , "make stage2"
#    - and before each stage load the environment required. (That is not all that likely to 
#   crop up here but could do)
# 
#
#


