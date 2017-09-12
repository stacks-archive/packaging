#!/bin/sh

# deploy script
REPO_KEY=~/.ssh/blockstack-apt.rsa
REPO_HOST=packages.blockstack.com
REPO_USER=ubuntu
REPO_NAME=windows

REPO_SRV_DIR=/var/www/html/repositories/windows
REPO_UPLOAD_DIR="/home/ubuntu/repo-windows"

INSTALLER_OUT="$1"

if [ -z "$INSTALLER_OUT" ]; then
   echo >&2 "Usage: $0 path/to/installer.exe"
   exit 1
fi

ssh -i "$REPO_KEY" -t -t -o RequestTTY=force $REPO_USER@$REPO_HOST "test -d $REPO_UPLOAD_DIR && rm -rf $REPO_UPLOAD_DIR; test -d $REPO_SRV_DIR && sudo rm -rf $REPO_SRV_DIR; mkdir -p $REPO_UPLOAD_DIR ; true"
if [ $? -ne 0 ]; then
   echo >&2 "Failed to clear old repository"
   exit 1
fi

scp -i "$REPO_KEY" "$INSTALLER_OUT" $REPO_USER@$REPO_HOST:$REPO_UPLOAD_DIR
if [ $? -ne 0 ]; then
   echo >&2 "Failed to upload new repository"
   exit 1
fi

ssh -i "$REPO_KEY" -t -t -o RequestTTY=force $REPO_USER@$REPO_HOST "sudo cp -a $REPO_UPLOAD_DIR $REPO_SRV_DIR"
if [ $? -ne 0 ]; then
   echo >&2 "Failed to stage new repository"
   exit 1
fi

