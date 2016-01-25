#!/bin/bash

# This script fetches a set of repositories, either from a git remote,
# or from a local directory (at ./imported), and puts them into a 
# caller-designated directory.
# 
# The list of repositories is specified as a file, and has the format:
# [repo-name] [repo-url]\n
# If [repo-url] is not given, then it is assumed to be local, and should
# be present under ./imported.

REPO_LIST="$1"
REPO_DIR="$2"
IMPORTED="./imported"

set -u 

if [ -z "$REPO_LIST" ] || [ -z "$REPO_DIR" ]; then 
   echo >&2 "Usage: $0 REPO_LIST REPO_DIR"
   exit 1
fi

mkdir -p "$REPO_DIR"

while IFS= read PKG_LINE; do
   
   IFS=" "
   set $PKG_LINE

   REPO_NAME="$1"
   REPO_URL=""
   BRANCH="master"

   if [ $# -eq 2 ]; then 
      REPO_URL="$2"
   elif [ $# -eq 3 ]; then
      REPO_URL="$2" 
      BRANCH="$3"
   fi

   RC=

   if [ -z "$REPO_URL" ]; then 
      # should be imported 
      if ! [ -d "$IMPORTED/$REPO_NAME" ]; then 
         echo >&2 "Missing imported repository \"$REPO_NAME\" (expected it in $IMPORTED/$REPO_NAME)"
         exit 1
      fi

      cp -a "$IMPORTED/$REPO_NAME" "$REPO_DIR/"

   else
    
      if ! [ -d "$REPO_DIR/$REPO_NAME" ]; then 
         # fetch 
         pushd "$REPO_DIR" >/dev/null
         git clone "$REPO_URL" "$REPO_NAME"
         RC=$?
         popd >/dev/null

      else
         # refresh 
         pushd "$REPO_DIR/$REPO_NAME" >/dev/null
         git pull
         RC=$?
         popd >/dev/null
      fi

      if [ $RC -ne 0 ]; then 
         echo >&2 "Failed to fetch or refresh $REPO_DIR/$REPO_NAME"
         exit 1
      fi

      pushd "$REPO_DIR/$REPO_NAME" >/dev/null

      git checkout "$BRANCH"
      RC=$?

      if [ $RC -ne 0 ]; then 
         echo >&2 "Failed to switch to branch \"$BRANCH\" in $REPO_DIR/$REPO_NAME"
         exit 1
      fi

      git pull
      RC=$?

      if [ $RC -ne 0 ]; then 
         echo >&2 "Failed to pull latest branch \"$BRANCH\" in $REPO_DIR/$REPO_NAME"
         exit 1
      fi

      popd >/dev/null
   fi
done <<EOF
$(cat "$REPO_LIST")
EOF

exit 0
