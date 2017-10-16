#!/bin/bash

# This script goes through each Python repository,
# and if the version is newer than what is available,
# it loads the PyPI credentials required to package it,
# and uploads it to PyPI.

PKG_BASE="$1"
METADATA_BASE="$2"
PYPI_SECRETS="$3"

PYPI_UPLOADER="./pypi.sh"

for PKG_NAME in $(ls "$PKG_BASE"); do
   METADATA_DIR="$METADATA_BASE/$PKG_NAME"
   PKG_DIR="$PKG_BASE/$PKG_NAME"

   if ! [ -d "$METADATA_DIR" ] || ! [ -d "$PKG_DIR" ]; then
      echo >&2 "Missing $METADATA_DIR or $PKG_DIR"
      exit 1
   fi

   echo "Uploading $PKG_NAME"
   "$PYPI_UPLOADER" "$PKG_DIR" "$METADATA_DIR" "$PYPI_SECRETS"

   if [ $? -ne 0 ]; then
      echo "Failed to upload $PKG_NAME to PyPI"
   fi
done

exit 0
