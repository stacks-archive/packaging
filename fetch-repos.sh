#!/bin/bash

# This script fetches a set of repositories, either from a git remote,
# or from a local directory (at ./imported), and puts them into a 
# caller-designated directory.
# 
# The list of repositories is specified as a file, and has the format:
# [repo-name] [repo-url]\n
# If [repo-url] is not given, then it is assumed to be local, and should
# be present under ./imported.

MD_DIR="$1"
REPO_DIR="$2"
RELEASE="$3"
IMPORTED="./imported"

set -u 

if [ -z "$MD_DIR" ] || [ -z "$REPO_DIR" ] || [ -z "$RELEASE" ]; then 
   echo >&2 "Usage: $0 MD_DIR REPO_DIR RELEASE"
   exit 1
fi

mkdir -p "$REPO_DIR"

while IFS= read PKG_MD_DIR; do

   REPO_MD_FILE="$MD_DIR/$PKG_MD_DIR/repo.txt"
   REPO_NAME="$PKG_MD_DIR"

   if ! [ -f "$REPO_MD_FILE" ]; then
      # should be imported 
      if ! [ -d "$IMPORTED/$REPO_NAME" ]; then 
         echo >&2 "Missing imported repository \"$REPO_NAME\" (expected it in $IMPORTED/$REPO_NAME)"
         exit 1
      fi

      cp -a "$IMPORTED/$REPO_NAME" "$REPO_DIR/"
      continue

   else

      # need to fetch 
      REPO_LINE="$(egrep ^"$RELEASE" "$REPO_MD_FILE")"
      if [ -z "$REPO_LINE" ]; then 
         continue
      fi

      IFS=" "
      set $REPO_LINE
      
      REPO_URL="$2"
      BRANCH="$3"
      RC=
    
      if ! [ -d "$REPO_DIR/$REPO_NAME" ]; then 
         # fetch 
         pushd "$REPO_DIR" >/dev/null
         git clone "$REPO_URL" "$REPO_NAME"
         RC=$?
         popd >/dev/null

      else
         # refresh 
         pushd "$REPO_DIR/$REPO_NAME" >/dev/null
	 git checkout master
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

      if grep -q "^ref:" .git/HEAD; then
	  git pull
	  RC=$?

	  if [ $RC -ne 0 ]; then
              echo >&2 "Failed to pull latest branch \"$BRANCH\" in $REPO_DIR/$REPO_NAME"
              exit 1
	  fi
      else
	  echo "Skipping pull, on detached head."
      fi

      popd >/dev/null
   fi
done <<EOF
$(ls "$MD_DIR")
EOF

exit 0
