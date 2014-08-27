#!/bin/sh

MAKEFILE=GBSwf01.01.mk

if [ ! -f ./${MAKEFILE} ]; then
   echo "please cd to bin folder containing ${MAKEFILE} then ./testBuild.sh"
   exit 1
fi

cd ..
ROOT=`pwd`

BUILDROOT=${ROOT}/builds
TESTDATA=${ROOT}/test_data2
BIN=${ROOT}/bin

cd bin

BUILDNAME=GBSTagCountTest1
TARGET=${BUILDROOT}/${BUILDNAME}/tagcounts/individual 

module load tassel/3/3.0.165

echo "building $TARGET , overall verbose logging to ${BUILDNAME}.log (see also *.log under ${BUILDROOT}/${BUILDNAME})"

make -f ${MAKEFILE} -d --no-builtin-rules KEYFILE=${TESTDATA}/Pipeline_Testing_key.txt INPUTFOLDERS="${TESTDATA}/dira ${TESTDATA}/dirb" $TARGET  > ${BUILDNAME}.log 2>&1

echo "finished run, generating tool versions listing (${BUILDNAME}.versions) and a precis of the verbose log (${BUILDNAME}.logprecis)"

make -f ${MAKEFILE} ${BUILDNAME}.versions
make -f ${MAKEFILE} ${BUILDNAME}.logprecis
