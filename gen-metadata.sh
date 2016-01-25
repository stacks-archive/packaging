#!/bin/bash

# This script generates all package metadata for a given list of repositories.
# It iterates over a directory containing the repositories, and outputs the 
# corresponding metadata to $PKGMD_DIR/$REPO (where $PKG_DIR is caller-given, and 
# $REPO is the name (basename) of the repository.

REPO_DIR="$1"
PKGMD_DIR="$2"
GEN_REPO_METADATA="./gen-repo-metadata.sh"

set -u

if [ -z "$REPO_DIR" ] || [ -z "$PKGMD_DIR" ]; then 
   echo >&2 "Usage: $0 REPO_DIR PKGMD_DIR"
   exit 1
fi

if ! [ -d "$REPO_DIR" ]; then 
   echo >&2 "FATAL: $REPO_DIR: No such directory"
   exit 1
fi

mkdir -p "$PKGMD_DIR"

if ! [ -d "$PKGMD_DIR" ]; then 
   echo >&2 "FATAL: $PKGMD_DIR: No such directory"
   exit 1
fi

REPO=
while IFS= read REPO; do

   echo "Generate package metadata for $REPO..."
   "$GEN_REPO_METADATA" "$REPO_DIR/$REPO" "$PKGMD_DIR/$REPO"

done <<EOF
$(ls "$REPO_DIR")
EOF

exit 0
