#!/bin/bash

if [ $# -lt 5 ]; then
	echo "Usage:"
	echo "  build-clang.sh <src-dir> <clang|gcc> <branch> <build-dir> <install-dir>"
	exit
fi


ORIGINAL_PWD="`pwd`"
SRC_DIR="$1"
COMPILER_TO_USE="$2"
BRANCH_TO_CHECKOUT="$3"
BUILD_DIR="$4"
INSTALL_DIR="$5"
NUM_BUILD_JOBS=4



##
# Prepare src folder
##
if [ ! -d "${SRC_DIR}" ]; then
	echo "${SRC_DIR} not exist... creating it..."
	mkdir -p "${SRC_DIR}"

	if [ ! -d "${SRC_DIR}" ]; then
		echo "ERROR: Couldn't create [${SRC_DIR}] folder!"
		exit 1
	fi
else
	echo "${SRC_DIR} already exist... cleaning it..."
	#rm -rf ${SRC_DIR}/*
fi

##
# Prepare build folder
##
if [ ! -d "${BUILD_DIR}" ]; then
	echo "${BUILD_DIR} not exist... creating it..."
	mkdir -p "${BUILD_DIR}"

	if [ ! -d "${BUILD_DIR}" ]; then
		echo "ERROR: Couldn't create [${BUILD_DIR}] folder!"
		exit 1
	fi
else
	echo "${BUILD_DIR} already exist... cleaning it..."
	#rm -rf ${BUILD_DIR}/*
fi

##
# Prepare install folder
##
if [ ! -d "${INSTALL_DIR}" ]; then
	echo "${INSTALL_DIR} not exist... creating it..."
	mkdir -p "${INSTALL_DIR}"

	if [ ! -d "${INSTALL_DIR}" ]; then
		echo "ERROR: Couldn't create [${INSTALL_DIR}] folder!"
		exit 1
	fi
else
	echo "${INSTALL_DIR} already exist..."
	#echo "${INSTALL_DIR} already exist... cleaning it..."
	#rm -rf ${INSTALL_DIR}/*
fi




##
# clone/update LLVM
##
cd "${SRC_DIR}"
if [ ! -d "./llvm" ]; then
	git clone http://llvm.org/git/llvm llvm
fi
wait
cd llvm
git reset --hard HEAD
wait
git fetch -f origin
wait
git checkout "${BRANCH_TO_CHECKOUT}"
wait



	##
	# clone/update Clang
	##
	cd tools
	if [ ! -d "./clang" ]; then
		git clone http://llvm.org/git/clang clang
	fi
	wait
	cd clang
	git reset --hard HEAD
	wait
	git fetch -f origin
	wait
	git checkout "${BRANCH_TO_CHECKOUT}"
	wait	

	##
	# clone/update Clang-Tools-Extra
	##
	cd tools
	if [ ! -d "./extra" ]; then
		git clone http://llvm.org/git/clang-tools-extra extra
	fi
	wait
	cd extra
	git reset --hard HEAD
	wait
	git fetch -f origin
	wait
	git checkout "${BRANCH_TO_CHECKOUT}"
	wait	

	##
	# clone/update Compiler-RT
	##
	cd "../../../../projects"
	if [ ! -d "./compiler-rt" ]; then
		git clone http://llvm.org/git/compiler-rt compiler-rt
	fi
	wait
	cd compiler-rt
	git reset --hard HEAD
	wait
	git fetch -f origin
	wait
	git checkout "${BRANCH_TO_CHECKOUT}"
	wait	
	

	##
	# clone/update libcxx
	##
	cd ..
	if [ ! -d "./libcxx" ]; then
		git clone http://llvm.org/git/libcxx libcxx 
	fi
	wait
	cd libcxx
	git reset --hard HEAD
	wait
	git fetch -f origin
	wait
	git checkout "${BRANCH_TO_CHECKOUT}"
	wait

	
	##
	# clone/update libcxxabi
	##
	cd "../"
	if [ ! -d "./libcxxabi" ]; then
		git clone http://llvm.org/git/libcxxabi libcxxabi 
	fi
	wait
	cd libcxxabi
	git reset --hard HEAD
	wait
	git fetch -f origin
	wait
	git checkout "${BRANCH_TO_CHECKOUT}"
	wait	
	

	##
	# Return to original forlder
	##
	cd "${ORIGINAL_PWD}"

	##
	# Go to build folder
	##
	cd "${BUILD_DIR}"
	
	##
	## Generate CMake project
	##
	if [ "${COMPILER_TO_USE}" == "clang" ]; then
		#cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLLVM_LIBDIR_SUFFIX=64 -DLLVM_ENABLE_EH=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_PARALLEL_COMPILE_JOBS=${NUM_BUILD_JOBS} -DLLVM_PARALLEL_LINK_JOBS=${NUM_BUILD_JOBS} -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} "${SRC_DIR}/llvm"
		cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLLVM_LIBDIR_SUFFIX=64 -DLLVM_PARALLEL_COMPILE_JOBS=${NUM_BUILD_JOBS} -DLLVM_PARALLEL_LINK_JOBS=${NUM_BUILD_JOBS} -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} "${SRC_DIR}/llvm"
	elif [ "${COMPILER_TO_USE}" == "gcc" ]; then
		#cmake -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DLLVM_LIBDIR_SUFFIX=64 -DLLVM_ENABLE_EH=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_PARALLEL_COMPILE_JOBS=${NUM_BUILD_JOBS} -DLLVM_PARALLEL_LINK_JOBS=${NUM_BUILD_JOBS} -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} "${SRC_DIR}/llvm"
		cmake -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DLLVM_LIBDIR_SUFFIX=64 -DLLVM_PARALLEL_COMPILE_JOBS=${NUM_BUILD_JOBS} -DLLVM_PARALLEL_LINK_JOBS=${NUM_BUILD_JOBS} -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} "${SRC_DIR}/llvm"
	else
		echo "ERROR: Unknown comiler!"
		exit 1
	fi
	##
	# build with cmake
	##
	#cmake --build .
	make -j ${NUM_BUILD_JOBS}
	wait
	rm -rf ${INSTALL_DIR}/*
	wait
	cmake --build . --target install
	wait

cd "${ORIGINAL_PWD}"
