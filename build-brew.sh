#!/bin/sh

BREW_SOURCE="$1"
OUTPUT_FILE="$2"

if [ -z "$BREW_SOURCE" ] || [ -z "$OUTPUT_FILE" ]; then 
   echo >&2 "Usage: $0 /path/to/brew/source/template.rb.in /path/to/brew/output.rb"
   exit 1
fi

ENV_DIR="$(mktemp -d)" || exit 1
RES_FILE="$(mktemp)" || exit 1
PYPI_JSON="$(mktemp)" || exit 1

cleanup_exit() {
   test -d "$ENV_DIR" && rm -rf "$ENV_DIR"
   test -f "$RES_FILE" && rm -f "$RES_FILE"
   test -f "$PYPI_JSON" && rm -f "$PYPI_JSON"
   exit $1
}

virtualenv "$ENV_DIR" || cleanup_exit 1

source "$ENV_DIR/bin/activate" || cleanup_exit 1

curl -L "https://pypi.io/pypi/blockstack/json" > "$PYPI_JSON" || cleanup_exit 1

PACKAGE_URL="$(cat "$PYPI_JSON" | jq '.urls[0].url')" || cleanup_exit 1
PACKAGE_SHA256="$(cat "$PYPI_JSON" | jq '.urls[0].digests.sha256')" || cleanup_exit 1

pip install blockstack homebrew-pypi-poet || cleanup_exit 1
poet blockstack > "$RES_FILE" 
if [ $? -ne 0 ]; then
   cleanup_exit 1
fi

RES="$(cat "$RES_FILE" | tr '\n' '@')"

echo ""
echo "$PACKAGE_URL"
echo "$PACKAGE_SHA256"
echo ""

cat "$BREW_SOURCE" | sed -e "s~@@PACKAGE_URL@@~$PACKAGE_URL~g" -e "s~@@PACKAGE_SHA256@@~$PACKAGE_SHA256~g" | sed "s~@@RESOURCES@@~$RES~g" | tr '@' '\n' > "$OUTPUT_FILE"

cleanup_exit 0
