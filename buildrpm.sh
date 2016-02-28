#!/bin/bash

VERSION=3.7.1
TEMPORARY_BUILD_DIRECTORY=`mktemp -d`


if [ $# = 4 ]; then
	RELEASE=$1
	SOURCE_DIR=$2
	TARGET_DIR=$3
	SPEC_FILE=$4
else
	echo "buildrpm.sh <release_numebr> <src_dir> <target_dir> <spec_file>"
	exit 1
fi



OLD_DIR=`pwd`

echo "Building release: ${RELEASE}"


rpmbuild --define="_topdir ${TEMPORARY_BUILD_DIRECTORY}" \
	--define="SOURCE_DIRECTORY ${SOURCE_DIR}" \
	--define="_Release ${RELEASE}" \
	--define="_Version ${VERSION}" \
	-bb ${SPEC_FILE}

cd ${OLD_DIR}
echo "Moving `ls ${TEMPORARY_BUILD_DIRECTORY}/RPMS/x86_64/*` to ${TARGET_DIR}"
mv ${TEMPORARY_BUILD_DIRECTORY}/RPMS/x86_64/* ${TARGET_DIR}

rm -r ${TEMPORARY_BUILD_DIRECTORY}

