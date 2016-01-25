#!/bin/bash

if ! [ $1 ]; then
   echo "Usage: $0 PKG_DIR BUILD_ROOT [OUTPUT_DIR]"
   exit 1
fi


PKGDIR="$1"
ROOT="$2"
OUTPUT="$3"
if [ -z "$OUTPUT" ]; then 
   OUTPUT="./"
fi

pkg_slurp() {

   local RC
   cat "$PKGDIR"/"$1"

   RC=$?
   if [ $RC -ne 0 ]; then
      echo >&2 "Failed to read $PKGDIR/$1"
      exit 1
   fi

   return 0
}
   
NAME="$(pkg_slurp name.txt)"
VERSION="$(pkg_slurp version.txt)"
URL="$(pkg_slurp url.txt)"
DESCRIPTION="$(pkg_slurp description.txt)"
LICENSE="$(pkg_slurp license.txt)"
MAINTAINER="$(pkg_slurp maintainer.txt)"
DEPS="$(pkg_slurp deps-deb.txt)"
ARCH="$(pkg_slurp arch.txt)"

if [ -z "$ARCH" ]; then 
   ARCH="$(uname -p)"
fi

DEPARGS=""
for pkg in $DEPS; do
   DEPARGS="$DEPARGS -d $pkg"
done

mkdir -p "$OUTPUT"
pushd "$OUTPUT" >/dev/null
fpm --force -s dir -t deb -a "$ARCH" -v "$VERSION" -n "$NAME" $DEPARGS -C $ROOT --license "$LICENSE" --vendor "$VENDOR" --maintainer "$MAINTAINER" --url "$URL" --description "$DESCRIPTION" $(ls "$ROOT")
RC=$?
popd >/dev/null

exit $RC
