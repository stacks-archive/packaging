REPO_DIR="$1"

usage() {
   echo >&2 "Usage: $0 SOURCE_DIR"
   exit 1
}

if [ -z "$REPO_DIR" ]; then 
   usage
fi

BUILD_DIR="$(mktemp -d)"

DEB_PATH=$BUILD_PATH/blockstack-browser-$VERSION

LIB_PATH=/usr/local/lib/blockstack-browser

pushd $REPO_DIR

npm install
./node_modules/.bin/gulp prod

mkdir -p $BUILD_DIR

OUTPATH=$BUILD_DIR$LIB_PATH
BINPATH=$BUILD_DIR/usr/local/bin

mkdir -p $OUTPATH
mkdir -p $BINPATH

echo "Copying gulped build"
cp -r ./build $OUTPATH
mv $OUTPATH/build $OUTPATH/browser

cp native/blockstackProxy.js $OUTPATH

echo "Install the CORS Proxy"
mkdir -p $OUTPATH/corsproxy/node_modules
npm install corsproxy --prefix $OUTPATH/corsproxy
chmod -R 0555 $OUTPATH/corsproxy

echo "Make run scripts"

echo "#!/bin/bash" > $BINPATH/blockstack-browser
echo "nodejs $LIB_PATH/blockstackProxy.js 8888 $LIB_PATH/browser" >> $BINPATH/blockstack-browser

echo "#!/bin/bash" > $BINPATH/blockstack-cors-proxy
echo "$LIB_PATH/corsproxy/node_modules/.bin/corsproxy" >> $BINPATH/blockstack-cors-proxy

chmod 0555 $BINPATH/blockstack-cors-proxy
chmod 0555 $BINPATH/blockstack-browser

popd

echo "SUCCESS: $BUILD_DIR"
exit 0
