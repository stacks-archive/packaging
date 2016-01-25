#!/bin/bash

# This script takes a Python source directory with a top-level setup.py file,
# and builds and installs the Python package to a temporary directory.
# If it succeeds, the last line emitted to stdout will be "SUCCESS: $BUILD_DIR",
# so other scripts can locate the directory and go from there.

PKG_DIR="$1"
BUILD_DIR=

usage() {
   echo >&2 "Usage: $0 PACKAGE_DIR"
   exit 1
}

cleanup() {
   if [ -n "$BUILD_DIR" ]; then 
       rm -rf "$BUILD_DIR"
   fi
}

if [ -z "$PKG_DIR" ]; then 
   usage
fi

if ! [ -f "$PKG_DIR/setup.py" ]; then 
   echo >&2 "$PKG_DIR/setup.py: No such file or directory"
   usage
fi


BUILD_DIR="$(mktemp -d)"

pushd "$PKG_DIR"

python2.7 ./setup.py build
RC=$?
if [ $RC -ne 0 ]; then 
   popd
   echo >&2 "./setup.py build failed"
   cleanup
   exit 1
fi

python2.7 ./setup.py install --root "$BUILD_DIR"
RC=$?
if [ $RC -ne 0 ]; then 
   popd
   echo >&2 "./setup.py install --root $BUILD_DIR failed"
   cleanup
   exit 1
fi

popd

# NOTE: must always be the last line printed on successful exit
echo "SUCCESS: $BUILD_DIR"
exit 0
