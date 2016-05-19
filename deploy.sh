#!/bin/sh

# deploy script 
REPO_KEY=~/.ssh/blockstack-apt.rsa
REPO_HOST=23.96.59.114
REPO_USER=ubuntu
REPO_NAME=ubuntu
REPO_SRV=/var/www/html/repositories

DEBS_REPO_OUT="$1"
if [ -z "$DEBS_REPO_OUT" ]; then 
   echo >&2 "Usage: $0 path/to/debs"
   exit 1
fi

ssh -i "$REPO_KEY" -t -t -o RequestTTY=force $REPO_USER@$REPO_HOST "test -d repo-$REPO_NAME && rm -rf repo-$REPO_NAME; test -d $REPO_SRV/$REPO_NAME && sudo rm -rf $REPO_SRV/$REPO_NAME; true"
if [ $? -ne 0 ]; then 
   echo >&2 "Failed to clear old repository"
   exit 1
fi

scp -i "$REPO_KEY" -r "$DEBS_REPO_OUT" $REPO_USER@$REPO_HOST:~/repo-$REPO_NAME
if [ $? -ne 0 ]; then 
   echo >&2 "Failed to upload new repository"
   exit 1
fi

ssh -i "$REPO_KEY" -t -t -o RequestTTY=force $REPO_USER@$REPO_HOST "sudo cp -a repo-$REPO_NAME $REPO_SRV/$REPO_NAME"
if [ $? -ne 0 ]; then 
   echo >&2 "Failed to stage new repository"
   exit 1
fi

