#!/bin/bash

# This script iterates through a set of source repositories and a matching set of 
# package metadata directories, and generates a Linux package for each.  At this time,
# it is assumed that the repository is a Python source repository, and the output
# package format is .deb.  It uses the build-python.sh script (in the current directory)
# to generate an installation tree, and uses the deb.sh script (in the current directory)
# to create the .deb.

REPO_DIR="$1"
PKGMD_DIR="$2"
PKGS_DIR="$3"
PACKAGING_DIR="."

BUILD_PYTHON="./build-python.sh"

set -u

usage() {
   echo >&2 "Usage: $0 REPO_SRC_DIR PKG_METADATA_DIR PACKAGE_OUTPUT_DIR"
   exit 1
}

if [ -z "$REPO_DIR" ] || [ -z "$PKGMD_DIR" ]; then 
   usage
   exit 1
fi

mkdir -p "$PKGS_DIR"

while IFS= read PACKAGE; do

   RC=
   SRC_DIR="$REPO_DIR/$PACKAGE"
   PKG_DIR="$PKGMD_DIR/$PACKAGE"

   if ! [ -d "$REPO_DIR" ]; then 
      echo >&2 "FATAL: source directory not found: $SRC_DIR"
      exit 1
   fi

   if ! [ -d "$PKG_DIR" ]; then 
      echo >&2 "FATAL: packaging metadata directory not found: $PKG_DIR"
      exit 1
   fi

   if [ -f "$PKG_DIR/builder.txt" ]; then
       echo "custom builder..."
       BUILD_CMD="$(cat $PKG_DIR/builder.txt)"
       BUILD_DIR="$("$BUILD_CMD" "$SRC_DIR" | tail -n 1 | grep "SUCCESS:")"
       RC=$?
   else
       # build...
       BUILD_DIR="$("$BUILD_PYTHON" "$SRC_DIR" | tail -n 1 | grep "SUCCESS:")"
       RC=$?
   fi

   if [ $RC -ne 0 ]; then 
      echo >&2 "Failed to build $SRC_DIR"
      exit 1
   fi

   BUILD_DIR="$(echo $BUILD_DIR | sed 's/SUCCESS: //g')"
   if [ -z "$BUILD_DIR" ]; then 
      echo >&2 "Failed to build $SRC_DIR"
      exit 1
   fi

   # make deb...
   ./deb.sh "$PKG_DIR" "$BUILD_DIR" "$PKGS_DIR"
   RC=$?

   echo "rm -rf $BUILD_DIR"
   rm -rf "$BUILD_DIR"

   if [ $RC -ne 0 ]; then
      echo >&2 "Failed to package $SRC_DIR"
      exit 1
   fi

done <<EOF
$(ls "$REPO_DIR")
EOF

exit 0


