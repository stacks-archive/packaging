#!/bin/bash

# This script will inspect the source Python
# package, get its version, and if it's newer
# than the version in PyPI, it will upload it.

set -u

PKG_SRC="$1"
PKG_METADATA="$2"
PYPI_SECRETS="$3"

REPO="https://pypi.python.org/pypi"

pushd "$PKG_SRC" > /dev/null
PKG_NAME="$(python ./setup.py --name)"
popd > /dev/null

# meant for PyPI?
if ! [ -f "$PKG_METADATA/pypi.txt" ]; then 
   echo >&2 "No PyPI credentials for $PKG_NAME"
   exit 0
fi

# which PyPI user?
PYPI_USER="$(cat "$PKG_METADATA/pypi.txt" | egrep "^user " | awk '{print $2}')"
PYPI_SECRET="$(cat "$PKG_METADATA/pypi.txt" | egrep "^password " | awk '{print $2}')"

LOCAL_VERSION="$(cat "$PKG_METADATA/version.txt")"
PIP_VERSION="$(pip search "$PKG_NAME" | egrep "^${PKG_NAME} " | awk '{print $2}' | sed 's/[()]//g')"

if [[ "$LOCAL_VERSION" == "$PIP_VERSION" ]]; then
   echo >&2 "$PKG_NAME is up-to-date on PyPI"
   exit 0
fi

# get PyPI secret, if not already given
if [ -z "$PYPI_SECRET" ]; then 
   if [ -f "$PYPI_SECRETS/$PYPI_USER" ]; then 
      PYPI_SECRET="$(cat "$PYPI_SECRETS/$PYPI_USER")"
   else
      # this is a bug
      echo >&2 "No PyPI secret for $PYPI_USER"
      exit 1
   fi
fi

# synchronize
pushd "$PKG_SRC" > /dev/null

# register
test -d dist/ && rm -rf dist/
python ./setup.py sdist

# upload
TWINE_USERNAME="$PYPI_USER" TWINE_PASSWORD="$PYPI_SECRET" twine upload dist/*
RC=$?

popd > /dev/null

exit $RC

