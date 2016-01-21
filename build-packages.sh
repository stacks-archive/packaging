#!/bin/bash

REPO_DIR="$1"
PKGS_DIR="$2"
PACKAGING_DIR="."

set -u

usage() {
   echo >&2 "Usage: $0 REPO_DIR PACKAGE_OUTPUT_DIR"
   exit 1
}

# is a package external from Blockstack?
# that is, does it have a separate package metadata directory,
# under PACKAGING_DIR/external?
#  $1  package name
is_external() {

   local PACKAGE_NAME 

   PACKAGE_NAME="$1"
   if ! [ -d "$PACKAGING_DIR/external/$PACKAGE_NAME" ]; then 
      # nope
      return 1
   fi

   return 0
}


if [ -z "$REPO_DIR" ] || [ -z "PKGS_DIR" ]; then 
   usage
   exit 1
fi

# NOTE: packages do not have spaces
for PACKAGE in $(ls "$REPO_DIR"); do

   RC=
   PKG_DIR=
   SRC_DIR="$REPO_DIR/$PACKAGE"

   if [ "$PACKAGE" = "packaging" ]; then 
      continue
   fi

   if is_external "$PACKAGE"; then 
      PKG_DIR="$PACKAGING_DIR/external/$PACKAGE/pkg"
   else
      PKG_DIR="$REPO_DIR/$PACKAGE/pkg"
   fi

   if ! [ -d "$PKG_DIR" ]; then 
      echo >&2 "BUG: configuration error: packaging metadata directory not found: $PKG_DIR"
      exit 1
   fi

   # build...
   BUILD_DIR="$(./build-python.sh "$SRC_DIR" | tail -n 1 | grep "SUCCESS:")"
   RC=$?

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

   if [ $RC -ne 0 ]; then
      echo >&2 "Failed to package $SRC_DIR"
      exit 1
   fi
done

exit 0


